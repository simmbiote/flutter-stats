# Security review

## Scope

This review covers the Android Flutter client, local pending outbox, WorkManager callback, and receiving API client.

## Controls

- Installation credentials are read from secure storage and are not placed in URLs, source, logs, or status.
- Pending health payloads are AES-GCM encrypted before persistence.
- Delete requests contain identity and mutation metadata only; they do not contain measurements.
- Every operation has a stable mutation ID used as the API idempotency key.
- API production URLs must use TLS; cleartext traffic is disabled in the Android manifest.
- Android backup is disabled for the application.
- Logs are redacted for credential-like and health-value-like fields.
- A disconnect clears unsent local health payloads.

## Deployment review

Before release, verify the resolved Android Health Connect client, WorkManager configuration, Play Health Connect declaration, privacy policy, credential provisioning, and staging API acknowledgement behavior. A mobile installation credential reduces account linkage but is not a permanent server secret; rotate it according to the receiving service's policy.

## Incident response

If a credential or payload is suspected to have been exposed, revoke/rotate the installation credential, stop delivery workers, preserve only sanitized diagnostics, and follow the receiving service's incident process. Do not export raw health payloads for debugging.
