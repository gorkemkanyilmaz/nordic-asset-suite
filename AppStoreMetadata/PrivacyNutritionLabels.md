# Apple App Store Privacy Nutrition Label Declarations

**Compliance Standard:** GDPR (EU Regulation 2016/679) & Swiss FADP (Federal Act on Data Protection)  
**Applicable Apps:** All 4 Applications in the Nordic Asset Suite

---

## 1. Tracking Data
> **Data Used to Track You:** **NO DATA COLLECTED**
>
> The Nordic Asset Suite does not include third-party advertising SDKs, tracking frameworks, or data broker integrations. We never track users across third-party apps and websites.

---

## 2. Data Linked to the User
> **Data Linked to You:** **NO DATA COLLECTED**
>
> We do not require mandatory account registration. All asset models, serial numbers, and service logs are stored locally in the device's secure sandbox or synchronized privately to the user's personal iCloud CloudKit container.

---

## 3. Data Not Linked to the User

### 3.1 Purchases & Entitlements
* **Data Type:** Financial Info / In-App Purchases
* **Purpose:** App Functionality (StoreKit 2 entitlement validation)
* **Linked to User:** No (Handled via Apple's anonymized transaction identifiers)

### 3.2 User Content (Scanned Receipts & Photos)
* **Data Type:** Photos, Document Scans, Hardware Serials
* **Purpose:** App Functionality (Local OCR & Asset Ingestion)
* **Linked to User:** No
* **Processing:** 100% on-device by default via Apple Vision. Prior to any optional external AI diagnostic consultation, on-device PII scrubbers permanently redact credit cards, names, IBANs, and phone numbers.

### 3.3 Diagnostics & Crash Telemetry
* **Data Type:** Performance data, Crash logs
* **Purpose:** App Stability & Bug Fixing
* **Linked to User:** No (Anonymized system diagnostics)

---

## 4. Privacy Contact & Legal Links
* **Privacy Policy URL:** `https://nordicassetsuite.com/privacy`
* **Terms of Service (EULA) URL:** `https://nordicassetsuite.com/terms`
* **Data Protection Officer (DPO) Contact:** `privacy@nordicassetsuite.com`
