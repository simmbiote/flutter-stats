# Health data privacy

Flutter Stats is read-only. It does not request write permissions and does not modify Health Connect or Samsung Health.

## Data handling

- Health values are held in memory only while being read, normalized, encrypted, and delivered.
- Pending payloads are encrypted with AES-GCM before being written to the Drift database.
- The encryption key and installation credential are stored in platform secure storage.
- A payload is deleted after the receiving service returns a positive acknowledgement.
- Disconnecting clears unsent local health data and cancels scheduled work.
- Status, errors, logs, and crash diagnostics may contain categories, counts, source labels, and safe error categories only.

## User choices

The connection screen explains the read scope before requesting permissions. Users can revoke access in system settings or use Disconnect in the app. Disconnect does not write to the health source.

## Samsung Health

Samsung Health data is included only when Health Connect exposes a record with Samsung Health source metadata. The first release does not use the Samsung Health Data SDK or create a second consent system.
