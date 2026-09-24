import 'package:flutter_stats/data/health/fake_health_data_source.dart';

class TestHealthDataSource extends FakeHealthDataSource {
  TestHealthDataSource({
    super.available,
    super.granted,
    super.backgroundAuthorized,
    super.records,
    super.changes,
  });
}
