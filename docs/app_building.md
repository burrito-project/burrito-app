<!-- markdownlint-disable MD033 MD042 -->

# Building the mobile client

For more in-depth information refer to
[the official Flutter build docs](https://docs.flutter.dev/deployment/android#build-the-app-for-release).

<div class="warning">
Note that this documentation is only for Android. Altough Flutter fully
supports iOS, we have not tested it yet with this project.

There is a working workflow called ios-compilation.yml in the .github/workflows
directory that you can check.
</div>

## Building the APK

To build APKs for multiple architectures (e.g., ARM, ARM64, x86), use the following command. This will generate separate APK files for each ABI (Application Binary Interface), allowing users to download the appropriate APK for their device's architecture:

```json
flutter build apk --split-per-abi
```

The APKs will be saved under the `build/app/outputs/flutter-apk/` directory. You can find the generated APKs in that folder, ready for testing or distribution.

## Build an App Bundle for Release

In addition to building APKs, it's also a good practice to generate an App Bundle (.aab) for releasing the app to the Google Play Store. The App Bundle contains everything needed for distribution, and Google Play will optimize the app for different device configurations automatically.

To build a release version of the App Bundle, use the following command:

```json
flutter build appbundle --release
```

Once the build is completed, the .aab file will be available in the `build/app/outputs/bundle/release/` directory. You can upload this file to the Google Play Console or any other app store that supports App Bundles.
