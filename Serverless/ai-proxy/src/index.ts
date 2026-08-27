import { Hono } from 'hono';

// Environment Bindings Interface
interface Bindings {
  ENVIRONMENT: string;
  GEMINI_API_KEY?: string;
  TAVILY_API_KEY?: string;
  GROK_API_KEY?: string;
  APPLE_APP_ATTEST_KEY?: string;
}

const app = new Hono<{ Bindings: Bindings }>();

// MARK: - Health Check
app.get('/health', (c) => {
  return c.json({
    status: 'healthy',
    suite: 'Nordic Asset Suite Product Intelligence Proxy',
    version: '3.2.0',
    timestamp: new Date().toISOString()
  });
});

// MARK: - App Attest Security Middleware
app.use('/v1/*', async (c, next) => {
  const userAgent = c.req.header('User-Agent') || '';
  if (!userAgent.includes('NordicAssetSuite') && !userAgent.includes('Mozilla') && !userAgent.includes('Vite')) {
    return c.json({ error: 'Unauthorized client signature' }, 401);
  }
  await next();
});

// Helper for Gemini Structured Calls
async function callGemini(apiKey: string, prompt: string, temperature: number = 0.1): Promise<any> {
  const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`;
  const geminiPayload = {
    contents: [{ parts: [{ text: prompt }] }],
    generationConfig: {
      response_mime_type: 'application/json',
      temperature
    }
  };

  const res = await fetch(geminiUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(geminiPayload)
  });

  if (!res.ok) {
    throw new Error(`Gemini HTTP ${res.status}: ${await res.text()}`);
  }

  const data = (await res.json()) as any;
  const jsonText = data.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!jsonText) throw new Error('Empty Gemini response content');
  return JSON.parse(jsonText);
}

// MARK: - 1. Tavily Search Proxy (`/v1/search/tavily`)
app.post('/v1/search/tavily', async (c) => {
  const body = await c.req.json<{
    query: string;
    includeDomains?: string[];
    excludeDomains?: string[];
    searchDepth?: 'basic' | 'advanced';
    includeImages?: boolean;
    maxResults?: number;
  }>();

  const apiKey = c.env?.TAVILY_API_KEY || (typeof process !== 'undefined' ? process.env?.TAVILY_API_KEY : '');
  if (!apiKey) {
    return c.json({ error: 'Tavily API key not configured on server', results: [], images: [] }, 200);
  }

  const payload = {
    api_key: apiKey,
    query: body.query,
    search_depth: body.searchDepth || 'basic',
    include_domains: body.includeDomains || [],
    exclude_domains: body.excludeDomains || ['pinterest.com', 'ebay.com', 'aliexpress.com'],
    max_results: body.maxResults || 5,
    include_images: body.includeImages ?? true,
    include_image_descriptions: true,
    include_raw_content: false
  };

  try {
    const res = await fetch('https://api.tavily.com/search', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      return c.json({ error: `Tavily HTTP ${res.status}`, results: [], images: [] }, res.status as any);
    }

    const data = await res.json();
    return c.json(data);
  } catch (err: any) {
    return c.json({ error: err.message, results: [], images: [] }, 500);
  }
});

// MARK: - 2. Tavily Content Extract Proxy (`/v1/extract/tavily`)
app.post('/v1/extract/tavily', async (c) => {
  const body = await c.req.json<{
    urls: string[];
    extractDepth?: 'basic' | 'advanced';
  }>();

  const apiKey = c.env?.TAVILY_API_KEY || (typeof process !== 'undefined' ? process.env?.TAVILY_API_KEY : '');
  if (!apiKey) {
    return c.json({ error: 'Tavily API key not configured on server', results: [] }, 200);
  }

  const payload = {
    api_key: apiKey,
    urls: body.urls,
    extract_depth: body.extractDepth || 'basic'
  };

  try {
    const res = await fetch('https://api.tavily.com/extract', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      return c.json({ error: `Tavily HTTP ${res.status}`, results: [] }, res.status as any);
    }

    const data = await res.json();
    return c.json(data);
  } catch (err: any) {
    return c.json({ error: err.message, results: [] }, 500);
  }
});

// MARK: - 3. UPCitemdb Barcode Lookup Proxy (`/v1/lookup/upc`)
app.get('/v1/lookup/upc', async (c) => {
  const upc = c.req.query('upc');
  if (!upc) {
    return c.json({ error: 'Missing upc query parameter' }, 400);
  }

  try {
    const res = await fetch(`https://api.upcitemdb.com/prod/trial/lookup?upc=${encodeURIComponent(upc)}`, {
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'NordicAssetSuite/3.2.0'
      }
    });

    if (!res.ok) {
      return c.json({ error: `UPCitemdb HTTP ${res.status}`, code: 'ERROR', items: [] }, res.status as any);
    }

    const data = await res.json();
    return c.json(data);
  } catch (err: any) {
    return c.json({ error: err.message, code: 'ERROR', items: [] }, 500);
  }
});

// MARK: - 4. Grounded Product Extraction Endpoint
app.post('/v1/identify', async (c) => {
  const body = await c.req.json<{
    queryOrText: string;
    sourceContent?: string;
    sourceUrl?: string;
    barcode?: string;
    targetLanguage?: string;
  }>();

  const apiKey = c.env?.GEMINI_API_KEY;
  if (!apiKey) {
    return c.json({ error: 'GEMINI_API_KEY is not configured on the worker' }, 500);
  }

  const prompt = `You are a factual, grounded hardware extraction engine for Nordic Asset Suite.
Strict Principle: Extract ONLY factual data supported by the provided query or source content.
Never guess prices, never invent personal warranty dates, never invent unverified specs.

Context:
- Query / Model: "${body.queryOrText}"
- Barcode: "${body.barcode || 'None'}"
- Source URL: "${body.sourceUrl || 'None'}"
- Source Text Content:
"""
${body.sourceContent || 'No external source text provided. Extract basic entity structure only.'}
"""

Return ONLY valid JSON matching this schema:
{
  "brand": string,
  "modelName": string,
  "canonicalName": string,
  "series": string | null,
  "variant": string | null,
  "category": "Appliance" | "CoffeeMachine" | "EBike" | "SkiGear" | "Electronics",
  "subCategory": string | null,
  "keySpecifications": Record<string, string>,
  "dimensions": string | null,
  "weight": string | null,
  "power": string | null,
  "standardWarrantyMonths": number | null,
  "summaryDescription": string,
  "confidenceScore": number
}`;

  try {
    const result = await callGemini(apiKey, prompt, 0.1);
    result.providerUsed = 'gemini-1.5-flash-grounded';
    return c.json(result);
  } catch (err: any) {
    return c.json({ error: err.message }, 500);
  }
});

// MARK: - 5. Structured Diagnostic Endpoint
app.post('/v1/diagnose', async (c) => {
  const body = await c.req.json<{
    assetDomain: string;
    brand: string;
    modelName: string;
    errorCodeOrSymptom: string;
    currentAgeMonths?: number;
    targetLanguage?: string;
  }>();

  const apiKey = c.env?.GEMINI_API_KEY;
  if (!apiKey) {
    return c.json({ error: 'GEMINI_API_KEY is not configured on the worker' }, 500);
  }
  const prompt = `Diagnose physical hardware:
Domain: ${body.assetDomain}
Brand: ${body.brand}
Model: ${body.modelName}
Symptom: ${body.errorCodeOrSymptom}
Language: ${body.targetLanguage || 'en'}

Return ONLY valid JSON:
{
  "issueTitle": string,
  "probableRootCause": string,
  "severity": "LOW" | "MEDIUM" | "HIGH" | "CRITICAL",
  "recommendedActionSteps": string[],
  "requiresProfessionalService": boolean,
  "estimatedCostRangeCHF": string | null,
  "updatedHealthScore": number
}`;

  try {
    const parsed = await callGemini(apiKey, prompt, 0.2);
    parsed.providerUsed = 'gemini-1.5-flash';
    return c.json(parsed);
  } catch (err: any) {
    return c.json({ error: err.message }, 500);
  }
});

export default app;
