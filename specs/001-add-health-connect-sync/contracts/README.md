# Contracts

These contracts define the boundaries that the implementation must preserve across Android and future iOS support.

- [`health-data-source.md`](health-data-source.md) — platform-neutral health source, permissions, cursors, and change reads.
- [`health-records-api.md`](health-records-api.md) — versioned POST submission and acknowledgement contract.
- [`sync-status.md`](sync-status.md) — independent receiving/sending states and accessibility rules.

The API base URL and installation credential are deployment configuration. They are intentionally not embedded in these documents or committed to the repository.
