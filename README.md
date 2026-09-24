# Flutter Stats

Android-first, read-only Health Connect synchronization built with Flutter.

## What it does

- Explains and requests granular Health Connect read permissions.
- Supports activity, vitals, sleep, and body measurements.
- Treats Health Connect as the source of truth, including Samsung Health-origin records when Health Connect exposes the source.
- Polls for new records with a unique 15-minute WorkManager task and immediate resume/permission triggers.
- Queues encrypted pending payloads and posts idempotent upsert/delete operations to `POST /v1/health-records`.
- Deletes acknowledged local payloads and exposes independent receiving/sending status.
- Keeps the domain behind `HealthDataSource` so a future iOS adapter can implement the same contract.

The app never requests Health Connect write access and does not display health values in status or logs.

## Requirements

- Flutter 3.41.6 / Dart 3.11.4
- Android API 28+ and a device with Google Play services
- JDK 21
- A staging API base URL and deployment-provided installation credential for real delivery

## Run locally

```sh
flutter pub get
flutter run --dart-define=HEALTH_API_BASE_URL=https://staging.example.test
```

The installation credential is read from secure storage. Do not put credentials in `--dart-define`, source files, logs, or committed configuration.

### Safe development mode

The app includes a safe fake source used by tests and can be selected with:

```sh
flutter run --dart-define=HEALTH_USE_FAKE_SOURCE=true --dart-define=HEALTH_USE_FAKE_API=true
```

The fake source contains synthetic records only. It does not bypass production permissions, send real health data, or enable a release build credential bypass.

## Local API testing

A dependency-free mock receiving API is included:

```sh
dart run tool/mock_health_api.dart --port 8787
```

For a USB-connected Android device, run `adb reverse tcp:8787 tcp:8787`, launch the debug app with `--dart-define=HEALTH_API_BASE_URL=http://127.0.0.1:8787`, and save the development credential `dev-credential` from the in-app key dialog. See [`docs/mock-api.md`](docs/mock-api.md) for request examples and failure scenarios.

## Validate

```sh
dart format --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test/health_sync_e2e_test.dart
```

Android release validation should also follow [`specs/001-add-health-connect-sync/quickstart.md`](specs/001-add-health-connect-sync/quickstart.md), including Health Connect Toolbox scenarios, background deferral, Samsung-origin checks, and the API acknowledgement/retention checks.

## Project layout

```text
lib/app/                         composition and lifecycle
lib/core/                        configuration, errors, IDs, clocks, logging
lib/data/health/                 HealthDataSource port and adapters
lib/data/persistence/            Drift database, encryption, outbox
lib/data/api/                    API models, mapper, and Dio client
lib/background/                  WorkManager scheduler and entrypoint
lib/features/sync/               domain coordinator and models
lib/features/connection/         permission/availability experience
lib/features/status/             receiving/sending status experience
specs/001-add-health-connect-sync/  approved specification and runbook
```

## Spec Kit workflow

This project uses a specification-first workflow:

1. `/speckit.specify <feature idea>`
2. `/speckit.clarify`
3. `/speckit.plan`
4. `/speckit.tasks`
5. `/speckit.implement`
6. `/speckit.analyze`

The project constitution is in `.specify/memory/constitution.md`. Feature artifacts live under `specs/`.
