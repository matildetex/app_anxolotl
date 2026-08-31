import 'dart:async';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:flutter/material.dart';

class AnxolotlLocalizationsDelegate
    extends LocalizationsDelegate<AnxolotlLocalizations> {
  static const List<Locale> SUPPORTED_LOCALES = [
    Locale.fromSubtags(languageCode: 'en'),
    Locale.fromSubtags(languageCode: 'pt'),
  ];
  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AnxolotlLocalizations> load(Locale locale) =>
      AnxolotlLocalizations.load(locale);
  @override
  bool shouldReload(LocalizationsDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in SUPPORTED_LOCALES) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
