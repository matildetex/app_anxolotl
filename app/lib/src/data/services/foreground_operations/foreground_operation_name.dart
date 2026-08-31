
enum ForegroundOperationName { DISCRETE_MEASUREMENT, CONTINUOUS_MEASUREMENT }

class ForegroundOperationsArguments {
  static const String STOP_ARG = "stopService";

  static const String BATTERY_REQ_ARG = "getBatteryValue";
  static const String BATTERY_RESP_ARG = "returnBatteryValue";
  static const String BATTERY_RESP_MAP_ARG = "returnBatteryValueMap";

  static const String AUTHPROFILE_ARG = "authProfileArg";
  static const String AUTHPROFILE_MAP_ARG = "authProfileMapArg";

  static const String WORK_CONFIGS_ARG = "workConfigsArg";
  static const String WORK_SAMPLING_INTERVAL_ARG = "WorkReconnectIntervalArg";
  static const String WORK_SYNC_INTERVAL_ARG = "WorkSyncIntervalArg";

  static const String TRANSLATED_STR_ARG = "translatedStrArg";
  static const String RESTART_NOTIFICATION = "restartNotification";

  static const String AMQP_CONFIGS_ARG = "AmqpConfigsArg";
  static const String AMQP_CONFIGS_HOST_ARG = "AmqpConfigsHostArg";
  static const String AMQP_CONFIGS_PORT_ARG = "AmqpConfigsPortArg";
}

class LangArgs {
  static const String ERROR_FOUND = "errorFound";
  static const String SUCCESS = "success";
  static const String MEASURES = "measures";
  static const String SYNC = "sync";

  static const String PREPARING = "preparing";
  static const String LAST_MEASUREMENT = "lastMeasurement";
  static const String SYNCING = "returnBatteryValueMap";

  static const String DEVICE_NOT_CONNECTED = "deviceNotConnected";
  static const String INTERNET_NOT_CONNECTED = "internetNotConnected";
}
