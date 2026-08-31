import 'package:flutter/material.dart';

class PhoneInfo {
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
