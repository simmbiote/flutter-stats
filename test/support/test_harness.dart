import 'package:flutter_stats/core/ids/id_generator.dart';
import 'package:flutter_stats/core/time/clock.dart';

class FixedClock implements Clock {
  FixedClock(this.value);

  DateTime value;

  @override
  DateTime nowUtc() => value.toUtc();
}

class SequentialIdGenerator implements IdGenerator {
  int _value = 0;

  @override
  String next() => 'test-id-${_value++}';
}
