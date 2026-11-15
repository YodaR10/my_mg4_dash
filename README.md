# my_mg4_dash

Flutter **Android Automotive (AAOS)** infotainment demo built on
[`liquid_glass_easy`](https://pub.dev/packages/liquid_glass_easy) — an
iOS 26-style *Liquid Glass* interface for the car.

## Target

**Android Automotive only.** The APK declares
`android.hardware.type.automotive` as a required feature, so it is
installable on AAOS devices only — not on handheld phones, not on iOS, not
on the web, not on desktop.

The `ios/`, `web/`, `linux/`, `macos/` and `windows/` folders are not part of
this project.

## Run it

```bash
flutter pub get

# Start the AAOS emulator (Android Studio → Device Manager → "Car on arm64").
flutter emulators
flutter run -d emulator-5554
```

## Build it

```bash
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

## Checks

```bash
flutter analyze
flutter test
```

## Docs

- [`AGENTS.md`](AGENTS.md) — project working reference (glass API, automotive
  HMI rules, performance checklist).
- [`docs/hmi_guidelines.md`](docs/hmi_guidelines.md) — automotive HMI
  guidelines: cognitive load, hit targets, day/night adaptivity, multimodal
  access, context-driven layout.
