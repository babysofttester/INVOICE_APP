# InvoiceNow — Flutter Invoice Generator (UI skeleton)

Cross-platform (Android, iOS, Web, Desktop) UI shell built with Flutter.

## Run it
```
flutter pub get
flutter run          # any connected device/emulator
flutter run -d chrome # web preview
```

## What's included
- Splash screen with animated logo
- Home screen: stats + "Generate Invoice" CTA + recent invoices
- Bottom menu bar: Home / Invoices / Settings
- Signature "receipt" card widget (scalloped bottom edge)
- Responsive: content is centered and width-capped on wide/web screens

## Not included yet (next phases from the project plan)
- Item-entry form (name, price, qty, discount)
- PDF generation (`pdf` + `printing` packages)
- Local storage (`path_provider` + `sqflite`/`hive`)
- Share/export (`share_plus`)

Add these packages to `pubspec.yaml` when you build those phases.
