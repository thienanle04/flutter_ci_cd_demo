# Flutter CI/CD demo — Codemagic + Firebase App Distribution

This repo contains a minimal Flutter scaffold and a Codemagic pipeline example for
building Android App Bundles (`.aab`) and deploying to Firebase App Distribution.

Files added:
- `pubspec.yaml` — minimal Flutter pubspec
- `lib/main.dart` — minimal app entry
- `android/key.properties.template` — example local key props (do NOT commit real secrets)
- `android/app/build.gradle` — example signing snippet showing how to read `key.properties`
- `codemagic.yaml` — Codemagic pipeline config (trigger: push to `main`)
- `scripts/deploy_firebase.sh` — deploy script using `firebase-tools`

Setup (local / Codemagic):

1. If you don't have a full Flutter project yet, run locally:

```bash
flutter create .
```

2. Update Android signing (local):
   - Create `android/key.properties` from `android/key.properties.template` with real values.
   - Place your `keystore.jks` in `android/app/keystore.jks` (or update `storeFile` path).

3. Codemagic configuration:
   - Add the following environment variables in Codemagic (Project settings -> Environment variables):
     - `FIREBASE_TOKEN` (secure)
     - `FIREBASE_APP_ID` (secure)
   - Optional (if using keystore in CI):
     - `ANDROID_KEYSTORE_BASE64` — base64 of your keystore file (secure)
     - `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD` (secure)

      - Optional Firebase distribution targets:
        - `groups` or `FIREBASE_GROUPS` — comma-separated distribution groups (e.g. "qa,internal"). `groups` is supported for compatibility with some Codemagic examples.
        - `FIREBASE_TESTERS` — comma-separated tester emails
        - `FIREBASE_RELEASE_NOTES` — custom release notes for this distribution

   To create `ANDROID_KEYSTORE_BASE64`:

```bash
base64 android/app/keystore.jks | pbcopy
# then paste into Codemagic secure variable
```

4. Trigger pipeline: push to `main` or run workflow manually in Codemagic.

Notes:
- Never commit keystore or credentials. Use Codemagic secure variables.
- The `codemagic.yaml` includes comments explaining each step.
