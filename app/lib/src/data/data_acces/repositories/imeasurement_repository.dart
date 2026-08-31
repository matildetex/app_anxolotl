import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_data.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';

abstract class IMeasurementRepository {
  Iterable<MeasurementData> readAllLocal(String userId);

  void saveLocal(String userId, MeasurementData measurement);

  Future<void> saveUpload(
      AuthProfile authProfile, MeasurementData measurementData);

  Future<int> multiSaveUpload(
      AuthProfile authProfile, Iterable<MeasurementData> measurementData);

  void deleteLocal(String measurementId);
}
