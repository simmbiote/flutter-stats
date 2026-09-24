# Tasks: Add Health Connect Sync

**Input**: Design documents from `specs/001-add-health-connect-sync/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`

**Tests**: Included because the active specification contains prioritized user scenarios and acceptance tests, and the project constitution requires unit, widget, and integration coverage for specified behavior.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel with other marked tasks after its stated dependencies.
- **[Story]**: User story phase label (`US1`, `US2`, or `US3`).
- Every task includes an exact repository-relative file path.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Bootstrap the Flutter project, toolchain, Android integration, and safe development configuration.

- [X] T001 Create the Flutter application shell and package metadata in `pubspec.yaml`, `lib/main.dart`, and `analysis_options.yaml` using Flutter 3.41.6/Dart 3.11.4.
- [X] T002 [P] Add the pinned runtime and development dependencies from `plan.md` to `pubspec.yaml`, then generate `pubspec.lock` with `health`, `workmanager`, `drift_flutter`, `dio`, secure storage, cryptography, Riverpod, Health Connect settings support, and test tooling.
- [X] T003 [P] Configure Android API levels, AndroidX, Java/Kotlin compatibility, and the Health Connect package query in `android/app/build.gradle.kts`, `android/gradle.properties`, and `android/app/src/main/AndroidManifest.xml`.
- [X] T004 [P] Bootstrap dependency composition and application lifecycle hooks in `lib/app/dependencies.dart`, `lib/app/lifecycle/app_lifecycle_listener.dart`, and `lib/main.dart` without reading health data before permission.
- [X] T005 [P] Create the test directory layout, deterministic clock/ID test hooks, safe development-mode seams, and shared test harness entry points in `test/support/test_harness.dart`, `test/support/test_database.dart`, `lib/core/config/app_config.dart`, and `integration_test/health_sync_e2e_test.dart`.
- [X] T006 [P] Add redacted runtime configuration and logging primitives in `lib/core/config/app_config.dart`, `lib/core/logging/redacting_logger.dart`, and `lib/core/errors/sync_error.dart`; prohibit health values, tokens, and credentials from logs.

**Checkpoint**: The project builds as an empty Flutter app and contains the planned dependency, Android, configuration, and test seams.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define shared domain contracts, persistence, security, and test doubles before story-specific behavior.

**⚠️ CRITICAL**: Complete this phase before implementing any user story.

- [X] T007 Create the canonical domain entities and enums in `lib/features/sync/domain/models.dart`; include the required identity fields `sourcePlatform`, `sourceRecordId`, and `recordType`, enforce that `endTime` cannot precede `startTime`, require a compatible unit or explicit unknown unit for numeric measurements, require payloads for `upsert`, omit payloads for `delete`, and define the pending-operation states `pending`, `sending`, `retry_scheduled`, `blocked`, and `acknowledged`.
- [X] T008 [P] Define the platform-neutral `HealthDataSource` port and safe source-error taxonomy in `lib/data/health/health_data_source.dart` and `lib/core/errors/health_errors.dart`; expose availability, per-type read permissions, initial-window reads, change reads, cursor expiry, and the errors `unavailable`, `permission_denied`, `background_unsupported`, `rate_limited`, `temporarily_unavailable`, `cursor_expired`, and `invalid_data`.
- [X] T009 [P] Define `SyncScheduler` and `ReceivingApi` ports in `lib/background/sync_scheduler.dart` and `lib/data/api/receiving_api.dart`, including schedule, cancel, one-off trigger, submit, acknowledgement, and classified-error methods.
- [X] T010 Implement the Drift schema and migrations for `HealthRecordIdentity`, `RecordIdentityIndex`, `HealthRecordSnapshot`, `SyncCursor`, `PendingOperation`, `SyncRun`, `ConnectionSnapshot`, and `ApiConfiguration` in `lib/data/persistence/app_database.dart`; enforce identity uniqueness, encrypted cursor storage, worker leases, and independent receiving/sending state.
- [X] T011 [P] Implement secure key and installation-credential providers in `lib/data/persistence/secure_key_store.dart` and `lib/data/credentials/installation_credential_store.dart`; never persist or expose the credential in plain configuration.
- [X] T012 [P] Implement the authenticated AES-GCM payload codec in `lib/data/persistence/encrypted_payload_codec.dart`; encrypt before database writes and support authenticated decryption for queued upserts.
- [X] T013 [P] Implement injectable clock, randomness, and ID generation in `lib/core/time/clock.dart` and `lib/core/ids/id_generator.dart` so token, lease, retry, and idempotency behavior is deterministic in tests.
- [X] T014 [P] Create reusable fakes for health source, receiving API, scheduler, credential store, and pending store in `test/support/fake_health_data_source.dart`, `test/support/fake_receiving_api.dart`, `test/support/fake_sync_scheduler.dart`, and `test/support/fake_pending_store.dart`.
- [X] T015 [P] Implement versioned API request/response models in `lib/data/api/api_models.dart` against `contracts/health-records-api.md`; enforce schema version `1`, separate `upsert`/`delete` envelopes, 1–100 records per request, stable `record_id`, stable `mutation_id`, and no measurement values in delete requests.
- [X] T016 [P] Register all foundational ports and stores in the application dependency graph in `lib/app/dependencies.dart`, with separate construction paths for the foreground app and WorkManager isolate.
- [X] T017 [P] Implement bounded retry classification and exponential-backoff policy in `lib/core/errors/retry_policy.dart` and `lib/core/errors/retry_error.dart`; retry timeouts, connection failures, 408, 425, 429, and 5xx, while blocking validation, authorization, and malformed permanent failures.
- [X] T018 Run Drift code generation and the first static checkpoint against `lib/data/persistence/app_database.g.dart`, `pubspec.lock`, and `analysis_options.yaml`; fix generated-code and analyzer issues before story work begins.

**Checkpoint**: Shared domain, ports, encrypted storage, API mapping, scheduler seams, and deterministic test doubles are available to all stories.

---

## Phase 3: User Story 1 - Understand and Authorize Health Access (Priority: P1) 🎯 MVP

**Goal**: A user can understand supported health sources, grant or deny granular read access, recover from unavailable/revoked permissions, and enable automatic posting without creating an account.

**Independent Test**: On a device or fake source with no permissions, run the connection flow, grant/deny/revoke access, and verify the UI state, rationale, and absence of reads/transfers for blocked categories.

### Tests for User Story 1

- [X] T019 [P] [US1] Write widget tests for rationale, availability, partial permission, denied/revoked states, settings actions, and semantic labels in `test/widget/connection_flow_test.dart` before implementing the page.
- [X] T020 [P] [US1] Write contract tests for source availability, read-only permission results, background-read support, and safe error mapping in `test/contract/health_data_source_contract_test.dart` using `test/support/fake_health_data_source.dart`.

### Implementation for User Story 1

- [X] T021 [US1] Implement the Android `health` package adapter in `lib/data/health/health_connect_data_source.dart`, using only the read permissions required for activity, vitals, sleep, and body records; do not expose or request Health Connect write permissions.
- [X] T022 [P] [US1] Implement the canonical permission catalog and source/origin mapping in `lib/data/health/permission_catalog.dart` and `lib/data/health/source_origin_mapper.dart`; map Samsung Health only when the source metadata is available and use explicit unknown values otherwise.
- [X] T023 [US1] Implement connection state and permission orchestration in `lib/features/connection/domain/connection_controller.dart` and `lib/features/connection/application/connection_providers.dart`, distinguishing `available`, `not_installed`, `update_required`, `restricted`, `denied`, `revoked`, `partially_allowed`, and `connected`.
- [X] T024 [P] [US1] Implement the connection page and permission rationale UI in `lib/features/connection/presentation/connection_page.dart` and `lib/features/connection/presentation/permission_rationale_page.dart`, explaining read-only scope, automatic posting, supported categories, and the receiving service before requesting access.
- [X] T025 [P] [US1] Implement install/update/settings/disconnect actions in `lib/features/connection/presentation/connection_actions.dart` and `lib/shared/settings/settings_launcher.dart`, using the safe source error categories and never displaying credentials or health values.
- [X] T026 [US1] Wire permission-grant results, app-resume rechecks, and automatic-mode enablement in `lib/app/lifecycle/app_lifecycle_listener.dart`, `lib/app/dependencies.dart`, and `lib/main.dart`; no data may be read or sent before the required grant.
- [X] T027 [US1] Finalize the Android Health Connect manifest declarations, system permission-rationale flow, background-read permission, and no-write policy in `android/app/src/main/AndroidManifest.xml` and `android/app/src/main/kotlin/com/example/flutter_stats/MainActivity.kt`, matching the permission catalog.
- [X] T028 [US1] Run the independent US1 device/widget validation from `quickstart.md`, `test/widget/connection_flow_test.dart`, and `integration_test/connection_flow_test.dart`; record that unavailable, denied, partial, revoked, and granted cases match the spec.

**Checkpoint**: US1 is independently functional and demonstrates informed, read-only authorization without requiring an account.

---

## Phase 4: User Story 2 - Receive and Send Supported Health Records (Priority: P1)

**Goal**: New, corrected, and removed health records are automatically read, normalized, queued, and POSTed to the receiving API with acknowledgement, retry, and local data-minimization behavior.

**Independent Test**: With a fake HealthDataSource and receiving API, grant access, create initial/new/upsert/delete changes, run foreground and background coordinators, and verify no user sync action, no duplicate identity, correct POST envelopes, automatic retry, and payload deletion after acknowledgement.

### Tests for User Story 2

- [X] T029 [P] [US2] Write record-mapper tests for the four categories, units, time validity, source/origin labels, Samsung Health origin, unknown source values, and stable version handling in `test/unit/record_mapper_test.dart`.
- [X] T030 [P] [US2] Write coordinator tests for initial 30-day backfill, per-type cursors, pagination, cursor expiry recovery, partial permission, corrections, deletions, lease recovery, and automatic retry in `test/unit/sync_coordinator_test.dart`.
- [X] T031 [P] [US2] Write API contract tests for upsert/delete envelopes, `schema_version` `1`, 1–100 batching, stable `mutation_id`/idempotency, partial acknowledgement, 401/429/5xx/timeout/malformed responses, and log redaction in `test/contract/receiving_api_contract_test.dart`.
- [X] T032 [P] [US2] Write persistence tests for encrypted pending payloads, transactional cursor advancement, identity uniqueness, expired leases, acknowledged payload deletion, and disconnect deletion in `test/unit/pending_store_test.dart`.
- [X] T033 [P] [US2] Write the end-to-end device test for permission grant, initial backfill, automatic new data, correction/deletion, app inactive processing, API acknowledgement, retry, and local retention in `integration_test/health_sync_e2e_test.dart`.

### Implementation for User Story 2

- [X] T034 [US2] Implement Health Connect record normalization and per-type change-token mapping in `lib/data/health/record_mapper.dart` and `lib/data/health/health_connect_data_source.dart`; preserve stable IDs, versions, timestamps, units, source labels, and Samsung origin without logging values.
- [X] T035 [US2] Implement the encrypted outbox, identity index, cursor repository, atomic queue/cursor updates, and lease recovery in `lib/data/persistence/encrypted_pending_store.dart` and `lib/data/persistence/sync_repository.dart`; delete acknowledged payloads and retain only unsent payloads until acknowledgement or user clear/disconnect.
- [X] T036 [US2] Implement the receive-normalize-persist-send state machine in `lib/features/sync/domain/sync_coordinator.dart`, including independent receiving/sending states, bounded 30-day initial range, per-type cursors, empty results, update/delete operations, and terminal acknowledgement rules.
- [X] T037 [US2] Implement WorkManager scheduling and the background entrypoint in `lib/background/workmanager_sync_scheduler.dart` and `lib/background/background_entrypoint.dart`; use one unique 15-minute periodic task, a network constraint, immediate one-off triggers, and bounded backoff.
- [X] T038 [US2] Implement the Dio receiving client and retry integration in `lib/data/api/dio_receiving_api.dart`, attaching the secure installation credential, stable idempotency key, bounded timeouts, redacted errors, and server-side reconciliation assumptions from `contracts/health-records-api.md`.
- [X] T039 [US2] Complete canonical API payload mapping and fixtures in `lib/data/api/api_mapper.dart`, `test/contract/fixtures/health_records_upsert.json`, and `test/contract/fixtures/health_records_delete.json`; ensure delete bodies contain no measurement values.
- [X] T040 [US2] Integrate the coordinator, repositories, scheduler, credential provider, and API client in `lib/app/dependencies.dart`, `lib/main.dart`, and `lib/background/background_entrypoint.dart`, including automatic execution after permission grant and app resume.
- [X] T041 [US2] Implement bounded cursor-expiry recovery and identity reconciliation in `lib/features/sync/domain/cursor_recovery.dart`, re-reading only the recovery window and preventing unrelated duplicate upserts/deletes.
- [X] T042 [US2] Implement automatic retry, ambiguous-timeout handling, and expired-lease recovery in `lib/features/sync/domain/retry_scheduler.dart` and `lib/data/persistence/sync_repository.dart`, reusing the original operation ID and never marking an unacknowledged operation sent.
- [X] T043 [US2] Run the US2 validation set in `test/unit/sync_coordinator_test.dart`, `test/contract/receiving_api_contract_test.dart`, `integration_test/health_sync_e2e_test.dart`, and `quickstart.md`; verify 1,000 mixed records are accounted for and no acknowledged record is duplicated.

**Checkpoint**: US2 is independently functional from authorized source change through acknowledged API delivery and local payload deletion.

---

## Phase 5: User Story 3 - Follow Sync Status and Recover from Problems (Priority: P2)

**Goal**: A user can independently understand receiving and sending state, empty/blocked/retry/error conditions, last success, and recovery actions without seeing sensitive values.

**Independent Test**: Drive a fake `SyncRun` and `ConnectionSnapshot` through waiting, receiving, sending, empty, blocked, paused, retry, failure, sent, and disconnect states; verify labels, actions, semantics, large text, and small-screen layout.

### Tests for User Story 3

- [X] T044 [P] [US3] Write unit tests for receiving/sending state transitions, last-success retention, value-free status snapshots, and safe error mapping in `test/unit/sync_status_test.dart`.
- [X] T045 [P] [US3] Write widget tests for independent indicators, empty/blocked/retry/failed states, inactive-run timestamps, retry/disconnect actions, semantics, contrast-safe labels, and small-screen layout in `test/widget/sync_status_view_test.dart`.

### Implementation for User Story 3

- [X] T046 [US3] Implement the status domain snapshot and transition rules in `lib/features/status/domain/sync_status.dart`, using the states `waiting`, `receiving`, `empty`, `blocked`, `paused`, `failed`, `complete` for receiving and `waiting`, `sending`, `sent`, `empty`, `blocked`, `retry_scheduled`, and `failed` for sending.
- [X] T047 [US3] Implement the status controller/providers in `lib/features/status/application/sync_status_controller.dart` and `lib/features/status/application/sync_status_providers.dart`, reading persisted runs/connection state and exposing counts, safe errors, and last-success time only.
- [X] T048 [P] [US3] Implement the receiving/sending status view in `lib/features/status/presentation/sync_status_view.dart` with separate text labels, semantic descriptions, category/source counts, and no measurement values.
- [X] T049 [P] [US3] Implement empty, blocked, paused, retrying, failed, and last-success presentation states in `lib/features/status/presentation/sync_status_states.dart`, including next actions and retry/disconnect controls.
- [X] T050 [US3] Wire app-resume status refresh, inactive-run display, and disconnect behavior in `lib/app/lifecycle/app_lifecycle_listener.dart`, `lib/features/status/application/sync_status_controller.dart`, and `lib/features/connection/presentation/connection_actions.dart`.
- [X] T051 [US3] Add accessibility and responsive polish in `lib/features/status/presentation/sync_status_view.dart` and `lib/features/status/presentation/sync_status_states.dart`, including semantics, non-color cues, readable contrast, large text, and narrow-screen layouts.
- [X] T052 [US3] Run the independent US3 validation in `test/unit/sync_status_test.dart`, `test/widget/sync_status_view_test.dart`, `integration_test/sync_status_test.dart`, and `quickstart.md`; verify users can identify current state within the specified flow without sensitive values.

**Checkpoint**: US3 is independently functional and provides truthful, accessible receiving/sending and recovery feedback.

**Implementation validation note (2026-09-24)**: Host checks, Android debug/release builds, and individual Android-emulator integration flows passed. The emulator available in this environment was API 37; API 28/33/34+ matrix checks, physical Samsung-origin testing, and staging credential/API acknowledgement remain documented release gates in `docs/health-sync-validation-report.md`.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Harden privacy, release readiness, documentation, and cross-platform extension seams after all desired stories are functional.

- [X] T053 [P] Audit secret and health-data redaction across `lib/core/logging/redacting_logger.dart`, `lib/data/api/dio_receiving_api.dart`, `lib/data/persistence/encrypted_payload_codec.dart`, and `lib/background/background_entrypoint.dart`; prohibit health values, payload bytes, tokens, and installation credentials in logs or diagnostics.
- [X] T054 [P] Verify reproducible dependency resolution and package constraints in `pubspec.yaml`, `pubspec.lock`, and the generated `lib/data/persistence/app_database.g.dart`; run the WorkManager isolate smoke test on API 28, API 33, and API 34+ and review the resolved `health` Android Gradle dependency. If plugin-channel initialization or safe error classification is unreliable, implement the production fallback as a native `CoroutineWorker` behind `SyncScheduler` under `android/app/src/main/kotlin/com/example/flutter_stats/` before release.
- [X] T055 [P] Verify the platform-neutral boundary with a compile/test guard in `lib/data/health/health_data_source.dart` and `test/unit/platform_boundary_test.dart`; ensure Android-specific types do not leak into domain/UI code and a future iOS adapter can implement the same contract.
- [X] T056 Update operator and developer documentation in `specs/001-add-health-connect-sync/quickstart.md`, `README.md`, and `docs/health-data-privacy.md` with permission rationale, background limitations, retention, credential provisioning, and Samsung-origin behavior.
- [X] T057 Run the full static and automated validation set against `analysis_options.yaml`, `test/`, `integration_test/`, and `pubspec.yaml`: `dart format --set-exit-if-changed`, `flutter analyze`, and `flutter test`.
- [X] T058 [P] Complete Android release configuration and policy checks in `android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `docs/health-data-declaration.md`, and `docs/privacy-policy.md`; confirm API 28+, read-only permissions, backup restrictions, and Play Health Connect declaration.
- [X] T059 [P] Perform the security and operational review in `docs/security-review.md` and `docs/operations-runbook.md`, covering mobile credential risk, idempotent API reconciliation, background delay, token expiry, and sensitive-data incident handling.
- [X] T060 Execute the complete acceptance run from `specs/001-add-health-connect-sync/quickstart.md` against a staging/mock API and record outcomes in `docs/health-sync-validation-report.md` without adding secrets or health values.

---

## Dependencies & Execution Order

### Phase dependencies

- **Setup (Phase 1)**: No dependencies; T001 starts the project, while marked setup tasks can proceed after the project shell exists.
- **Foundational (Phase 2)**: Depends on Setup completion and blocks all user stories.
- **User Stories (Phases 3–5)**: Each depends on Foundational completion. US2 consumes US1's source/permission boundary; US3 consumes persisted status models and can be developed with fakes in parallel.
- **Polish (Phase 6)**: Depends on the desired user stories and their validation checkpoints.

### User story dependency graph

```text
Setup
  ↓
Foundational
  ├── US1: Understand and Authorize Health Access (P1, MVP)
  │      ↓
  │   US2: Receive and Send Supported Health Records (P1)
  │      ↓
  │   US3: Follow Sync Status and Recover from Problems (P2)
  └── US3 domain/status work can begin with fakes after Foundational
```

- **US1**: Can start after Foundational; no dependency on US2 or US3.
- **US2**: Uses US1's granted connection/permission boundary, but its coordinator and contract tests use fakes and can be implemented in parallel with the final US1 UI.
- **US3**: Can start with fake `SyncRun`/`ConnectionSnapshot` values after Foundational; integration wiring waits for US1/US2 persistence.
- **Polish**: Starts after the story checkpoints it hardens; documentation and security review tasks marked `[P]` can run in parallel.

### Within each story

1. Write the story's failing contract/widget/unit tests.
2. Implement domain models and validation.
3. Implement services/adapters and persistence.
4. Wire presentation/background integration.
5. Run the independent test and device scenario before advancing.

## Parallel Opportunities

- T002–T006 can run in parallel after T001, subject to file ownership.
- T008–T009, T011–T013, T014–T017 can run in parallel after the shared model decisions in T007.
- T019–T020 can run in parallel; T022, T024, and T025 can run in parallel after their domain/UI contracts are defined.
- T029–T033 can run in parallel after Foundational; implementation tasks then follow the test contracts.
- T044–T045 can run in parallel; T048–T049 can run in parallel after T047.
- T053–T055 and T058–T059 can run in parallel during Polish.
- Different user stories can be assigned to different developers after Foundational; avoid concurrent edits to `lib/app/dependencies.dart` and `lib/main.dart` by coordinating integration tasks.

## Parallel Examples

### User Story 1

```text
T019 [P] [US1] Widget tests for connection flow in test/widget/connection_flow_test.dart
T020 [P] [US1] Source contract tests in test/contract/health_data_source_contract_test.dart
T022 [P] [US1] Permission catalog in lib/data/health/permission_catalog.dart
T024 [P] [US1] Connection UI in lib/features/connection/presentation/connection_page.dart
T025 [P] [US1] Recovery actions in lib/features/connection/presentation/connection_actions.dart
```

### User Story 2

```text
T029 [P] [US2] Record mapping tests in test/unit/record_mapper_test.dart
T030 [P] [US2] Coordinator tests in test/unit/sync_coordinator_test.dart
T031 [P] [US2] API contract tests in test/contract/receiving_api_contract_test.dart
T032 [P] [US2] Persistence tests in test/unit/pending_store_test.dart
T033 [P] [US2] Device flow test in integration_test/health_sync_e2e_test.dart
```

### User Story 3

```text
T044 [P] [US3] Status domain tests in test/unit/sync_status_test.dart
T045 [P] [US3] Status widget tests in test/widget/sync_status_view_test.dart
T048 [P] [US3] Status view in lib/features/status/presentation/sync_status_view.dart
T049 [P] [US3] State components in lib/features/status/presentation/sync_status_states.dart
```

## Implementation Strategy

### MVP first — User Story 1

1. Complete Phase 1 Setup.
2. Complete Phase 2 Foundational.
3. Complete Phase 3 US1 and its independent permission/availability validation.
4. Stop and demo the informed, read-only connection flow before implementing automatic delivery.

### Incremental delivery

1. Setup + Foundational → shared platform-neutral foundation.
2. US1 → permission/availability/connection experience (MVP).
3. US2 → automatic receive/send, update/delete, retry, and retention behavior.
4. US3 → independent status, recovery, and accessible UX.
5. Polish → security, release, documentation, and device validation.

Each story must pass its independent test criteria before the next story is considered complete; existing behavior must remain green after every increment.

## Task coverage map

- **US1**: T019–T028 — permission rationale, availability, read-only access, denial/revocation, settings, and no-account enablement.
- **US2**: T029–T043 — change tokens, four categories, Samsung-origin mapping, automatic scheduling, POST/acknowledgement, updates/deletes, retry, encryption, and retention.
- **US3**: T044–T052 — receiving/sending state, empty/error/recovery states, timestamps, accessibility, and inactive-app status.
- **Shared contracts/entities**: T007–T018, T053–T060 — canonical models, ports, Drift schema, secure storage, API contract, privacy, release, and future-platform boundary.

## Notes

- `[P]` means different files and no dependency on an incomplete task; it is not a substitute for checking file ownership.
- Do not commit credentials, generated secrets, health payloads, or machine-local state.
- Do not log health values even in debug builds; use synthetic fixtures with obviously fake values.
- Keep all Health Connect plugin types behind `lib/data/health/health_data_source.dart` so the domain remains usable by a future iOS adapter.
- Commit after each task or coherent task group, and stop at each story checkpoint for independent validation.
