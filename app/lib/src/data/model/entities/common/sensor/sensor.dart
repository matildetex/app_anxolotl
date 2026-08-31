import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/activity_measurement_protocol.dart';
import 'package:anxolotl_app/src/data/model/entities/common/measurement_protocols/hr_measurement_protocol.dart';

enum Sensor {
  //Only used for testing
  TEST,

  //Electromyogram
  EMG,

  //Electrocardiogram
  ECG,

  //Electrodermal Activity
  EDA,

  // Electroencephalogram
  EEG,

  // Acceleration
  ACC,

  // Light Intensity
  LUX,

  // Respiration
  PZT,

  //Temperature
  TMP,

  //Oxygen saturation
  OSL,

  //Blood Pressure
  BPR,

  //Glucose Meter
  GMR,

  // NEWWWWWW
  BATTERY,

  HR,

  IBI,

  PPG,

  ACTIVITY,
}

extension NameExtension on Sensor {
  String get fullName {
    switch (this) {
      case Sensor.TEST:
        return "TestTest";
      case Sensor.EMG:
        return "Electromyogram";
      case Sensor.ECG:
        return "Electrocardiogram";
      case Sensor.EDA:
        return "Electrodermal Activity";
      case Sensor.EEG:
        return "Electroencephalogram";
      case Sensor.ACC:
        return "Acceleration";
      case Sensor.LUX:
        return "Light Intensity";
      case Sensor.PZT:
        return "Respiration";
      case Sensor.TMP:
        return "Temperature";
      case Sensor.OSL:
        return "Oximetry";
      case Sensor.BPR:
        return "Blood Pressure";
      case Sensor.GMR:
        return "Glucose Meter";
      case Sensor.BATTERY:
        return "Battery";
      case Sensor.HR:
        return "Heart rate";
      case Sensor.PPG:
        return "PPG";
      case Sensor.IBI:
        return "IBI";
      case Sensor.ACTIVITY:
        return "Activity";
      default:
        throw UnimplementedError();
    }
  }
}

extension unitInfo on Sensor {
  String get measuredUnit {
    switch (this) {
      case Sensor.TEST:
        return "TestUnit";
      case Sensor.EMG:
        return "mV";
      case Sensor.ECG:
        return "mV";
      case Sensor.EDA:
        return "𝜇S";
      case Sensor.EEG:
        return "𝜇V";
      case Sensor.ACC:
        return "g";
      case Sensor.LUX:
        return "lux";
      case Sensor.PZT:
        return "V/µε";
      case Sensor.TMP:
        return "ºC";
      case Sensor.OSL:
        return "%";
      case Sensor.BPR:
        return "mm/Hg";
      case Sensor.GMR:
        return "mg/dL";
      case Sensor.BATTERY:
        return "%";
      case Sensor.HR:
        return "bpm";
      case Sensor.PPG:
        return "mV";
      case Sensor.IBI:
        return "mS";
      case Sensor.ACTIVITY:
        return "unit";
      default:
        throw UnimplementedError();
    }
  }
}

extension measurementProtocol on Sensor {
  bool Function(Map<String, dynamic> values) get filterValues {
    switch (this) {
      case Sensor.IBI:
        return (Map<String, dynamic> values) =>
            HrMeasurementProtocol.filterValue(values);
      case Sensor.ACTIVITY:
        return (Map<String, dynamic> values) =>
            ActivityMeasurementProtocol.filterValue(values);
      default:
        return (a) => true;
    }
  }
}
