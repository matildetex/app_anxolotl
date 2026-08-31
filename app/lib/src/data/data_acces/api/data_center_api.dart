import 'dart:convert';
import 'package:anxolotl_app/src/data/data_acces/dto/api/measurements/measurement_json_dto.dart';
import 'package:http/http.dart' as http;

class DataCenterApi {
  final String endpoint = "ayy8i0qzuf.execute-api.eu-west-1.amazonaws.com";
  final String measurementQueryArgs = "/measurement";
  final String surveyQueryArgs = "/survey";

  Future<http.Response> uploadMeasurement(
      MeasurementJsonDto measurementJsonDto) async {
    //return null as Future<http.Response>;
    return await http.post(Uri.https(endpoint, measurementQueryArgs),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(measurementJsonDto));
  }
}
