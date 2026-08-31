import 'dart:async';
import 'dart:io';
import 'package:anxolotl_app/src/data/services/health/watch_streaming_service.dart';
import 'package:flutter/cupertino.dart';
 
class WatchViewModel extends ChangeNotifier {
  final WatchStreamingService _service;
 
  bool _isRecording = false;
  bool get isRecording => _isRecording;
 
  String? _lastSavedPath;
  String? get lastSavedPath => _lastSavedPath;
 
  bool get isConnected => _lastHr != null;
 
  double? _lastHr;
  StreamSubscription? _sub;
 
  WatchViewModel(this._service) {
    // Apenas para saber se o Watch está ligado
    _sub = _service.dataStream.listen((data) {
      if (data.hr != null) {
        _lastHr = data.hr;
        notifyListeners();
      }
    });
  }
 
  void startRecording() {
    _lastSavedPath = null;
    _isRecording = true;
    _service.startRecording();
    notifyListeners();
  }
 
  Future<void> stopRecording() async {
    _isRecording = false;
    notifyListeners();
    _lastSavedPath = await _service.stopRecording();
    notifyListeners();
  }
 
  Future<List<File>> listSessions() => _service.listSessions();
 
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}