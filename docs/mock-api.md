# Local mock receiving API

The repository includes a dependency-free mock server at `tool/mock_health_api.dart`. It implements the `POST /v1/health-records` contract for local development and device testing.

## Start it

```sh
dart run tool/mock_health_api.dart --port 8787
```

The default development credential is `dev-credential`. The server accepts:

- `Authorization: Bearer dev-credential`
- `Content-Type: application/json`
- `Idempotency-Key: <stable-operation-id>`
- `X-Schema-Version: 1`

It returns a positive acknowledgement such as:

```json
{
  "operation_id": "mock-upsert",
  "status": "accepted",
  "accepted": true,
  "accepted_record_ids": ["fixture-record"],
  "rejected_record_ids": []
}
```

Repeated requests with the same idempotency key and identical body return the original acknowledgement. Reusing a key with a different body returns `409`.

## Connect an Android device with synthetic data

The local mock server must only be used with the synthetic source. This prevents real Samsung Health records from being sent to a development process.

For a USB-connected device, forward the host port to the phone:

```sh
$HOME/Library/Android/sdk/platform-tools/adb reverse tcp:8787 tcp:8787
flutter run -d <device-id> \
  --dart-define=HEALTH_USE_FAKE_SOURCE=true \
  --dart-define=HEALTH_API_BASE_URL=http://127.0.0.1:8787
```

In the app, open the key icon and securely save `dev-credential`.

For a completely in-memory synthetic run, use both fake flags instead:

```sh
flutter run -d <device-id> \
  --dart-define=HEALTH_USE_FAKE_SOURCE=true \
  --dart-define=HEALTH_USE_FAKE_API=true
```

The cleartext override exists only in the debug manifest. Release builds continue to reject cleartext traffic and must use HTTPS. The app also refuses to pair the real Health Connect source with an HTTP endpoint, even in debug builds.

For a real-source device test, use an HTTPS staging endpoint and a staging credential. Do not use the local mock server for real health data. A permission-only check can be run without an API URL and with `HEALTH_ENABLE_AUTOMATIC_SYNC=false`; it must not be used to inspect or transmit health values.

## Failure scenarios

```sh
dart run tool/mock_health_api.dart --scenario=401
dart run tool/mock_health_api.dart --scenario=429
dart run tool/mock_health_api.dart --scenario=500
dart run tool/mock_health_api.dart --scenario=malformed
dart run tool/mock_health_api.dart --scenario=reject
```

The server logs only operation names, record counts, duplicate-key events, and errors. It does not log health measurements or credentials.
