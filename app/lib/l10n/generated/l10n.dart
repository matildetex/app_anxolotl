// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AnxolotlLocalizations {
  AnxolotlLocalizations();

  static AnxolotlLocalizations? _current;

  static AnxolotlLocalizations get current {
    assert(_current != null,
        'No instance of AnxolotlLocalizations was loaded. Try to initialize the AnxolotlLocalizations delegate before accessing AnxolotlLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AnxolotlLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AnxolotlLocalizations();
      AnxolotlLocalizations._current = instance;

      return instance;
    });
  }

  static AnxolotlLocalizations of(BuildContext context) {
    final instance = AnxolotlLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AnxolotlLocalizations present in the widget tree. Did you add AnxolotlLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AnxolotlLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AnxolotlLocalizations>(
        context, AnxolotlLocalizations);
  }

  /// `Home`
  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: 'Home page title',
      args: [],
    );
  }

  /// `Well-being`
  String get wellBeingTitle {
    return Intl.message(
      'Well-being',
      name: 'wellBeingTitle',
      desc: 'Well-being page title',
      args: [],
    );
  }

  /// `Events`
  String get eventsTitle {
    return Intl.message(
      'Events',
      name: 'eventsTitle',
      desc: 'Events page title',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message(
      'Profile',
      name: 'profileTitle',
      desc: 'Profile page title',
      args: [],
    );
  }

  /// `Exercises`
  String get exercises {
    return Intl.message(
      'Exercises',
      name: 'exercises',
      desc: 'Exercises subtitle',
      args: [],
    );
  }

  /// `Stress Breathing Guidance`
  String get stressBreathingGuidance {
    return Intl.message(
      'Stress Breathing Guidance',
      name: 'stressBreathingGuidance',
      desc: 'Stress Breathing Guidance',
      args: [],
    );
  }

  /// `Anxiety Breathing Guidance`
  String get anxietyBreathingGuidance {
    return Intl.message(
      'Anxiety Breathing Guidance',
      name: 'anxietyBreathingGuidance',
      desc: 'Anxiety Breathing Guidance',
      args: [],
    );
  }

  /// `Panic Breathing Guidance`
  String get panicBreathingGuidance {
    return Intl.message(
      'Panic Breathing Guidance',
      name: 'panicBreathingGuidance',
      desc: 'Panic Breathing Guidance',
      args: [],
    );
  }

  /// `{howMany,plural, =0{Instant}=1{{minutes} Minute}other{{minutes} Minutes}}`
  String minutes(num howMany, Object minutes) {
    return Intl.plural(
      howMany,
      zero: 'Instant',
      one: '$minutes Minute',
      other: '$minutes Minutes',
      name: 'minutes',
      desc: 'Minute counter',
      args: [howMany, minutes],
    );
  }

  /// `Mindfulness`
  String get mindfulness {
    return Intl.message(
      'Mindfulness',
      name: 'mindfulness',
      desc: 'Mindfulness title',
      args: [],
    );
  }

  /// `Mindfulness Exercise`
  String get mindfulnessExercise {
    return Intl.message(
      'Mindfulness Exercise',
      name: 'mindfulnessExercise',
      desc: 'Mindfulness Exercise',
      args: [],
    );
  }

  /// `Take deep breaths`
  String get deepBreaths {
    return Intl.message(
      'Take deep breaths',
      name: 'deepBreaths',
      desc: 'Describing the user to breath deep',
      args: [],
    );
  }

  /// `Inhale`
  String get inhale {
    return Intl.message(
      'Inhale',
      name: 'inhale',
      desc: 'Describing the user to inhale',
      args: [],
    );
  }

  /// `Hold the breath`
  String get holdBreath {
    return Intl.message(
      'Hold the breath',
      name: 'holdBreath',
      desc: 'Describing the user to hold the breath',
      args: [],
    );
  }

  /// `Exhale`
  String get exhale {
    return Intl.message(
      'Exhale',
      name: 'exhale',
      desc: 'Describing the user to exhale',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: 'Starting anything',
      args: [],
    );
  }

  /// `Congratulations`
  String get congratulations {
    return Intl.message(
      'Congratulations',
      name: 'congratulations',
      desc: 'Congratulations expression',
      args: [],
    );
  }

  /// `Continue`
  String get continueExp {
    return Intl.message(
      'Continue',
      name: 'continueExp',
      desc: 'Continue expression for buttons',
      args: [],
    );
  }

  /// `You have completed {breathCount} breath cycles`
  String breathingExerciseComplete(Object breathCount) {
    return Intl.message(
      'You have completed $breathCount breath cycles',
      name: 'breathingExerciseComplete',
      desc: 'Continue expression for buttons',
      args: [breathCount],
    );
  }

  /// `You took {minutesDuration} minutes to take care of your mental wellbeing`
  String mindfulnessExerciseComplete(Object minutesDuration) {
    return Intl.message(
      'You took $minutesDuration minutes to take care of your mental wellbeing',
      name: 'mindfulnessExerciseComplete',
      desc: 'Continue expression for buttons',
      args: [minutesDuration],
    );
  }

  /// `Brief mindfulness practice`
  String get briefMindfulnessExerciseName {
    return Intl.message(
      'Brief mindfulness practice',
      name: 'briefMindfulnessExerciseName',
      desc: 'The name of the brief mindfullness exercise (Audio in English)',
      args: [],
    );
  }

  /// `Mountain Meditation`
  String get mountainMeditationExerciseName {
    return Intl.message(
      'Mountain Meditation',
      name: 'mountainMeditationExerciseName',
      desc: 'The name of the Mountain Meditation exercise (Audio in English)',
      args: [],
    );
  }

  /// `Hey there,\nwelcome back`
  String get openingGreeting {
    return Intl.message(
      'Hey there,\nwelcome back',
      name: 'openingGreeting',
      desc: 'The greeting when a user enters the app',
      args: [],
    );
  }

  /// `Login to your account to continue`
  String get loginWarning {
    return Intl.message(
      'Login to your account to continue',
      name: 'loginWarning',
      desc: 'Warning the user a login is needed to proceed',
      args: [],
    );
  }

  /// `Log in with {authProvider}`
  String logInMessage(Object authProvider) {
    return Intl.message(
      'Log in with $authProvider',
      name: 'logInMessage',
      desc: 'Message for log in button in a way',
      args: [authProvider],
    );
  }

  /// `Log out`
  String get logOutMessage {
    return Intl.message(
      'Log out',
      name: 'logOutMessage',
      desc: 'Log out expression',
      args: [],
    );
  }

  /// `By continuing, you agree to the Terms of Service`
  String get termsOfServiceMessage {
    return Intl.message(
      'By continuing, you agree to the Terms of Service',
      name: 'termsOfServiceMessage',
      desc: 'Message saying the user agrees to the terms of service',
      args: [],
    );
  }

  /// `Log In Failed`
  String get failedLogIn {
    return Intl.message(
      'Log In Failed',
      name: 'failedLogIn',
      desc: 'Message warning that the log in process failed',
      args: [],
    );
  }

  /// `Sign Out Failed`
  String get failedLogOut {
    return Intl.message(
      'Sign Out Failed',
      name: 'failedLogOut',
      desc: 'Message warning that the log out process failed',
      args: [],
    );
  }

  /// `Warning`
  String get warningExp {
    return Intl.message(
      'Warning',
      name: 'warningExp',
      desc: 'Expression to warn',
      args: [],
    );
  }

  /// `A new browser window might appear, in that case, wait for it to load and then close it to proceed. The log out will be fulfilled by then`
  String get logOutWarning {
    return Intl.message(
      'A new browser window might appear, in that case, wait for it to load and then close it to proceed. The log out will be fulfilled by then',
      name: 'logOutWarning',
      desc: 'Disclosing the log out process',
      args: [],
    );
  }

  /// `Please insert a value`
  String get pleaseInsertValue {
    return Intl.message(
      'Please insert a value',
      name: 'pleaseInsertValue',
      desc: 'Asking user to add a value into a textField',
      args: [],
    );
  }

  /// `About you`
  String get aboutYou {
    return Intl.message(
      'About you',
      name: 'aboutYou',
      desc: 'The section about a user data',
      args: [],
    );
  }

  /// `Birthday`
  String get birthdayWord {
    return Intl.message(
      'Birthday',
      name: 'birthdayWord',
      desc: 'Birthday word',
      args: [],
    );
  }

  /// `Gender`
  String get genderWord {
    return Intl.message(
      'Gender',
      name: 'genderWord',
      desc: 'Gender word',
      args: [],
    );
  }

  /// `Weight`
  String get weightWord {
    return Intl.message(
      'Weight',
      name: 'weightWord',
      desc: 'Weight word',
      args: [],
    );
  }

  /// `Height`
  String get heightWord {
    return Intl.message(
      'Height',
      name: 'heightWord',
      desc: 'Height Word',
      args: [],
    );
  }

  /// `Device`
  String get deviceWord {
    return Intl.message(
      'Device',
      name: 'deviceWord',
      desc: 'Device word',
      args: [],
    );
  }

  /// `Select your {fillerWord}`
  String selectYourExp(Object fillerWord) {
    return Intl.message(
      'Select your $fillerWord',
      name: 'selectYourExp',
      desc: 'The expression to select something',
      args: [fillerWord],
    );
  }

  /// `Connect to a new device`
  String get connectNewDevice {
    return Intl.message(
      'Connect to a new device',
      name: 'connectNewDevice',
      desc: 'Expression to connect to a new device',
      args: [],
    );
  }

  /// `Are you sure you want to disconnect the current device`
  String get disconnectBluetoothDevice {
    return Intl.message(
      'Are you sure you want to disconnect the current device',
      name: 'disconnectBluetoothDevice',
      desc:
          'Explaining the user is about to disconnect the current connected bluetooth device',
      args: [],
    );
  }

  /// `Bluetooth connectivity is off. To be able scan devices, you need to turn Bluetooth on`
  String get bluetoothOffMessage {
    return Intl.message(
      'Bluetooth connectivity is off. To be able scan devices, you need to turn Bluetooth on',
      name: 'bluetoothOffMessage',
      desc:
          'Explaining the user that without turning on bluetooth, it is impossible to scan devices',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelExp {
    return Intl.message(
      'Cancel',
      name: 'cancelExp',
      desc: 'Expression to cancel an action',
      args: [],
    );
  }

  /// `Device Connection`
  String get connectDeviceTitle {
    return Intl.message(
      'Device Connection',
      name: 'connectDeviceTitle',
      desc: 'Device Connection page title',
      args: [],
    );
  }

  /// `Available Devices`
  String get availableDevices {
    return Intl.message(
      'Available Devices',
      name: 'availableDevices',
      desc: 'Devices available for an operation',
      args: [],
    );
  }

  /// `Trying to connect`
  String get tryingConnection {
    return Intl.message(
      'Trying to connect',
      name: 'tryingConnection',
      desc: 'Expression of connection try',
      args: [],
    );
  }

  /// `Error connecting`
  String get connectionError {
    return Intl.message(
      'Error connecting',
      name: 'connectionError',
      desc: 'An error happened while connecting',
      args: [],
    );
  }

  /// `Today`
  String get todayWord {
    return Intl.message(
      'Today',
      name: 'todayWord',
      desc: 'Word for today',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterdayWord {
    return Intl.message(
      'Yesterday',
      name: 'yesterdayWord',
      desc: 'Word for yesterday',
      args: [],
    );
  }

  /// `Anxiety`
  String get anxietyWord {
    return Intl.message(
      'Anxiety',
      name: 'anxietyWord',
      desc: 'Word for anxiety',
      args: [],
    );
  }

  /// `Stress`
  String get stressWord {
    return Intl.message(
      'Stress',
      name: 'stressWord',
      desc: 'Word for stress',
      args: [],
    );
  }

  /// `{levelNumber,plural, =0{☀️ Level {levelNumber}}=1{🌤️ Level {levelNumber}}=2{🌧️ Level {levelNumber}}other{Calculating level}}`
  String mentalLevelTitle(num levelNumber) {
    return Intl.plural(
      levelNumber,
      zero: '☀️ Level $levelNumber',
      one: '🌤️ Level $levelNumber',
      two: '🌧️ Level $levelNumber',
      other: 'Calculating level',
      name: 'mentalLevelTitle',
      desc: 'Only thing that changes are the emojis',
      args: [levelNumber],
    );
  }

  /// `{levelNumber,plural, =0{Enjoy your day}=1{Keep an eye on it}=2{Take some time for yourself}other{Wait some time}}`
  String mentalLevelAdvice(num levelNumber) {
    return Intl.plural(
      levelNumber,
      zero: 'Enjoy your day',
      one: 'Keep an eye on it',
      two: 'Take some time for yourself',
      other: 'Wait some time',
      name: 'mentalLevelAdvice',
      desc: 'Advice for high levels of mental monitoring',
      args: [levelNumber],
    );
  }

  /// `Last {length} days`
  String lastDaysExp(Object length) {
    return Intl.message(
      'Last $length days',
      name: 'lastDaysExp',
      desc: 'Expression for last few days',
      args: [length],
    );
  }

  /// `{hours,plural, =0{During {hours} hours}=1{During {hours} hour}other{During {hours} hours}}`
  String duringHoursExp(num hours) {
    return Intl.plural(
      hours,
      zero: 'During $hours hours',
      one: 'During $hours hour',
      other: 'During $hours hours',
      name: 'duringHoursExp',
      desc: 'Expression for lasting some hours',
      args: [hours],
    );
  }

  /// `Highest level today`
  String get highestLevelTodayExp {
    return Intl.message(
      'Highest level today',
      name: 'highestLevelTodayExp',
      desc: 'Expression for highest level today',
      args: [],
    );
  }

  /// `Male`
  String get maleWord {
    return Intl.message(
      'Male',
      name: 'maleWord',
      desc: 'Expression for male',
      args: [],
    );
  }

  /// `Female`
  String get femaleWord {
    return Intl.message(
      'Female',
      name: 'femaleWord',
      desc: 'Expression for female',
      args: [],
    );
  }

  /// `Other`
  String get otherWord {
    return Intl.message(
      'Other',
      name: 'otherWord',
      desc: 'Word for other',
      args: [],
    );
  }

  /// `Taking measurements`
  String get measuringExp {
    return Intl.message(
      'Taking measurements',
      name: 'measuringExp',
      desc: 'Expression for performing measurements',
      args: [],
    );
  }

  /// `Nothing to worry about, enjoy your day.`
  String get noHealthNotifications {
    return Intl.message(
      'Nothing to worry about, enjoy your day.',
      name: 'noHealthNotifications',
      desc:
          'Expressions stating that the user should not worry, and should have a nice day',
      args: [],
    );
  }

  /// `Your anxiety level is quite good today.`
  String get lowAnxietyLevel {
    return Intl.message(
      'Your anxiety level is quite good today.',
      name: 'lowAnxietyLevel',
      desc:
          'Expressions stating that the user should not worry, and should have a nice day',
      args: [],
    );
  }

  /// `Daily average`
  String get dailyAverageExp {
    return Intl.message(
      'Daily average',
      name: 'dailyAverageExp',
      desc: 'Expression stating the daily average',
      args: [],
    );
  }

  /// `Current level`
  String get currentLevelExp {
    return Intl.message(
      'Current level',
      name: 'currentLevelExp',
      desc: 'Expression stating current level',
      args: [],
    );
  }

  /// `Panic attack detected`
  String get panicDetectedExp {
    return Intl.message(
      'Panic attack detected',
      name: 'panicDetectedExp',
      desc: 'Expression stating a panic attack was detected',
      args: [],
    );
  }

  /// `Our algorithms detected a panic attack happening. You can use our breathing exercises to try and get better.`
  String get panicDetectedExplanation {
    return Intl.message(
      'Our algorithms detected a panic attack happening. You can use our breathing exercises to try and get better.',
      name: 'panicDetectedExplanation',
      desc: 'Explanation for detecting panic attack',
      args: [],
    );
  }

  /// `High anxiety today`
  String get highAnxietyTodayExp {
    return Intl.message(
      'High anxiety today',
      name: 'highAnxietyTodayExp',
      desc: 'Expression stating a high anxiety was detected today',
      args: [],
    );
  }

  /// `After performing some very hard calculations, our algorithms detected that today your anxiety level had an average superior to level 1. Would you like to do some exercises?`
  String get highAnxietyTodayExplanation {
    return Intl.message(
      'After performing some very hard calculations, our algorithms detected that today your anxiety level had an average superior to level 1. Would you like to do some exercises?',
      name: 'highAnxietyTodayExplanation',
      desc: 'Explanation for detecting high anxiety today',
      args: [],
    );
  }

  /// `High anxiety in the last few days`
  String get highAnxietyLastDaysExp {
    return Intl.message(
      'High anxiety in the last few days',
      name: 'highAnxietyLastDaysExp',
      desc:
          'Expression stating a high anxiety was detected in the last few days',
      args: [],
    );
  }

  /// `How where the last few days ? Our algorithms detected a continuous high average anxiety level. Take this chance to take care of yourself.`
  String get highAnxietyLastDaysExplanation {
    return Intl.message(
      'How where the last few days ? Our algorithms detected a continuous high average anxiety level. Take this chance to take care of yourself.',
      name: 'highAnxietyLastDaysExplanation',
      desc: 'Explanation for detecting high anxiety the last few days',
      args: [],
    );
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<AnxolotlLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'messages'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AnxolotlLocalizations> load(Locale locale) =>
      AnxolotlLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
