import 'package:flutter_watch_os_connectivity/flutter_watch_os_connectivity.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AccSample {
  final double timestamp;
  final double x;
  final double y;
  final double z;

  AccSample({
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
  });

  String toCsvRow() =>
      '${timestamp.toStringAsFixed(3)},,,,,,${ x.toStringAsFixed(4)},${y.toStringAsFixed(4)},${z.toStringAsFixed(4)}';
}

class WatchData {
  final double? hr;
  final double? ibi;
  final double? steps;
  final double? calories;
  final double? distance;
  final double? accX;
  final double? accY;
  final double? accZ;
  final double timestamp;

  WatchData({
    this.hr,
    this.ibi,
    this.steps,
    this.calories,
    this.distance,
    this.accX,
    this.accY,
    this.accZ,
    required this.timestamp,
  });

  String toCsvRow() {
    return '${timestamp.toStringAsFixed(3)},'
        '${hr?.toStringAsFixed(2) ?? ""},'
        '${ibi?.toStringAsFixed(2) ?? ""},'
        '${steps?.toStringAsFixed(0) ?? ""},'
        '${calories?.toStringAsFixed(3) ?? ""},'
        '${distance?.toStringAsFixed(1) ?? ""},'
        '${accX?.toStringAsFixed(4) ?? ""},'
        '${accY?.toStringAsFixed(4) ?? ""},'
        '${accZ?.toStringAsFixed(4) ?? ""}';
  }
}

class WatchStreamingService {
  final FlutterWatchOsConnectivity _connectivity = FlutterWatchOsConnectivity();

  final StreamController<WatchData> _dataController =
      StreamController<WatchData>.broadcast();
  Stream<WatchData> get dataStream => _dataController.stream;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  final List<WatchData> _sessionBuffer = [];
  int _sessionCounter = 0;

  Stream<double> get bpmStream =>
      dataStream.where((d) => d.hr != null).map((d) => d.hr!);

  Future<void> init() async {
    await _connectivity.configureAndActivateSession();

    final dir = await getApplicationDocumentsDirectory();
    final counterFile = File('${dir.path}/session_counter.txt');
    if (await counterFile.exists()) {
      _sessionCounter = int.tryParse(await counterFile.readAsString()) ?? 0;
    }

    _connectivity.messageReceived.listen((message) {
      final data = message.data;

      // Batch de acelerómetro
      if (data.containsKey('acc_batch')) {
        final batch = data['acc_batch'] as List<dynamic>;
        for (final sample in batch) {
          final s = sample as Map<dynamic, dynamic>;
          final watchData = WatchData(
            timestamp: double.parse(s['t'].toString()),
            accX: double.parse(s['x'].toString()),
            accY: double.parse(s['y'].toString()),
            accZ: double.parse(s['z'].toString()),
          );
          _dataController.add(watchData);
          if (_isRecording) _sessionBuffer.add(watchData);
        }
        return;
      }

      // Dados fisiológicos normais (HR, steps, etc.)
      final timestamp = data.containsKey('timestamp')
          ? double.parse(data['timestamp'].toString())
          : DateTime.now().millisecondsSinceEpoch / 1000.0;

      final watchData = WatchData(
        hr: data.containsKey('hr') ? double.parse(data['hr'].toString()) : null,
        ibi: data.containsKey('ibi') ? double.parse(data['ibi'].toString()) : null,
        steps: data.containsKey('steps') ? double.parse(data['steps'].toString()) : null,
        calories: data.containsKey('calories') ? double.parse(data['calories'].toString()) : null,
        distance: data.containsKey('distance') ? double.parse(data['distance'].toString()) : null,
        timestamp: timestamp,
      );

      _dataController.add(watchData);
      if (_isRecording) _sessionBuffer.add(watchData);
    });
  }

  void startRecording() {
    _sessionBuffer.clear();
    _isRecording = true;
    sendRecordingState(true);
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    _isRecording = false;
    sendRecordingState(false);
    if (_sessionBuffer.isEmpty) return null;
    return await _exportToCsv();
  }

  Future<void> sendRecordingState(bool isRecording) async {
    try {
      await _connectivity.sendMessage({'recording': isRecording});
    } catch (e) {
    }
  }

  Future<String?> _exportToCsv() async {
    try {
      _sessionCounter++;
      final dir = await getApplicationDocumentsDirectory();
      final sessionsDir = Directory('${dir.path}/anxolotl_sessions');
      if (!await sessionsDir.exists()) await sessionsDir.create(recursive: true);

      await File('${dir.path}/session_counter.txt').writeAsString('$_sessionCounter');

      final fileName = 'session_${_sessionCounter.toString().padLeft(4, '0')}.csv';
      final file = File('${sessionsDir.path}/$fileName');

      final buffer = StringBuffer();
      buffer.writeln('timestamp_unix,hr_bpm,ibi_ms,steps,calories_kcal,distance_m,acc_x,acc_y,acc_z');
      for (final row in _sessionBuffer) {
        buffer.writeln(row.toCsvRow());
      }

      await file.writeAsString(buffer.toString());
      return file.path;
    } catch (e) {
      return null;
    }
  }

  Future<List<File>> listSessions() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final sessionsDir = Directory('${dir.path}/anxolotl_sessions');
      if (!await sessionsDir.exists()) return [];
      return sessionsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.csv'))
          .toList()
        ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    } catch (e) {
      return [];
    }
  }

  void dispose() {
    _dataController.close();
  }
}