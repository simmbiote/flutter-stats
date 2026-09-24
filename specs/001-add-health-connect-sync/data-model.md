# Data Model: Add Health Connect Sync

**Source**: `spec.md`  
**Related contract**: `contracts/health-records-api.md`  
**Platform boundary**: `contracts/health-data-source.md`

## Modeling principles

- Domain identities are platform-neutral. Android Health Connect and a future iOS HealthKit adapter map into the same record and operation shapes.
- A source record has a stable identity. A later correction is an update to that identity; a source deletion is a delete operation, not a new unrelated record.
- Health values are transient. Only unsent/pending payloads are retained locally, and those payloads are encrypted.
- Status and diagnostics may contain counts, categories, source labels, state, and timing, but never health values.
- The source cursor is metadata, not a health record. It is encrypted because it can reveal access patterns and is needed for reliable incremental reads.

## Canonical categories and record types

The first release maps the following categories to the concrete record types supported by the selected adapter. A device may expose only a subset; the missing type is represented as unavailable or empty rather than fabricated.

| Category | Initial record types | Typical unit/shape |
|----------|----------------------|--------------------|
| Activity | steps, distance, active calories, exercise session | count, meters, kilocalories, session |
| Vitals | heart rate, blood pressure, oxygen saturation, respiratory rate, body temperature | beats/minute, mmHg, percent, breaths/minute, temperature unit |
| Sleep | sleep session and sleep-stage records | session and stage/time-range records |
| Body measurements | body mass/weight, height, body-fat percentage, BMI | kilograms, meters, percent, unitless |

Route/location data, medical records, nutrition, and write access are not part of the first release.

## Entities

### `HealthRecordIdentity`

The immutable identity used for deduplication, updates, and deletes.

| Field | Type | Required | Rules |
|-------|------|----------|-------|
| `sourcePlatform` | enum | Yes | `android_health_connect` in v1; future `ios_healthkit` is valid. |
| `sourceRecordId` | string | Yes | Opaque provider ID; never replace it with a value-derived ID. |
| `recordType` | canonical string | Yes | One of the mapped record types for a category. |
| `sourceVersion` | string/int | Yes when supplied | Provider version or a deterministic content version used to reject stale updates. |

**Key**: `(sourcePlatform, sourceRecordId, recordType)`.

### `RecordIdentityIndex`

A small durable index used to interpret deletion changes and recover from cursor expiry. It contains no health value.

| Field | Type | Rules |
|-------|------|-------|
| `identity` | `HealthRecordIdentity` | Primary key. |
| `lastSeenVersion` | string/int | Latest version observed from the source. |
| `lastSeenAt` | timestamp | Last time the identity was observed. |
| `sourceDataType` | canonical string | Kept separately because some deletion events contain only an ID. |
| `originLabel` | string, nullable | Safe source label such as `Samsung Health`; not a secret. |
| `lastOperation` | enum | `upsert`, `delete`, or `unknown`. |

### `HealthRecordSnapshot`

The normalized value received from a source. It exists in memory for processing and is encrypted only when it must be queued.

| Field | Type | Required | Rules |
|-------|------|----------|-------|
| `identity` | `HealthRecordIdentity` | Yes | Must be stable and source-specific. |
| `category` | enum | Yes | `activity`, `vitals`, `sleep`, or `body`. |
| `measurement` | discriminated value | Yes | Numeric, interval/session, or categorical value appropriate to `recordType`. |
| `unit` | string, nullable | For numeric values | Preserve the source unit and normalize only in the API adapter. |
| `startTime` | UTC timestamp | Yes for interval/session; nullable for instant values | Preserve source offset separately. |
| `endTime` | UTC timestamp | Yes when the source supplies an end | Must not precede `startTime`. |
| `startOffset`/`endOffset` | zone offset string, nullable | No | Preserve for display and API fidelity. |
| `source` | source descriptor | Yes | Safe package/app/device label; never a credential. |
| `knownOrigin` | string, nullable | No | `Samsung Health` when exposed; otherwise `unknown`. |
| `receivedAt` | UTC timestamp | Yes | Set when the app receives the record. |
| `lifecycle` | enum | Yes | `active`, `corrected`, or `removed`. |
| `localRetention` | enum | Yes | `transient`, `pending`, or `removed_after_ack`. |

### `SyncCursor`

One cursor per source platform and record type. A separate cursor prevents a revoked permission for one type from invalidating all other types.

| Field | Type | Rules |
|-------|------|-------|
| `sourcePlatform` | enum | Platform key. |
| `recordType` | canonical string | One record type. |
| `token` | encrypted string, nullable | Provider change token; absent before first successful initialization. |
| `tokenCreatedAt` | timestamp, nullable | Used for expiry diagnostics. |
| `lastReadAt` | timestamp, nullable | Last successful change-page processing time. |
| `lastRecoveryAt` | timestamp, nullable | Last bounded re-read after expiry or reset. |
| `state` | enum | `uninitialized`, `ready`, `expired`, `blocked`, or `reset_required`. |

### `PendingOperation`

A durable, idempotent unit waiting for or undergoing API delivery.

| Field | Type | Rules |
|-------|------|-------|
| `operationId` | string | Globally unique idempotency key; stable across retries. |
| `identity` | `HealthRecordIdentity` | Required for both upsert and delete. |
| `operation` | enum | `upsert` or `delete`. |
| `payloadSchemaVersion` | integer | Version used to migrate queued encrypted payloads after an app upgrade. |
| `payload` | encrypted bytes, nullable | Required for upsert; omitted for delete. |
| `state` | enum | `pending`, `sending`, `retry_scheduled`, `blocked`, or `acknowledged`. |
| `leaseOwner` | string, nullable | Identifies the worker/run that claimed the row. |
| `leaseUntil` | timestamp, nullable | Expired leases are reclaimable after process death. |
| `attemptCount` | integer | Increments on each network attempt. |
| `nextAttemptAt` | timestamp, nullable | Used for bounded backoff. |
| `lastErrorCode` | safe enum/string, nullable | Never contains response bodies or health values. |
| `createdAt` | timestamp | Queue creation time. |
| `acknowledgedAt` | timestamp, nullable | Set only after a positive service acknowledgement. |
| `serverOperationId` | string, nullable | Safe server correlation ID returned on acknowledgement. |

**Uniqueness**: an identity/version/operation combination is queued at most once. An acknowledged operation is not presented as a new operation on retry.

### `SyncRun`

A user-visible processing attempt. It contains state and counts, not record values.

| Field | Type | Rules |
|-------|------|-------|
| `runId` | string | Unique run/work ID. |
| `trigger` | enum | `initial_backfill`, `new_data`, `correction`, `removal`, `retry`, or `manual_refresh`. |
| `startedAt`/`endedAt` | timestamp | `endedAt` remains null while active. |
| `receiveState` | enum | `waiting`, `receiving`, `empty`, `blocked`, `failed`, or `complete`. |
| `sendState` | enum | `waiting`, `sending`, `sent`, `empty`, `blocked`, `retry_scheduled`, or `failed`. |
| `categoryCounts` | map | Counts only; no values. |
| `workId` | string, nullable | WorkManager identifier for diagnostics. |
| `lastErrorCode` | safe enum/string, nullable | Sanitized error category. |

### `ConnectionSnapshot`

The current permission and source state shown by the UI.

| Field | Type | Rules |
|-------|------|-------|
| `serviceAvailability` | enum | `available`, `not_installed`, `update_required`, `restricted`, or `unsupported`. |
| `categoryPermissions` | map | Per-type `granted`, `denied`, `revoked`, `restricted`, or `not_declared`. |
| `backgroundRead` | enum | `available`, `granted`, `denied`, or `unsupported`. |
| `automaticSyncEnabled` | boolean | True only after the required connection and background prerequisites are satisfied. |
| `credentialState` | enum | `configured`, `missing`, `expired`, or `revoked`; never contains the value. |
| `lastSuccessfulRunAt` | timestamp, nullable | Displayed as status metadata. |

### `ApiConfiguration`

Non-secret deployment configuration.

| Field | Type | Rules |
|-------|------|-------|
| `baseUrl` | URI | HTTPS in production; local fixtures may use a test scheme. |
| `path` | string | Defaults to `/v1/health-records`; configurable without changing domain code. |
| `schemaVersion` | string | Sent in the request envelope. |
| `maxBatchSize` | integer | 100 for v1. |
| `connectTimeout`/`receiveTimeout` | duration | Bounded and configurable for tests. |

The installation credential is intentionally not a field in this entity; it is held by `CredentialStore` and referenced indirectly.

## Relationships

```text
ConnectionSnapshot 1 ─── * SyncRun
SyncRun             1 ─── * PendingOperation
HealthRecordIdentity 1 ─── * PendingOperation
HealthRecordIdentity 1 ─── 1 RecordIdentityIndex
SyncCursor          1 ─── * HealthRecordSnapshot (per source type)
ReceivingService    1 ─── * PendingOperation (acknowledgement)
```

A source record is normalized once, indexed by identity, and represented by one or more pending operations over its lifetime. The database never stores a complete acknowledged health history.

## State transitions

### Connection and permission state

```text
checking
  ├─> unavailable       (service missing, unsupported, or restricted)
  ├─> needs_permission  (service available, required read access absent)
  ├─> partially_allowed (some record types granted)
  └─> connected         (all required read access and background prerequisite satisfied)

needs_permission ──request──> granted | denied | restricted
granted ──settings/resume──> checking
connected ──disconnect──> disconnected
```

Revocation returns the affected categories to `needs_permission`; it does not silently continue reading.

### Sync run state

```text
queued
  -> checking_access
  -> receiving
  -> empty
  -> sending
  -> acknowledged
  -> failed

receiving/sending ──temporary failure──> retry_scheduled
receiving ──permission/service block──> blocked
any active state ──disconnect/stop──> cancelled
```

A run is terminal only when receiving has completed and every queued operation is either acknowledged, explicitly empty, blocked, or represented by a retryable failure.

### Pending operation state

```text
pending -> sending -> acknowledged -> payload_deleted
pending/sending -> retry_scheduled -> sending
pending/sending -> blocked
pending/sending -> failed
```

A retry preserves `operationId`. A successful acknowledgement deletes the encrypted payload but may retain non-sensitive identity/state metadata long enough to prevent duplicate delivery.

## Validation rules

1. A record cannot be read or queued unless the source is available and the relevant read permission is currently granted.
2. The app must never request or use a Health Connect write permission in v1.
3. `startTime` and `endTime` must be valid; an end time cannot precede a start time.
4. A numeric measurement must have a compatible unit or an explicit unknown unit state.
5. A record identity must include the source platform and source record ID; a display label is not an identity.
6. A delete operation must reference an identity known to the index; an unrecognized deletion is recorded as an actionable data error rather than silently ignored.
7. A cursor is advanced only after all changes in the current page are durably represented in the queue or a recoverable failure is recorded.
8. If a cursor expires, the recovery read is bounded and deduplicated by identity/version; it must not create an unbounded local history.
9. A pending payload is encrypted before it is written to disk and is deleted after acknowledgement or explicit user clear/disconnect.
10. Status, logs, analytics, and error messages must not contain measurement values, payload bytes, access tokens, or the installation credential.
11. A submission is `sent` only after a positive acknowledgement; timeouts and ambiguous failures remain pending/retryable.
12. A repeated source change for the same identity/version is coalesced; a later version supersedes an unacknowledged older version.
13. A worker must claim an operation with a lease before sending it; expired leases are reclaimable and duplicate workers cannot process the same row concurrently.

## Retention and deletion

- Acknowledged health payloads: deleted immediately after the acknowledgement is durably recorded.
- Unsent payloads: retained only while needed for automatic retry, until acknowledgement or explicit user clear/disconnect.
- Cursors, identity indexes, counts, and sanitized error codes: retained as operational metadata; they contain no health values.
- Credential and encryption key: secure storage only; never copied into Drift, logs, or generated build output.
- App uninstall, operating-system data clear, or explicit disconnect removes local payloads according to the platform's storage behavior; the UI must not promise recovery after the user clears app data.

## Test data requirements

The domain test suite must cover:

- A record from a Samsung Health origin exposed through Health Connect.
- An unknown source label and a missing source value.
- A correction followed by a deletion for the same identity.
- Cursor expiry followed by a recovery read and deduplication.
- Partial permission where activity is available but vitals are blocked.
- An empty category, a service-unavailable state, a revoked permission, a credential failure, and a retryable network failure.
- A 1,000-record mixed-category payload with pagination and batch boundaries.
