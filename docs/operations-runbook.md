# Operations runbook

## Routine checks

1. Confirm the app can reach Health Connect and shows the expected permission state.
2. Confirm the unique periodic worker is scheduled at the Android 15-minute minimum.
3. Confirm the receiving API returns a positive acknowledgement for a synthetic operation.
4. Confirm the pending count drops to zero after acknowledgement.
5. Review only category/source counts and safe error categories.

## Background deferral

A `waiting`, `paused`, or `retry_scheduled` status is truthful when Android, battery policy, network conditions, or service quotas defer work. Do not convert deferred work into a success state without an acknowledgement.

## Token expiry

If a Health Connect change token expires, clear the affected cursor, perform a bounded 30-day recovery read, and deduplicate by stable source identity/version. Do not fabricate deleted measurements.

## Credential rotation

Provision a new installation credential through the deployment process, update the secure store on the test installation, and verify old credentials are rejected. Never place the credential in a ticket, log, or committed file.
