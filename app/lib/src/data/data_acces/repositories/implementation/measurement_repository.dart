import 'package:anxolotl_app/src/data/data_acces/api/amqp/amqp_api.dart';
import 'package:anxolotl_app/src/data/data_acces/database/generated/objectbox.g.dart';
import 'package:anxolotl_app/src/data/data_acces/database/object_box_db.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/mapper/measurement_data_mapper.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/measurements/measurement_json_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/db/measurements/measurement_db_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/db/measurements/measurement_row_entry_db_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/imeasurement_repository.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_data.dart';
import 'package:anxolotl_app/src/data/model/entities/measurements/implementations/measurement_row.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';

class MeasurementRepository extends IMeasurementRepository {
  final Store _db = ObjectBoxDb().getDatabase();
  late final Box<MeasurementDbDto> _measurementBox;
  late final Box<MeasurementRowEntryDbDto> _measurementRowBox;
  final AmqpApi amqpApi;

  MeasurementRepository(this.amqpApi) {
    _measurementBox = _db.box<MeasurementDbDto>();
    _measurementRowBox = _db.box<MeasurementRowEntryDbDto>();
    //deleteAll();
  }

  Future<void> deleteAll() async {
    _measurementBox.removeAll();
    _measurementRowBox.removeAll();
  }

  @override
  void deleteLocal(String measurementId) {
    Query<MeasurementDbDto> measurementQuery = _measurementBox
        .query(MeasurementDbDto_.measurementId.equals(measurementId))
        .build();

    List<MeasurementDbDto> measurementDbDtoList = measurementQuery.find();
    for (var measurementDbDto in measurementDbDtoList) {
      _measurementBox.remove(measurementDbDto.id);
    }

    Query<MeasurementRowEntryDbDto> measurementRowQuery = _measurementRowBox
        .query(MeasurementRowEntryDbDto_.measurementId.equals(measurementId))
        .build();

    List<MeasurementRowEntryDbDto> measurementRowList =
        measurementRowQuery.find();
    for (var sensorValue in measurementRowList) {
      _measurementRowBox.remove(sensorValue.id);
    }
  }

  @override
  Iterable<MeasurementData> readAllLocal(String userId) {
    Iterable<MeasurementData> measurementDataList = _measurementBox
        .getAll()
        .where((measurementDbDto) => measurementDbDto.userId == userId)
        .map((measurementDbDto) => measurementDbDto.mapToMeasurementData());

    //Falta ir buscar as rows lol

    return measurementDataList.map((measurement) {
      Query<MeasurementRowEntryDbDto> measurementRowsQuery = _measurementRowBox
          .query(MeasurementRowEntryDbDto_.measurementId
              .equals(measurement.getMeasurementId()))
          .build();

      List<MeasurementRowEntryDbDto> measurementRowEntryList =
          measurementRowsQuery.find();
      for (var measurementRowDto in measurementRowEntryList) {
        measurement.addSingleRow(measurementRowDto.timestamp,
                  measurementRowDto.key, measurementRowDto.value);
      }

      return measurement;
    });
  }

  @override
  void saveLocal(String userId, MeasurementData measurementData) {
    final MeasurementDbDto measurementDbDto =
        MeasurementDbDto.fromMeasurement(userId, measurementData);
    final int measurementId = _measurementBox.put(measurementDbDto);
    measurementDbDto.id = measurementId;

    //debug
    //measurementData.getResults().forEach((element) => print(element.getResults().toString() + "\n"));

    measurementData.getResults().forEach((MeasurementRow measurementRow) {
      measurementRow.getResults().forEach((name, value) {
        MeasurementRowEntryDbDto measurementRowEntryDbDto =
            MeasurementRowEntryDbDto(measurementData.getMeasurementId(),
                measurementRow.timestamp, name, value.toString());
        final int measurementRowEntryDbDtoId =
            _measurementRowBox.put(measurementRowEntryDbDto);
        measurementRowEntryDbDto.id = measurementRowEntryDbDtoId;
      });
    });
  }

  @override
  Future<void> saveUpload(
      AuthProfile authProfile, MeasurementData measurementData) async {
    MeasurementJsonDto measurementJsonDto =
        MeasurementDataMapper.measurementToMeasurementDto(
            authProfile, measurementData);

    print("#### save upload -${measurementJsonDto.toJson()}");
    await amqpApi.uploadMeasurement(measurementJsonDto);
    print("#### finished save upload");
  }

  @override
  Future<int> multiSaveUpload(AuthProfile authProfile,
      Iterable<MeasurementData> measurementData) async {
    Iterable<MeasurementJsonDto> measurementsJsonDto = measurementData.map(
        (measurementData) => MeasurementDataMapper.measurementToMeasurementDto(
            authProfile, measurementData));

    print("#### save upload -");
    return await amqpApi.uploadMultiMeasurements(measurementsJsonDto);
  }
}
