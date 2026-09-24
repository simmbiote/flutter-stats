# Quickstart: Validate Add Health Connect Sync

This guide validates the planned implementation end to end. It is a runbook, not a replacement for implementation code. The domain and API rules are in [`data-model.md`](data-model.md) and [`contracts/`](contracts/).

## Prerequisites

- Flutter `3.41.6` stable and Dart `3.11.4` (or a compatible pinned toolchain).
- Android SDK/API 36 and JDK 21.
- An Android device or emulator running Android 9/API 28 or newer with Google Play services.
- Health Connect available on the test device, or a device where the unavailable state can be verified.
- A physical Samsung device running Samsung Health for source-origin testing when available.
- A test receiving service or the repository's test fake; never use production health data in development.
- A deployment-provided installation credential for a staging endpoint. Do not commit it to source control.

## Bootstrap the Flutter project

From the repository root:

```sh
flutter create --project-name flutter_stats --org com.example --platforms=android,ios .
flutter pub add health:^13.3.2
flutter pub add workmanager:^0.10.10
flutter pub add flutter_riverpod:^3.4.3
flutter pub add dio:^5.11.1
flutter pub add drift:^2.35.0 drift_flutter:^0.3.1
flutter pub add flutter_secure_storage:^11.2.0
flutter pub add cryptography:^2.9.0 cryptography_flutter:^2.3.4
flutter pub add permission_handler:^13.0.2
flutter pub add url_launcher:^6.3.2
flutter pub add path_provider:^2.1.6
flutter pub add --dev drift_dev:^2.35.0 build_runner:^2.16.1 flutter_lints:^6.0.0 mocktail:^1.0.0
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

If the pinned `health` release requires an Android SDK extension, apply the exact setup from that pinned package release. The current design expects `minSdk 28`, `compileSdk 36`, and the package's required extension configuration.

## Android configuration checklist

Before running the app, verify `android/app/src/main/AndroidManifest.xml` and the generated Android project contain:

- The Health Connect package query and permission-rationale activity/alias.
- Read permissions only for the selected activity, vitals, sleep, and body record types.
- `READ_HEALTH_DATA_IN_BACKGROUND` for automatic background reads.
- No Health Connect write permissions.
- `MainActivity` extends `FlutterFragmentActivity` as required by the selected plugin.
- Android backup disabled or secure-storage data excluded, as required by `flutter_secure_storage`.
- Network permission for the receiving API and a privacy policy/rationale surface reachable from the Health Connect permission screen.
- The exact Health Connect data-type declaration in the Play Console before any release build.

## Configure a safe test service

Use the test fake or a local mock service for development. The production base URL and installation credential are deployment inputs. A typical non-secret build configuration may provide a base URL and schema version; never place a real token in `pubspec.yaml`, source code, a checked-in `.env`, or test snapshots.

The test service must be able to return:

- `2xx` acknowledgement with accepted record IDs.
- Partial acceptance.
- `401`/`403` credential failure.
- `429`, `5xx`, timeout, and malformed-response fixtures.

## Run static and unit checks

```sh
dart format --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
```

Expected result: formatting is clean, analysis has no errors, and domain/API/state tests pass without a device.

## Device validation scenarios

Run the app on a configured Android device:

```sh
flutter devices
flutter run -d <android-device-id>
```

### 1. Health Connect unavailable

1. Use a device/emulator without a usable Health Connect service, or disable it where supported.
2. Open the connection flow.
3. Verify the app shows `unavailable`, does not claim access, does not read records, and offers an install/update/settings next step.

### 2. Permission explanation and grant

1. Start with no app permissions.
2. Open the connection flow.
3. Verify the explanation names activity, vitals, sleep, body measurements, read-only scope, automatic posting, and the receiving service.
4. Grant the required category permissions.
5. Grant background-read access when it is available and separately explained.
6. Verify the app schedules an immediate run and a periodic run without requiring a sync-button action.

### 3. Permission denial and revocation

1. Deny one category permission.
2. Verify only denied categories are blocked and no denied-category data is read.
3. Revoke a previously granted permission in Health Connect settings.
4. Resume the app and verify the state changes to reconnect/permission-required without a stale connected indicator.

### 4. Initial backfill and empty state

1. Use Health Connect Toolbox or a test source to create records in each supported category.
2. Run the first authorized processing run.
3. Verify the visible date range is the most recent 30 days, records are categorized, and source labels are preserved.
4. Repeat with no new records and verify `empty`/up-to-date is distinct from an error and no POST is made.

### 5. Automatic new data

1. Leave the app closed or backgrounded after permissions are granted.
2. Add a new record through the Health Connect Toolbox/test provider.
3. Wait for the next permitted WorkManager execution window; periodic work is not an exact alarm and may be delayed by device policy.
4. Reopen the app and verify the receiving/sending timeline, last successful time, and the posted record without a manual sync action.

For local debugging, inspect the scheduled job without changing the user contract:

```sh
adb shell dumpsys jobscheduler | grep -i <application-id>
```

### 6. Correction and deletion

1. Correct a previously posted record in Health Connect.
2. Verify an update operation uses the same `record_id` and a new `source_version`.
3. Delete the record in Health Connect.
4. Verify a delete operation is submitted for the same identity and no unrelated duplicate is created.

### 7. Network and credential failures

1. Disable network access and create a new record.
2. Verify the record remains pending, the receiving/sending states are accurate, and no success is shown.
3. Restore network access and verify automatic retry uses the same idempotency key.
4. Configure an invalid installation credential and verify the app shows a blocked sending state without exposing the credential.
5. Correct the credential and verify pending records resume.

### 8. Local data minimization

1. Inspect the app's pending queue through the test/debug inspection surface.
2. Verify unsent health payloads are encrypted and contain no plaintext values.
3. Complete an acknowledged submission and verify the local encrypted payload is deleted.
4. Disconnect and verify unsent payloads are removed while safe counts/status metadata remain.

## Automated integration run

After the implementation adds the integration test target, run:

```sh
flutter test integration_test/health_sync_e2e_test.dart -d <android-device-id>
```

The test should use fakes for the receiving service and a controlled Health Connect source. It must cover grant/deny, initial backfill, new/upsert/delete changes, automatic scheduling, retry, acknowledgement, and local payload deletion.

## Release checks

Before a release candidate:

```sh
flutter build apk --debug
flutter build apk --release --dart-define=HEALTH_API_BASE_URL=<staging-url>
flutter analyze
flutter test
```

Also complete the Health Connect data-use declaration, privacy-policy review, permission-rationale review, secure-storage backup review, and a physical-device test on the supported Samsung hardware. Confirm that logs and crash reports contain no health values or credentials.
