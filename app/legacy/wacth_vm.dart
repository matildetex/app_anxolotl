import 'dart:async';
import 'package:anxolotl_app/src/data/services/health/watch_streaming_service.dart';
import 'package:flutter/cupertino.dart';

class WatchViewModel extends ChangeNotifier {
  final WatchStreamingService _watchStreamingService;

  double? _hr;
  double? _ibi;
  double? _steps;
  double? _calories;
  double? _distance;

  StreamSubscription? _subscription;

  WatchViewModel(this._watchStreamingService) {
    _subscription = _watchStreamingService.dataStream.listen((data) {
      if (data.hr != null) _hr = data.hr;
      if (data.ibi != null) _ibi = data.ibi;
      if (data.steps != null) _steps = data.steps;
      if (data.calories != null) _calories = data.calories;
      if (data.distance != null) _distance = data.distance;
      notifyListeners();
    });
  }

  double? get hr => _hr;
  double? get ibi => _ibi;
  double? get steps => _steps;
  double? get calories => _calories;
  double? get distance => _distance;

  bool get isReceivingData => _hr != null;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}