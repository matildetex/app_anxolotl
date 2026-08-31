
class AmqpInfo {
  static const username = "app_user";
  static const userPass = "5945appPass";
}

enum AmqpPaths {
  HRV_EXC,
  USER_INFO_EXC,
  ANXIETY_RESULTS_QUEUE,
  PANIC_RESULTS_QUEUE,
  STRESS_RESULTS_QUEUE,
}

extension Instance on AmqpPaths {
  String get getAmqpName {
    switch (this) {
      case AmqpPaths.HRV_EXC:
        return "hrv_data_exc";
      case AmqpPaths.USER_INFO_EXC:
        return "user_info_exc";
      case AmqpPaths.ANXIETY_RESULTS_QUEUE:
        return "anxiety_results_q";
      case AmqpPaths.PANIC_RESULTS_QUEUE:
        return "panic_results_q";
      case AmqpPaths.STRESS_RESULTS_QUEUE:
        return "stress_results_q";
      default:
        return "";
    }
  }
}
