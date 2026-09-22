# flutter_base_project

## Responsive sizing

The app is initialized with `flutter_screenutil_plus` using a `375 x 812`
design frame. Update `AppScreenConfig.designSize` when the source design uses a
different base frame.

- Define raw design tokens such as `xs`, `sm`, and `md` in `AppDimensions`.
- Use `AppSpacing.horizontal(AppDimensions.md)` and
  `AppSpacing.vertical(AppDimensions.md)` for gaps; these apply `.w` and `.h`.
- Use `.r` for padding and radius, `.w` for width, `.h` for height, and `.sp`
  for font size. `AppTextStyles` already applies `.sp` to every text token.
- Icon and radius tokens already apply `.r`, so use `AppDimensions.iconLg` and
  `AppDimensions.radiusLg` directly.


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
