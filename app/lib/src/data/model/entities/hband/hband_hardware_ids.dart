
class HBandServices {
  static const String ACTIVITY = "feca57d9-7aee-fbbd-a144-3c695a4baaeb";
  static const String PULSEON_SERVICE = "feca57d0-7aee-fbbd-a144-3c695a4baaeb";
  static const String BATTERY_SERVICE = "0000180f-0000-1000-8000-00805f9b34fb";
  static const String OBJECT_TRANSFER_SERVICE =
      "00001825-0000-1000-8000-00805f9b34fb";
  static const String HEART_RATE_SERVICE =
      "0000180d-0000-1000-8000-00805f9b34fb";
}

class HBandCharacteristics {
  static final PulseOnServiceCharacteristics pulseOnServiceCharacteristics =
      PulseOnServiceCharacteristics();
  static final BatteryServiceCharacteristics batteryServiceCharacteristics =
      BatteryServiceCharacteristics();
  static final HeartRateServiceCharacteristics heartRateServiceCharacteristics =
      HeartRateServiceCharacteristics();
}

class PulseOnServiceCharacteristics {
  final String OPERATIONAL_PARAMETERS = "feca57d6-7aee-fbbd-a144-3c695a4baaeb";
  final String HEART_RATE_DATA = "feca57da-7aee-fbbd-a144-3c695a4baaeb";
  final String ACTIVITY_DATA = "feca57d9-7aee-fbbd-a144-3c695a4baaeb";
  final String PPG_DATA = "feca57db-7aee-fbbd-a144-3c695a4baaeb";
}

class BatteryServiceCharacteristics {
  final String BATTERY_PERCENTAGE = "00002a19-0000-1000-8000-00805f9b34fb";
}

class HeartRateServiceCharacteristics {
  final String HEART_RATE_MEASUREMENT = "00002a37-0000-1000-8000-00805f9b34fb";
}
