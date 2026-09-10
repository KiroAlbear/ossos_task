# ossos_task

A new Flutter project.

## Windows Android builds

Keep the Pub cache on the same drive as the project. Kotlin incremental
compilation cannot store relative source paths across Windows drive letters.
For a checkout on `I:`, configure PowerShell once:

```powershell
[Environment]::SetEnvironmentVariable('PUB_CACHE', 'I:\Pub\Cache', 'User')
$env:PUB_CACHE = 'I:\Pub\Cache'
flutter clean
flutter pub get
flutter build apk --debug
```

Restart your IDE and existing terminals after setting the user environment
variable so future package resolution uses the new cache. If the checkout moves
to another drive, update `PUB_CACHE` to match. Kotlin incremental compilation
remains enabled in `android/gradle.properties`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
