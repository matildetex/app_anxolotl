import 'package:flutter_background_service/flutter_background_service.dart';

abstract class ForegroundOperation {
  Future<void> startForegroundTask(FlutterBackgroundService service,
      [String? takingMeasurementsString]);
}
