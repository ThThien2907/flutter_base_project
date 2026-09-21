# flutter_base_project


```sh
dart run build_runner build --delete-conflicting-outputs
```
# Flavors

Available flavors:

- `dev` -> `.env.dev`
- `prod` -> `.env.prod`

Run:

```sh
flutter run --flavor dev --dart-define=FLAVOR=dev
flutter run --flavor prod --dart-define=FLAVOR=prod
```

Build APK:

```sh
flutter build apk --release --flavor dev --dart-define=FLAVOR=dev --split-per-abi --obfuscate --split-debug-info=build/debug-info --tree-shake-icons
flutter build apk --release --flavor prod --dart-define=FLAVOR=prod --split-per-abi --obfuscate --split-debug-info=build/debug-info --tree-shake-icons
```
