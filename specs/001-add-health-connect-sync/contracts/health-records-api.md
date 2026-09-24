# Receiving API Contract: Health Records

The machine-readable OpenAPI 3.0 contract is maintained at [`docs/health-records-api.openapi.yaml`](../../../docs/health-records-api.openapi.yaml).

**Purpose**: Versioned client contract for submitting received and changed health records to the configured API.  
**Transport**: HTTPS `POST` in production.  
**Default path**: `/v1/health-records` (configurable through `ApiConfiguration`).  
**Schema version**: `1`.

The API base URL and installation credential are deployment inputs. No endpoint, token, or secret is committed to the repository.

## Authentication

Every request includes:

```http
Authorization: Bearer <installation-credential>
Content-Type: application/json
Idempotency-Key: <stable-operation-id>
X-Schema-Version: 1
X-Client-Version: <app-version>
```

The installation credential is read from secure storage. It is never placed in a URL, status widget, log, crash report, or generated source file. Production endpoints must use TLS. Local test fixtures may use a local mock transport.

## Request envelope

Upserts and deletes are separate requests so acknowledgement and retry semantics are unambiguous.

### Upsert request

```json
{
  "schema_version": "1",
  "source_platform": "android_health_connect",
  "operation": "upsert",
  "records": [
    {
      "record_id": "opaque-source-record-id",
      "mutation_id": "opaque-client-operation-id",
      "record_type": "steps",
      "category": "activity",
      "lifecycle": "active",
      "source_version": "provider-version-or-content-version",
      "start_time": "2026-09-24T08:00:00Z",
      "end_time": "2026-09-24T08:15:00Z",
      "start_offset": "+02:00",
      "end_offset": "+02:00",
      "measurement": {
        "kind": "numeric",
        "value": 1240,
        "unit": "count"
      },
      "source": {
        "label": "Samsung Health",
        "package_name": "com.sec.android.app.shealth"
      },
      "known_origin": "samsung_health",
      "received_at": "2026-09-24T08:16:00Z"
    }
  ]
}
```

### Delete request

```json
{
  "schema_version": "1",
  "source_platform": "android_health_connect",
  "operation": "delete",
  "records": [
    {
      "record_id": "opaque-source-record-id",
      "mutation_id": "opaque-client-operation-id",
      "record_type": "steps",
      "category": "activity",
      "source_version": "last-known-provider-version"
    }
  ]
}
```

Delete requests contain no health measurement values.

## Field rules

| Field | Rule |
|-------|------|
| `schema_version` | Must be `1` for this contract. |
| `source_platform` | Canonical platform name; v1 sends `android_health_connect`. |
| `operation` | `upsert` or `delete`; never mixed in one request. |
| `records` | 1–100 items in v1. The client splits larger queues deterministically. |
| `record_id` | Opaque, stable source identity; never a display label. |
| `mutation_id` | Stable client-generated operation identity; must remain unchanged across retries. |
| `record_type` | Canonical type mapped by the data-source adapter. |
| `category` | `activity`, `vitals`, `sleep`, or `body`. |
| `lifecycle` | `active` or `corrected` for upserts; deletes use the operation field. |
| `source_version` | Used to reject stale updates and make retries idempotent. |
| `start_time`/`end_time` | UTC ISO-8601 timestamps; offsets are preserved separately when available. |
| `measurement` | Discriminated by `kind`; numeric, interval/session, or categorical shape must match `record_type`. |
| `unit` | Source or canonical unit; required for numeric measurements unless explicitly unknown. |
| `source` | Safe source label/package/device metadata; no credentials. |
| `known_origin` | `samsung_health`, `health_connect`, or `unknown` when known. |
| `received_at` | UTC timestamp supplied by the app. |

## Acknowledgement

A successful response is any defined `2xx` response. The response must identify the operation and the accepted/rejected record IDs.

```json
{
  "operation_id": "opaque-operation-id",
  "status": "accepted",
  "accepted_record_ids": ["opaque-source-record-id"],
  "rejected_record_ids": []
}
```

Partial acceptance is valid. The client marks accepted operations `acknowledged`, keeps rejected operations in a safe failed/blocked state, and never deletes a rejected payload as if it had succeeded.

## Error responses

| HTTP outcome | Client behavior |
|--------------|-----------------|
| `400` | Validation failure; mark the affected operation blocked and show a user-safe explanation. Do not retry unchanged data indefinitely. |
| `401`/`403` | Credential/authorization failure; mark sending blocked, retain unsent payloads, and request deployment configuration correction. |
| `408`, `425`, `429` | Retryable; honor `Retry-After` when present and use bounded exponential backoff. |
| `5xx` | Retryable with bounded exponential backoff. |
| Network timeout/connection error | Retryable; preserve the same idempotency key. |
| Malformed/unknown response | Do not mark sent; record a safe contract error and retain the queue. |

Error bodies are not copied into user-facing status or logs unless a server-provided safe message is explicitly allow-listed.

## Idempotency and ordering

- `Idempotency-Key` is derived from the stable operation ID and remains unchanged across retries.
- The body also carries `mutation_id`; the API must atomically associate the key, mutation ID, and result.
- The API must treat a repeated key as the same logical operation and return the original result for the same payload.
- Reusing a key with a different payload is a contract error and must not create a second mutation.
- The client sends one record version per identity at a time; a newer version supersedes an older unacknowledged version.
- The client may send operations in queue order, but the API must use `record_id`, `source_version`, and `mutation_id` for conflict resolution.
- A delete is ordered after the latest known upsert for the same identity.

## Retention and privacy

The client sends only the fields required for synchronization. It does not send local queue state, permission diagnostics, unneeded free-form metadata, access tokens, or local encryption material. The client deletes an encrypted local payload only after a positive acknowledgement or explicit user clear/disconnect.

## Contract validation

Before release, validate the contract with fixtures for:

1. A successful upsert batch.
2. A successful delete batch.
3. Partial acceptance.
4. Duplicate retry with the same idempotency key.
5. `401`, `429`, `5xx`, timeout, and malformed response.
6. A stale source version and a newer corrected version.
7. A Samsung Health-origin record and a record with unknown source metadata.
