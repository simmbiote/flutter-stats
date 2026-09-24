# Research: Add Health Connect Sync

**Date**: 2026-09-24  
**Feature**: `specs/001-add-health-connect-sync/spec.md`  
**Scope**: Android-first read-only Health Connect ingestion, conditional Samsung Health visibility, automatic delivery, API submission, and future iOS extensibility.

## Decision Summary

| Area | Decision | Status |
|------|----------|--------|
| Health platform | Use Health Connect as the Android source of truth; include records whose origin is Samsung Health when Health Connect exposes them. | Selected |
| Flutter health adapter | Use `health 13.3.2` behind a platform-neutral `HealthDataSource` port. | Selected |
| Change detection | Use per-record-type Health Connect change tokens, a 30-day initial read, and incremental upsert/delete processing. | Selected |
| Background execution | Use `workmanager 0.10.10` with a 15-minute periodic task plus immediate one-off runs after permission/resume events. | Selected |
| Local storage | Use Drift with a database shared across isolates; encrypt sensitive pending payloads with AES-GCM and keep keys in secure storage. | Selected |
| API client | Use Dio with HTTPS, bounded batches, idempotency keys, timeouts, and retry classification. | Selected |
| Samsung direct SDK | Do not require the Samsung Health Data SDK in v1; preserve a source-adapter boundary for a future partner-approved integration. | Selected |
| iOS | Keep domain models and ports platform-neutral; enable the iOS adapter only in a later release. | Selected |

## 1. Health Connect availability and permissions

### Findings

- Health Connect requires Android 9 (API 28) or newer and Google Play services. On Android 14 and newer it is part of the Android framework; on Android 13 and lower it is delivered as an APK. Work profiles are not supported for Health Connect access.
- The app must check SDK/service availability before showing a connection state. It must distinguish an unavailable service, a missing service version, restricted access, denied access, and revoked access.
- Health Connect grants granular read permissions. The app must declare only the read permissions for the selected record types; v1 must not declare or request write permissions.
- Reading while the app is backgrounded requires the separate `READ_HEALTH_DATA_IN_BACKGROUND` feature permission. The feature must be checked at runtime because it is not available on every device/version.
- Health Connect permissions can be changed or revoked outside the app. Every foreground resume and every background run must re-check relevant permissions.
- A privacy-policy/rationale activity must handle the Health Connect permission-usage intent. The same text must be used in the Play Console health-data declaration.

### Decision

Use the `health` package's availability, feature, and permission methods. Keep the app's minimum Android SDK at API 28, use API 36 for compilation/targeting, and request only the read permissions needed by the four supported categories. The background-read permission is requested as a separate, explainable step after category permissions are understood.

### Rationale

This matches the clarified requirement that access be read-only and that unavailable/partial permissions be visible. It avoids declaring broad write access that the product explicitly excludes.

### Alternatives considered

- **Read permissions plus an unconditional background worker:** rejected because background reads can fail without the feature permission and would produce misleading status.
- **Request historical access in v1:** deferred because the first release only needs the most recent 30 days by default. The adapter must leave a clear path to add the history permission later.
- **Write permissions for round-trip testing:** rejected; v1 is read-only and writing test records is the Health Connect test provider's responsibility.

### Sources

- [Check Health Connect availability](https://developer.android.com/health-and-fitness/health-connect/availability)
- [Get started with Health Connect](https://developer.android.com/health-and-fitness/health-connect/get-started)
- [Health Connect permissions and data access](https://developer.android.com/health-and-fitness/health-connect/ui/permissions)
- [Read raw data and background reads](https://developer.android.com/health-and-fitness/health-connect/read-data)
- [Health Connect data types and permissions](https://developer.android.com/health-and-fitness/health-connect/data-types)

## 2. Automatic change detection and background execution

### Findings

- The official Health Connect synchronization guide says an app cannot generally be notified when a new record arrives. It recommends checking for changes in the foreground and periodically while background reads are available.
- Health Connect change logs provide inserted/updated records and deleted record IDs. A changes token is the efficient way to avoid repeatedly reading the entire history. Separate tokens per record type isolate permission failures and make token recovery manageable.
- The `health` package exposes `getChangesToken`, `getChanges`, `HealthChangesResponse.upsertedDataPoints`, `deletedRecordIds`, `hasMore`, `nextChangesToken`, and `changesTokenExpired` APIs.
- Changes tokens can expire. The recovery path must re-read a bounded recent window, deduplicate by stable record identity, and resume from a new cursor.
- Android WorkManager persists work across process death and reboots, supports network constraints and exponential backoff, and is the recommended API for reliable deferred work. Periodic work has a 15-minute minimum interval and is not an exact alarm.
- A foreground lifecycle trigger can enqueue a one-off run when the app becomes active, reducing the user-visible delay without requiring a manual sync button.

### Decision

Implement automatic processing as:

1. Establish a per-record-type changes token before the initial backfill, then read the most recent 30 days on the first authorized run. This prevents changes arriving during the backfill from being missed; identity deduplication makes a repeated read safe.
2. Schedule one unique periodic WorkManager task with a 15-minute frequency and a network constraint.
3. Enqueue an immediate one-off task when permissions are granted, the app resumes, or a recoverable network/service condition is detected.
4. Use `health.getChanges()` with the stored token for later upserts and deletions.
5. Persist a token only after the corresponding change page has been durably queued.
6. On token expiry, re-read the recovery window, upsert by stable identity, and create delete operations only for identities that were previously indexed.

The user-facing meaning is automatic delivery without a required action. The UI must show `pending`/`waiting` when Android defers execution; it must not claim that a record was sent before acknowledgement.

### Rationale

This is the strongest platform-supported interpretation of the clarified requirement. Health Connect does not provide a general push event for ordinary apps, so exact immediacy cannot be promised. Polling with change tokens is more reliable and less battery-intensive than repeatedly reading the full history.

### Alternatives considered

- **Foreground-only reads:** rejected because it fails the no-user-action requirement whenever the app is closed.
- **Exact alarms or foreground services for every change:** rejected because they cost battery, require stricter Play policy justification, and are not supported as a normal Health Connect data-notification mechanism.
- **Timestamp-only polling without change tokens:** rejected because it increases rate-limit exposure and makes deletion handling less reliable.

### Sources

- [Synchronize data with Health Connect](https://developer.android.com/health-and-fitness/health-connect/sync-data)
- [Plan to avoid Health Connect rate limits](https://developer.android.com/health-and-fitness/health-connect/rate-limiting)
- [Android WorkManager background tasks](https://developer.android.com/develop/background-work/background-tasks/persistent)
- [Flutter Workmanager](https://pub.dev/packages/workmanager)
- [`health` API: `getChangesToken` and `getChanges`](https://pub.dev/documentation/health/latest/health/Health-class.html)

## 3. Samsung Health data

### Findings

- Health Connect is the Android-wide interchange layer and can expose records originating in other apps/devices when those records have been written to Health Connect.
- Samsung Health Data SDK can read Samsung Health data directly and exposes UPSERT/DELETE changes, but distribution requires Samsung partner approval and a registered package/signature. It has additional device, consent, and SDK requirements.
- The specification requires Samsung Health data “where available”, not a direct Samsung partner integration. Treating Health Connect as the primary source avoids two competing consent systems and duplicate records.

### Decision

Read Samsung Health-origin records through Health Connect and preserve the source/origin label when available. If a Samsung record is not exposed through Health Connect, show the normal unavailable/empty state; do not claim direct Samsung access. Keep the `HealthDataSource` port open to a future partner-approved Samsung adapter.

### Rationale

This satisfies the clarified scope without requiring a Samsung partnership, private APIs, or duplicate permission prompts in v1. The source boundary means a later direct adapter can normalize into the same domain records and API contract.

### Alternatives considered

- **Direct Samsung Health Data SDK in v1:** deferred because it requires a separately distributed AAR, partner approval for production, separate permission UX, and duplicate-source reconciliation.
- **Old Samsung Health SDK for Android:** rejected because Samsung has deprecated it in favor of Samsung Health Data SDK.
- **Infer Samsung Health data from device manufacturer:** rejected because manufacturer identity does not prove that a record is present or authorized.

### Sources

- [Samsung Health Data SDK overview](https://developer.samsung.com/health/data/overview.html)
- [Samsung Health Data SDK app creation and partnership process](https://developer.samsung.com/health/data/process.html)
- [Samsung Health Data SDK data access and changes](https://developer.samsung.com/health/data/guide/features/data-access.html)
- [Samsung Health Data SDK read changes](https://developer.samsung.com/health/data/guide/hello-sdk/read-changes.html)
- [Migration from Samsung Health SDK for Android](https://developer.samsung.com/health/data/migration-guide/overview.html)
- [Android Health Connect platform overview](https://developer.android.com/health-and-fitness/health-connect)

## 4. Flutter health integration choice

### Findings

- `health` 13.3.2 is a mature cross-platform package with Health Connect and HealthKit support, availability checks, granular permissions, range reads, and the direct change-token APIs needed for automatic synchronization.
- Its current API exposes `getChangesToken`, `getChanges`, `HealthChangesResponse`, upserted data points, deleted IDs, pagination, and token-expiry status. Domain records require explicit normalization from `HealthDataPoint` values, but that mapping belongs behind the source port.
- `health_connector` 3.11.1 offers stronger compile-time record typing and a high-level `synchronize()` API, but it has a newer Flutter/Dart floor, smaller adoption, and more rapid release/native-SDK risk. It remains a possible replacement if a spike demonstrates material value.
- A custom Kotlin/Swift bridge would provide maximum control but would duplicate the cross-platform adapter and increase the v1 surface area. It remains a contingency if the selected plugin cannot run reliably in WorkManager isolates.
- Both Flutter packages currently wrap an alpha Health Connect client even though a stable AndroidX client is available. The resolved lockfile and Gradle dependencies must be reviewed before release.

### Decision

Use `health: ^13.3.2` as the first implementation behind `HealthDataSource`. Pin the package and its transitive platform packages, run the Android build/availability smoke test early, and keep all plugin-specific types out of the domain and UI layers. Keep `health_connector` as a documented spike/contingency, not a second production implementation.

### Rationale

`health` provides the required change-log and cross-platform capabilities with the strongest ecosystem maturity and the lowest migration risk. The domain mapping and persistence layers remain identical if the adapter is replaced later.

### Alternatives considered

- **`health_connector`:** deferred because its typed API is attractive but its newer toolchain/release surface is not necessary for the first release.
- **Direct AndroidX SDK through a custom bridge:** retained as a fallback/contingency, not the default, because it increases Kotlin and future iOS implementation work.
- **A third-party Samsung-only SDK:** rejected because it couples the core sync to partner approval and duplicates Health Connect functionality.

### Sources

- [`health` package](https://pub.dev/packages/health)
- [`health` API](https://pub.dev/documentation/health/latest/health/Health-class.html)
- [`health_connector` package](https://pub.dev/packages/health_connector)
- [Health Connect get started](https://developer.android.com/health-and-fitness/health-connect/get-started)
- [Health Connect releases](https://developer.android.com/jetpack/androidx/releases/health-connect)

## 5. Local persistence and secrets

### Findings

- The product only needs to retain unsent records long enough to retry or until the user disconnects. Acknowledged health payloads must be removed.
- WorkManager runs in a separate isolate. The database must be safe to share between the UI and background isolate, and sensitive values must not be written as plaintext.
- `drift_flutter` supports a shared database isolate, which fits the background callback. `flutter_secure_storage` provides platform-backed secure storage for the installation credential and encryption key.
- AES-GCM through `cryptography`/`cryptography_flutter` provides authenticated encryption for serialized pending payloads while leaving only non-sensitive state and identity metadata queryable.
- `flutter_secure_storage` is appropriate for small secrets and keys, not as a substitute for encrypting a health-record database. Payload encryption is therefore explicit at the data-layer boundary.
- A transactional outbox needs an operation lease in addition to unique WorkManager names so two isolates cannot submit the same row concurrently; expired leases must be reclaimable after process death.

### Decision

Use `drift_flutter: ^0.3.1` with `shareAcrossIsolates: true`. Store only encrypted pending payloads, cursor tokens, operation state, counts, and timestamps in the database. Store the AES key and installation credential in `flutter_secure_storage: ^11.2.0`; disable Android backup for the secure-storage data. Delete the encrypted payload immediately after service acknowledgement or explicit user clear/disconnect.

### Rationale

This provides a durable retry queue without keeping a complete health history on the device. Encrypting the payload rather than relying on SQLite defaults makes the privacy boundary explicit and remains portable to a future iOS adapter.

### Alternatives considered

- **Plain Drift/SQLite payloads:** rejected because health values would be readable from the application database.
- **`sqflite_sqlcipher`:** viable but rejected as the primary choice because it is a less-verified fork and would couple the data layer to a database-specific encryption implementation.
- **Keeping all synced history locally for charts:** rejected because history/analytics is out of scope and conflicts with data minimization.

### Sources

- [`drift_flutter`](https://pub.dev/packages/drift_flutter)
- [`drift`](https://pub.dev/packages/drift)
- [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)
- [`cryptography`](https://pub.dev/packages/cryptography)
- [`cryptography_flutter`](https://pub.dev/packages/cryptography_flutter)

## 6. API delivery and retry behavior

### Findings

- Dio provides bounded timeouts, cancellation, interceptors, and testable adapters for the configured POST client.
- Health Connect has foreground/background rate limits. Changelog processing and bounded batches reduce unnecessary API calls.
- Mobile installation credentials can be extracted from a shipped binary. A long-lived shared secret must not be committed or treated as a permanent secret.
- Retries need a stable idempotency key so an ambiguous timeout cannot create duplicate accepted records. The API must enforce idempotency server-side; a client header alone is not sufficient.

### Decision

Use `dio: ^5.11.1` behind `ReceivingApi`. Send at most 100 operations per request in v1, require HTTPS outside local test fixtures, attach the installation credential in the `Authorization` header, and reuse an operation-derived idempotency key for retries. Retry timeouts, connection failures, 408, 429, and 5xx with bounded exponential backoff and jitter; block credential failures and validation failures for configuration/data correction.

The API base URL, path, schema version, and installation credential are deployment configuration. The v1 client contract is documented in `contracts/health-records-api.md`; the client must not log request bodies or credential values.

### Rationale

The design separates transport concerns from the health domain and gives the API owner a versioned, idempotent contract without coupling the UI to Dio. Ambiguous POST outcomes remain pending until the server's idempotency/reconciliation behavior resolves them.

### Alternatives considered

- **Send one request per record:** rejected because it increases latency, battery use, and rate-limit exposure.
- **Retry every non-2xx response indefinitely:** rejected because validation and authentication failures require a different recovery path.
- **Embed a long-lived API secret in the Dart binary:** rejected as an unsafe production pattern.

### Sources

- [`dio`](https://pub.dev/packages/dio)
- [Health Connect rate limits](https://developer.android.com/health-and-fitness/health-connect/rate-limiting)
- [RFC 9110 POST semantics](https://www.rfc-editor.org/rfc/rfc9110#section-9.2.2)
- [Flutter secure storage](https://pub.dev/packages/flutter_secure_storage)

## 7. Testing and validation approach

### Findings

- The domain, API, persistence, and scheduler must be testable through ports; tests must not require a physical device for every state transition.
- Android Health Connect provides official testing guidance, a fake client/testing library for native code, and a Health Connect Toolbox for manual/device scenarios.
- A plugin-based implementation needs at least one real-device smoke test to verify permissions, background reads, WorkManager isolate startup, and Samsung-origin records.
- Sensitive values must be absent from logs, status widgets, and test failure output.

### Decision

Use a layered test strategy:

- Pure Dart unit tests for record normalization, identity/version handling, cursor recovery, state transitions, encryption, retry classification, and API serialization.
- Widget tests for permission rationale, availability, partial access, empty/error states, independent receiving/sending indicators, retry, disconnect, semantics, and small-screen layouts.
- Contract tests with a fake Dio adapter or local test server for POST bodies, idempotency, acknowledgements, partial acceptance, and error responses.
- Android integration/device tests for Health Connect availability, background permission, initial backfill, new/upsert/delete changes, app background/kill/reboot, network loss, and a physical Samsung device where available.

### Sources

- [Create unit tests with the Health Connect Testing library](https://developer.android.com/health-and-fitness/health-connect/test/unit-tests)
- [Health Connect top test cases](https://developer.android.com/health-and-fitness/health-connect/test/test-cases)
- [Health Connect Toolbox](https://developer.android.com/health-and-fitness/health-connect/test/health-connect-toolbox)
- [Android WorkManager testing](https://developer.android.com/develop/background-work/background-tasks/persistent/testing)

## 8. Risks and mitigations

| Risk | Mitigation |
|------|------------|
| Health Connect has no ordinary push event, so new data may be delayed up to the platform's periodic execution window. | Use immediate foreground/permission triggers plus 15-minute WorkManager polling; show pending state and document the platform limit. |
| OEM battery policies, especially on Samsung devices, can delay or stop background work. | Test on physical Samsung hardware, use unique constrained work, preserve pending data, and provide a manual refresh recovery path without making it the normal flow. |
| `health` and its underlying Health Connect SDK are evolving and currently use an alpha client; the wrapper can surface some native failures as `null`. | Pin versions, review the resolved lockfile/Gradle dependencies, run an early background-isolate smoke test, keep the adapter thin, and use a native `CoroutineWorker` behind the same ports if plugin initialization or error classification is unreliable. |
| Change tokens expire or a permission is revoked. | Use per-type cursors, bounded recovery reads, stable identity deduplication, and explicit blocked/revoked states. |
| A mobile installation credential is extractable. | Use a short-lived/provisioned installation credential, secure storage, TLS, no committed secrets, and no secret-bearing logs. |
| The API contract or acknowledgement semantics differ from the plan baseline. | Keep `ReceivingApi` isolated and validate the contract with fixtures before integration; update the contract without changing domain models. |
| Samsung Health data is not exposed through Health Connect. | Show source availability honestly and preserve a future partner-approved Samsung adapter boundary. |

## Research conclusion

All technical unknowns needed to produce the Phase 1 design have been resolved. The remaining deployment-specific values (API base URL and installation credential) are configuration inputs, not product clarifications. The plan can proceed with the selected architecture and the risks above.
