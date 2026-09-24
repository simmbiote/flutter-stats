# Health Data Source Contract

**Purpose**: Platform-neutral boundary between the sync domain and Android/iOS health platforms.  
**Implementations**: `HealthConnectDataSource` in v1; a future `HealthKitDataSource` may implement the same contract.

## Availability and permissions

The source exposes:

- `checkAvailability()` → `available`, `not_installed`, `update_required`, `restricted`, or `unsupported`.
- `getPermissionSnapshot()` → current read permission for each supported record type plus background-read state.
- `requestReadPermissions(recordTypes)` → the post-request permission snapshot. It must request read access only.
- `revokeOrDisconnect()` → stops future reads/transfers and removes unsent local copies; it must not write to the health source.
- `openPermissionSettings()` → opens the appropriate system settings surface when the user must recover access.

Permission snapshots distinguish `granted`, `denied`, `revoked`, `restricted`, and `not_declared`. A source must not infer granted access from an empty read result.

## Record and change reads

The source exposes two read operations:

1. `readInitialWindow(start, end, recordTypes)` — reads a bounded initial window. The first authorized run uses the most recent 30 calendar days.
2. `readChanges(cursor, recordTypes)` — returns upserted records and deleted source record IDs, plus the next cursor and a `hasMore` flag.

The result must preserve:

- Stable source record ID.
- Record type and category mapping.
- Measurement/value shape and unit.
- Start/end times and offsets when available.
- Source and known origin, including Samsung Health when exposed.
- Provider version or a deterministic version used for change ordering.

A deletion result must be associated with the record type through the per-type cursor or the durable identity index. A source must not return a health value in a deletion event.

## Errors

The source maps platform errors to safe domain categories:

| Category | Meaning | Recovery |
|----------|---------|----------|
| `unavailable` | Health service is missing, unsupported, or restricted. | Show unavailable state; offer install/update/settings action when possible. |
| `permission_denied` | Required read access is absent or revoked. | Stop reading; show reconnect action. |
| `background_unsupported` | Background read feature is unavailable. | Keep foreground capability; explain automatic mode is blocked. |
| `rate_limited` | Platform request quota is exhausted. | Retry with backoff; do not spin. |
| `temporarily_unavailable` | IPC, service, or I/O failure. | Retry at the next permitted opportunity. |
| `cursor_expired` | Incremental cursor is no longer valid. | Run bounded recovery read and deduplicate. |
| `invalid_data` | A record cannot be safely normalized. | Preserve a safe error category; do not log the value. |

Error details exposed to the UI may contain a user-facing explanation, but never raw health values, access tokens, or credential material.

## Change-token rules

- Use a separate cursor per source platform and record type.
- Advance a cursor only after the returned page is durably queued or safely classified as an error.
- Process all pages before advancing the durable cursor to the final page token.
- On cursor expiry, perform a bounded recovery read and reconcile by stable identity/version.
- A source adapter may use a provider-specific token internally, but the domain sees only an opaque cursor.

## Source attribution

`source` identifies the platform/app/device that supplied the record. `knownOrigin` identifies a product origin such as Samsung Health when the provider exposes it. Neither field may contain credentials or be used as the record identity.

## Background execution boundary

The source does not schedule work itself. `SyncScheduler` owns periodic and one-off execution so that Android WorkManager and a future iOS scheduler can share the same domain coordinator.

The scheduler must request an immediate run after permission grant, app resume, or a recoverable network state, and maintain a unique periodic run at the platform's supported interval. A delayed run is represented as pending/waiting; it is not reported as successful before the source and API steps complete.
