import { Hono } from 'hono';

// Environment Bindings Interface
interface Bindings {
  ENVIRONMENT: string;
  GEMINI_API_KEY: string;
  GROK_API_KEY: string;
  APPLE_APP_ATTEST_KEY?: string;
}

const app = new Hono<{ Bindings: Bindings }>();

// MARK: - Health Check
app.get('/health', (c) => {
  return c.json({
    status: 'healthy',
    suite: 'Nordic Asset Suite AI Proxy',
    version: '3.0.0',
    timestamp: new Date().toISOString()
  });
});

// MARK: - App Attest Security Middleware
app.use('/v1/*', async (c, next) => {
  const userAgent = c.req.header('User-Agent') || '';
  if (!userAgent.includes('NordicAssetSuite')) {
    return c.json({ error: 'Unauthorized client signature' }, 401);
  }
  // In production, validate Apple App Attest challenge / assertion tokens
  await next();
});

// MARK: - Structured Extraction Endpoint
app.post('/v1/extract', async (c) => {
  const body = await c.req.json<{
    rawOCRText: string;
    documentType?: string;
    targetLanguage?: string;
  }>();

  if (!body.rawOCRText || body.rawOCRText.trim().length === 0) {
    return c.json({ error: 'Missing rawOCRText in payload' }, 400);
  }

  const prompt = `You are a high-precision document extraction engine for the Nordic Asset Suite.
Extract the structured asset metadata from the following OCR text.
Target Language: ${body.targetLanguage || 'en'}
Document Type: ${body.documentType || 'receipt'}

OCR Text:
${body.rawOCRText}

Return ONLY valid JSON matching this schema:
{
  "brand": string | null,
  "modelName": string | null,
  "serialNumber": string | null,
  "purchaseDateISO": string | null (YYYY-MM-DD),
  "purchasePrice": number | null,
  "currencyCode": string | null (CHF, EUR, DKK, SEK, NOK, USD),
  "detectedCategory": string | null (Appliance, SkiGear, EBike, CoffeeMachine, Receipt),
  "summaryDescription": string,
  "confidenceScore": number (0.0 to 1.0)
}`;

  // Attempt Tier 1: Gemini 1.5 Flash
  try {
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${c.env.GEMINI_API_KEY}`;
    const geminiPayload = {
      contents: [{ parts: [{ text: prompt }] }],
      generationConfig: {
        response_mime_type: 'application/json',
        temperature: 0.1
      }
    };

    const geminiResponse = await fetch(geminiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(geminiPayload)
    });

    if (geminiResponse.ok) {
      const data = (await geminiResponse.json()) as any;
      const jsonText = data.candidates?.[0]?.content?.parts?.[0]?.text;
      if (jsonText) {
        const parsed = JSON.parse(jsonText);
        parsed.providerUsed = 'gemini-1.5-flash';
        return c.json(parsed);
      }
    }
  } catch (err) {
    console.error('Gemini extraction failed, attempting Grok-2 fallback:', err);
  }

  // Attempt Tier 2: Grok 2 Fallback
  try {
    const grokUrl = 'https://api.x.ai/v1/chat/completions';
    const grokPayload = {
      model: 'grok-2',
      messages: [
        { role: 'system', content: 'You are a JSON-only asset extraction engine.' },
        { role: 'user', content: prompt }
      ],
      response_format: { type: 'json_object' },
      temperature: 0.1
    };

    const grokResponse = await fetch(grokUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${c.env.GROK_API_KEY}`
      },
      body: JSON.stringify(grokPayload)
    });

    if (grokResponse.ok) {
      const data = (await grokResponse.json()) as any;
      const content = data.choices?.[0]?.message?.content;
      if (content) {
        const parsed = JSON.parse(content);
        parsed.providerUsed = 'grok-2';
        return c.json(parsed);
      }
    }
  } catch (err) {
    console.error('Grok fallback also failed:', err);
  }

  return c.json({ error: 'All AI extraction providers exhausted' }, 503);
});

// MARK: - Structured Diagnostic Endpoint
app.post('/v1/diagnose', async (c) => {
  const body = await c.req.json<{
    assetDomain: string;
    brand: string;
    modelName: string;
    errorCodeOrSymptom: string;
    currentAgeMonths?: number;
    historicalTelemetrySummary?: string;
    targetLanguage?: string;
  }>();

  const prompt = `You are a certified master technician diagnosing physical hardware for the Nordic Asset Suite.
Domain: ${body.assetDomain}
Brand: ${body.brand}
Model: ${body.modelName}
Error Code / Symptom: ${body.errorCodeOrSymptom}
Asset Age: ${body.currentAgeMonths || 0} months
Telemetry Context: ${body.historicalTelemetrySummary || 'None'}
Response Language: ${body.targetLanguage || 'en'}

Return ONLY valid JSON matching this schema:
{
  "issueTitle": string,
  "probableRootCause": string,
  "severity": "LOW" | "MEDIUM" | "HIGH" | "CRITICAL",
  "recommendedActionSteps": string[],
  "requiresProfessionalService": boolean,
  "estimatedCostRangeCHF": string | null,
  "updatedHealthScore": number (0 to 100)
}`;

  // Attempt Tier 1: Gemini 1.5 Flash
  try {
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${c.env.GEMINI_API_KEY}`;
    const geminiPayload = {
      contents: [{ parts: [{ text: prompt }] }],
      generationConfig: {
        response_mime_type: 'application/json',
        temperature: 0.2
      }
    };

    const geminiResponse = await fetch(geminiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(geminiPayload)
    });

    if (geminiResponse.ok) {
      const data = (await geminiResponse.json()) as any;
      const jsonText = data.candidates?.[0]?.content?.parts?.[0]?.text;
      if (jsonText) {
        const parsed = JSON.parse(jsonText);
        parsed.providerUsed = 'gemini-1.5-flash';
        return c.json(parsed);
      }
    }
  } catch (err) {
    console.error('Gemini diagnostics failed, attempting Grok-2 fallback:', err);
  }

  // Attempt Tier 2: Grok 2 Fallback
  try {
    const grokUrl = 'https://api.x.ai/v1/chat/completions';
    const grokPayload = {
      model: 'grok-2',
      messages: [
        { role: 'system', content: 'You are a JSON-only diagnostic engine.' },
        { role: 'user', content: prompt }
      ],
      response_format: { type: 'json_object' },
      temperature: 0.2
    };

    const grokResponse = await fetch(grokUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${c.env.GROK_API_KEY}`
      },
      body: JSON.stringify(grokPayload)
    });

    if (grokResponse.ok) {
      const data = (await grokResponse.json()) as any;
      const content = data.choices?.[0]?.message?.content;
      if (content) {
        const parsed = JSON.parse(content);
        parsed.providerUsed = 'grok-2';
        return c.json(parsed);
      }
    }
  } catch (err) {
    console.error('Grok diagnostics fallback failed:', err);
  }

  return c.json({ error: 'All AI diagnostic providers exhausted' }, 503);
});

export default app;
