# Privacy Policy

**Applies to all four applications:**
- Appliance Warranty Manager (Bundle ID: `com.nordicassetsuite.appliance`)
- Coffee Brew & Espresso Log (Bundle ID: `com.nordicassetsuite.coffee`)
- E-Bike Service & Maintenance (Bundle ID: `com.nordicassetsuite.ebike`)
- Ski & Snowboard Gear Tuning (Bundle ID: `com.nordicassetsuite.skigear`)

**Effective Date:** August 25, 2026

---

## 1. Our Privacy Promise: Local-First by Design

These applications are built on a strict **local-first privacy architecture**. Your household, appliance, coffee, e-bike, and ski equipment data belongs exclusively to you and never leaves your device except when you explicitly choose to back it up to your own private iCloud account.

We do **not** operate any user-facing servers that store your personal content. We do **not** sell, rent, or share your data with third parties. We do **not** display advertisements. We do **not** use third-party analytics or tracking SDKs.

## 2. Data We Process

| Data Type | Purpose | Where It Is Stored |
|---|---|---|
| Product records you create (brand, model, serial number, purchase date, price, room/location, service history) | Core app functionality: warranty tracking, maintenance scheduling, diagnostics | On-device only (encrypted local database) |
| Camera input (rating plates, barcodes, receipts, serial badges) | OCR scanning and product identification | Processed in memory; images are never uploaded or persisted without your action |
| Photos you explicitly import | Receipt / badge archival attached to your records | On-device only |
| Language & currency preference | Localization of the interface | On-device (UserDefaults) |
| Subscription entitlement status | Unlocking Pro features via StoreKit 2 | Apple handles payment; we only verify the entitlement with Apple |

### Camera Permission
The apps request camera access solely to scan barcodes (EAN/UPC/QR), rating plates, and receipts. Camera frames are processed locally using Apple's Vision framework. No camera data is transmitted anywhere.

### AI-Assisted Identification (Optional)
If you use the optional AI product identification feature, the text query or captured image is sent to an AI inference endpoint solely to return product metadata (brand, model, specifications). Requests are stripped of account identifiers; we do not link requests to a user profile. You can use the apps fully without ever enabling this feature.

## 3. Data We Do NOT Collect

- Names, e-mail addresses, phone numbers, or postal addresses
- Precise or approximate location
- Advertising identifiers (IDFA)
- Health, financial, or contact data
- Usage analytics or behavioral fingerprints

## 4. iCloud Sync (Optional, User-Controlled)

If you enable the optional Pro cloud backup, your records are synced via **Apple CloudKit** directly between your own devices using your private iCloud account. Data in transit and at rest is encrypted by Apple. We have no access to your CloudKit container contents. Disabling sync or deleting app data removes your records.

## 5. Subscriptions & Payments

Pro subscriptions are processed entirely by Apple through the App Store (StoreKit 2). We never see or store your payment details. Subscription status is validated with Apple's servers. You may manage or cancel your subscription in your Apple ID account settings at any time.

## 6. Legal Basis & Your Rights (GDPR / Swiss FADP / Turkish KVKK)

For users in the European Union, Switzerland, the United Kingdom, Norway, Denmark, Sweden, and Türkiye, we process the minimal data described above under the legal basis of **legitimate interest** (providing the requested local functionality) and **contract performance** (subscription features).

Because nearly all data remains on your device, most data-subject requests are fulfilled directly by you through the app (export via PDF reports, deletion via app settings or app uninstall).

You have the right to:
- **Access** your data (all records are visible and exportable in-app)
- **Rectify** your data (editable in-app)
- **Erase** your data (delete individual records or uninstall the app; optionally wipe iCloud backup)
- **Restrict or object** to processing (disable optional AI and sync features in Settings)
- **Data portability** (PDF export)
- **Lodge a complaint** with your local supervisory authority

For any privacy question or to exercise rights that you cannot perform in-app, contact: **privacy@nordicasset.app**

## 7. Data Retention

- On-device data persists until you delete it or uninstall the app.
- iCloud backups persist until you delete them from your iCloud account.
- We retain no server-side copies of your content.

## 8. Children's Privacy

The applications are rated 4+ and do not knowingly collect any data from children. All data entry is performed locally by the device owner.

## 9. Third-Party Disclosure

We do not disclose personal data to third parties. The only third-party services involved in app operation are:
- **Apple Inc.** (App Store distribution, StoreKit payment processing, optional CloudKit sync, Vision OCR on-device)
- **AI inference provider** (only when you actively use the optional AI identification feature; queries contain no account identifiers)

## 10. Security

- Local database records are stored within the app sandbox.
- Sensitive entitlement and key material is stored in the iOS Keychain.
- Network communication (App Store validation, optional AI feature) uses TLS (App Transport Security enforced).

## 11. Changes to This Policy

We may update this policy from time to time. Material changes will be announced in the App Store "What's New" notes. The effective date above reflects the latest revision.

## 12. Contact

Data Protection Officer: **privacy@nordicasset.app**

---

*This privacy policy covers all four listed applications under a single policy as permitted by App Store Connect. Each app references this policy in its App Store listing and in-app Settings.*
