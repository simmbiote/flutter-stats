import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/data/health/fake_health_data_source.dart';
import 'package:flutter_stats/data/health/permission_catalog.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  test('reports permission state separately from an empty read', () async {
    final source = FakeHealthDataSource(granted: false);
    final denied = await source.getPermissionSnapshot();
    expect(denied.state, ConnectionState.denied);
    expect(denied.permissions.values, everyElement(PermissionStatus.denied));

    final connected = await source.requestReadPermissions(['steps', 'sleep']);
    expect(connected.state, ConnectionState.connected);
    expect(connected.permissions['steps'], PermissionStatus.granted);
    expect(connected.permissions['sleep'], PermissionStatus.granted);
  });

  test('Android permission catalog uses adapter-supported types', () {
    const catalog = PermissionCatalog();
    final distance = catalog.byRecordType('distance')!;
    final exercise = catalog.byRecordType('exercise_session')!;
    expect(distance.healthTypes.single.name, 'DISTANCE_DELTA');
    expect(exercise.healthTypes.single.name, 'WORKOUT');
    expect(
      exercise.typesToRequest.map((type) => type.name),
      containsAll(['WORKOUT', 'TOTAL_CALORIES_BURNED']),
    );
  });

  test('empty source data is not interpreted as granted permission', () async {
    final source = FakeHealthDataSource(granted: true, records: const []);
    final result = await source.readInitialWindow(
      start: DateTime.utc(2026, 9, 1),
      end: DateTime.utc(2026, 9, 2),
      recordTypes: const ['steps'],
    );
    expect(result.records, isEmpty);
    final snapshot = await source.getPermissionSnapshot(recordTypes: ['steps']);
    expect(snapshot.state, ConnectionState.connected);
  });
}
