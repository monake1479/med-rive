# Med Rive

Med Rive is a Flutter prototype for a mobile Medcare / Wellness app. The project showcases application architecture, integration with a mock backend, and interactive Rive animations.

The app includes first-run onboarding, breathing pace selection, and a personalized plan based on a mock user profile. A continuous Rive ribbon responds to navigation and the selected breathing pace. This is a technical demo for iOS and Android.

The project uses Flutter 3.50.0, managed with [FVM](https://fvm.app/).

## Tools and libraries

- Flutter / Dart with Material 3 (`material_ui`) and Google Fonts
- BLoC / Cubit and Equatable for state management
- `get_it` and `injectable` for dependency injection
- `go_router` and `go_router_builder` for type-safe navigation
- Rive for state machines, data binding, and interactive animations
- `shared_preferences` for local persistence and a simulated backend
- Flutter localization tools and `intl` for localized strings
- `flutter_test`, `bloc_test`, `mocktail`, and `integration_test` for testing

## Getting started

Install [FVM](https://fvm.app/) and the Flutter platform tools for Android or iOS (Android SDK or Xcode with CocoaPods). From the project root, run:

```sh
fvm install
fvm flutter pub get
fvm dart run build_runner build
fvm flutter gen-l10n
fvm flutter run
```

Start an Android emulator or iOS simulator, or connect a device before running the app. No backend service, API keys, or environment files are required.

Run unit and widget tests with:

```sh
fvm flutter test
```

## Rive animation

The animation was exported using Rive's free plan.

## Application structure

```text
lib/
├── common/
│   ├── data/
│   │   ├── onboarding/
│   │   ├── breathing_pace/
│   │   └── user/
│   ├── error_handling/
│   ├── injection/
│   ├── l10n/
│   ├── navigation/
│   │   └── routes/
│   ├── rive/
│   │   ├── shared/
│   │   └── ribbon/
│   └── widgets/
├── features/
│   ├── startup/
│   ├── onboarding/
│   ├── breath_session/
│   └── reset_app/
├── main.dart
└── med_rive_app.dart
```

`features/` groups presentation code by feature. Presentation code lives in feature-specific `pages/`, `state/`, and `widgets/` folders. Shared data capabilities live under `common/data/<capability>/`, organized into data sources, DTOs, application models, use cases, and a repository.

Data sources handle transport or storage formats. Repositories map DTOs to application models so that use cases, Blocs, and UI code do not depend on JSON or backend response shapes.

The data flow is:

```text
UI → Bloc / Cubit → use case → repository → data source
```
