# Sync Status Contract

**Purpose**: Stable user-visible and diagnostic state for the read and send portions of automatic synchronization.

## State dimensions

Receiving and sending are independent dimensions. A run may be receiving while sending is `waiting`, or sending may be `retry_scheduled` while receiving is `complete`.

### Receiving states

| State | Meaning |
|-------|---------|
| `waiting` | Connection is enabled; no new change page is currently being read. |
| `receiving` | A source read/change operation is in progress. |
| `empty` | The checked range/category has no eligible new records. |
| `blocked` | Permission, service, or background-read prerequisite prevents reading. |
| `paused` | A device or app policy temporarily deferred work. |
| `failed` | A terminal or exhausted read error occurred. |
| `complete` | The current read phase finished successfully. |

### Sending states

| State | Meaning |
|-------|---------|
| `waiting` | No records are waiting to be sent. |
| `sending` | One or more operations are being submitted. |
| `sent` | The current operation received a positive acknowledgement. |
| `empty` | Receiving found no records to send. |
| `blocked` | Credential, authorization, or validation state prevents sending. |
| `retry_scheduled` | A retryable transport/service error is waiting for backoff. |
| `failed` | A non-retryable or exhausted failure requires attention. |

## Status snapshot

The UI receives a snapshot containing:

- Current `receiveState` and `sendState`.
- `lastSuccessfulSyncAt`, when available.
- Counts by category and source label.
- Pending operation count and current safe error category.
- Whether automatic processing is enabled, deferred, or blocked.
- Whether the last outcome occurred while the app was inactive.

The snapshot MUST NOT include measurement values, encrypted payload bytes, tokens, or credentials.

## Accessibility and layout requirements

- Each state has a text label and semantic description; color is supplementary only.
- Receiving and sending are separately announced and separately actionable.
- Empty, blocked, paused, retrying, and failed states include a next action or a clear reason.
- The status view remains usable at small widths and with large text.
- The last successful time is shown in a locale-aware, understandable format.

## Update rules

- State transitions are persisted before the UI is notified when the process may be killed.
- A state is `sent` only after acknowledgement, never after request dispatch.
- A temporary source/API failure changes the relevant dimension to `retry_scheduled`/`paused` without erasing the last successful timestamp.
- A disconnect changes automatic processing to disabled and prevents new operations from being queued.
