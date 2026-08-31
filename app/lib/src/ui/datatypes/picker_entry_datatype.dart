import 'package:anxolotl_app/src/data/services/health_profile/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumberPickerEntryDatatype {
  late ValueInterval<int> valueInterval;
  late int? currValue;
  late final String unit;

  NumberPickerEntryDatatype(this.valueInterval, this.currValue, this.unit);

  @override
  String toString() {
    return currValue != null ? "$currValue $unit" : "";
  }

  List<int> getValues() => List<int>.generate(
      valueInterval.max - valueInterval.min,
      (index) => index += valueInterval.min);
}

class DatePickerEntryDatatype {
  late final ValueInterval<DateTime> _valueInterval;
  late DateTime? currValue;

  DatePickerEntryDatatype(this._valueInterval, this.currValue);

  @override
  String toString() {
    return currValue != null
        ? DateFormat('yyyy-MM-dd').format(currValue!).toString()
        : "";
  }

  DateTime getMaxDate() => _valueInterval.max;
  DateTime getMinDate() => _valueInterval.min;
}

class StringPickerValue {
  final int? code;
  final String name;
  final String Function(BuildContext buildContext) translateName;

  StringPickerValue(
      {required this.name, required this.translateName, this.code});
}

class StringPickerEntryDatatype {
  late List<StringPickerValue> values;
  late StringPickerValue? _currValue;

  StringPickerEntryDatatype(this.values);

  void setCurrValue(int? code) {
    if (code == null) {
      _currValue = null;
    } else {
      _currValue = values.firstWhere((element) => element.code == code);
    }
  }

  int? getCurrValue() => _currValue?.code;

  String getTranslatedString(BuildContext context) {
    return _currValue != null ? _currValue!.translateName(context) : "";
  }

  List<String> getValuesViewStrings(BuildContext context) =>
      values.map((e) => e.translateName(context)).toList();
}
