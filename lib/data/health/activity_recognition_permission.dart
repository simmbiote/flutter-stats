import 'dart:io';

import 'package:flutter/services.dart';

class ActivityRecognitionPermission {
  const ActivityRecognitionPermission();

  static const _channel = MethodChannel('flutter_stats/activity_recognition');

  Future<bool> request() async {
    if (!Platform.isAndroid) return true;
    return await _channel.invokeMethod<bool>('request') ?? false;
  }
}
