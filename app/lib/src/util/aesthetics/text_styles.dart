
import 'package:flutter/material.dart';

class TextStyles {
  static TextTheme lightThemeStyle = const TextTheme(
    displayLarge: TextStyle(
        fontSize: 48,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto'),
    //Title
    displayMedium: TextStyle(
        fontSize: 24,
        color: Color.fromRGBO(0x1F, 0x21, 0x28, 0.87),
        fontWeight: FontWeight.w500,
        fontFamily: 'Ubuntu'),
    //SubHeader
    displaySmall: TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(0x1F, 0x21, 0x28, 0.60),
        fontWeight: FontWeight.w300,
        fontFamily: 'Ubuntu'),
    headlineMedium: TextStyle(
        fontSize: 34,
        color: Color.fromRGBO(0x1F, 0x21, 0x28, 0.87),
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto'),
    // Menu
    titleLarge: TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(0x1F, 0x21, 0x28, 0.60),
        fontWeight: FontWeight.w500,
        fontFamily: 'Ubuntu'),
    bodyLarge: TextStyle(
        fontSize: 16,
        color: Color.fromRGBO(0x1F, 0x21, 0x28, 0.87),
        fontWeight: FontWeight.w400,
        fontFamily: 'Ubuntu'),
    labelLarge: TextStyle(
      fontSize: 16,
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.w500,
      fontFamily: 'Ubuntu',
    ),
    bodySmall: TextStyle(
        fontSize: 13,
        color: Color.fromRGBO(0x1F, 0x21, 0x28, 0.60),
        fontWeight: FontWeight.w300,
        fontFamily: 'Ubuntu'),
    //Tiny
    bodyMedium: TextStyle(
        fontSize: 12,
        color: Color.fromRGBO(0x1F, 0x21, 0x28, 0.87),
        fontWeight: FontWeight.w300,
        fontFamily: 'Ubuntu'),
    //Subtitle 2, because subtitle 1 is used by the system in the color black
    titleSmall: TextStyle(
        fontSize: 16,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto'),
  );
}
