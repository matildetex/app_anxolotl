enum SensorFrequency {
  /// 1 Hz
  HZ1,

  /// 10 Hz
  HZ10,

  /// 100 Hz
  HZ100,

  /// 1000 Hz
  HZ1000,
}

extension valueExtension on SensorFrequency {
  int serialize() {
    switch (this) {
      case SensorFrequency.HZ1:
        return 1;
      case SensorFrequency.HZ10:
        return 10;
      case SensorFrequency.HZ100:
        return 100;
      case SensorFrequency.HZ1000:
        return 1000;
      default:
        throw UnimplementedError();
    }
  }
}
