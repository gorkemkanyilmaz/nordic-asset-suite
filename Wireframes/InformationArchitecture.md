# Nordic Asset Suite — Information Architecture & Screen Flow Specifications

## 1. Appliance Warranty Manager (Spatial & Room-Based IA)
```text
Root: MainTabView
├── Tab 1: Rooms / Living Spaces (Spatial Hierarchy)
│   ├── Room Detail (e.g., Kitchen, Laundry Room, Utility Closet)
│   │   └── Appliance Detail Card
│   │       ├── Warranty Status & Document Vault (PDF/Receipt)
│   │       ├── Health Score & Efficiency Rating
│   │       ├── Filter Replacement Countdown
│   │       └── Error Code Scanner (Camera Vision)
├── Tab 2: Expiration Timeline (Chronological Horizon)
├── Tab 3: Maintenance & Claims Guide
└── Tab 4: Settings & CloudKit Sync Status
```

---

## 2. Ski Gear Tracker (Seasonal & Quiver-Based IA)
```text
Root: QuiverNavigationView
├── Section 1: Active Winter Quiver
│   ├── Ski Pair Detail
│   │   ├── ISO 11088 DIN Binding Calculator & Settings
│   │   ├── Snow Temperature Waxing Advisor
│   │   ├── Edge Sharpening & Base Structure Log
│   │   └── Lifespan Days & Safety Inspection Log
│   └── Boots & Poles Specs (Boot Sole Length mm, Flex Index)
├── Section 2: Summer Storage & Off-Season Vault
├── Section 3: Mountain Weather & Wax Advisor Quick Tool
└── Section 4: Settings & Equipment Export
```

---

## 3. E-Bike Service & Warranty Tracker (Garage & Telemetry IA)
```text
Root: GarageDashboardView
├── Active Bike Selector (Carousel / Digital Twin)
│   ├── Metric 1: Battery Health & Cycle Degradation
│   ├── Metric 2: Chain Stretch & Drivetrain Wear Gauge (0.5% vs 0.75%)
│   ├── Metric 3: Brake Pad & Rotor Thickness
│   └── Metric 4: Fork / Shock Air Pressure (PSI Calculator based on rider weight)
├── Service History & Maintenance Cost Journal
├── Warranty Expiry & Motor/Battery Diagnostic Codes
└── Settings, Strava/Distance Sync & Profile
```

---

## 4. Coffee Machine Companion (Workflow & Barista IA)
```text
Root: BaristaDeckView
├── Deck 1: Daily Dial-In & Brew Recipe Log (Ratio, Grind Size, Brew Time)
├── Deck 2: Machine Health & Descaling Matrix
│   ├── Water Hardness Profile (°dH / °fH calibration)
│   ├── Descaling Cycle Countdown & Step-by-Step Guide
│   └── Water Filter Lifespan & Cartridge Tracker
├── Deck 3: Grinder Maintenance & Burr Lifespan (Total KG Ground vs Burr Limit)
└── Deck 4: Machine Settings, Manuals & Bean Cellar
```
