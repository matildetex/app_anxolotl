import 'dart:async';
import 'dart:io';
import 'package:anxolotl_app/l10n/generated/intl/messages_all.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations_delegate.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class LocalizationsUtil {
  static AnxolotlLocalizations l10n(BuildContext context) =>
      AnxolotlLocalizations.of(context);

  static Future<AnxolotlLocalizations> l10nContextless() =>
      AnxolotlLocalizations.load(
          Locale(Locale(Platform.localeName).languageCode.split("_")[0]));

  static String dateTimeDayString(DateTime dateTime, BuildContext context) {
    DateTime currentDate = DateTime.now();

    if (currentDate.difference(dateTime).inDays == 0) {
      return LocalizationsUtil.l10n(context).todayWord;
    } else if (currentDate.difference(dateTime).inDays == 1) {
      return LocalizationsUtil.l10n(context).yesterdayWord;
    } else {
      return DateFormat("dd/MM").format(dateTime);
    }
  }

  static String dateFormatString(DateTime dateTime) {
    return DateFormat("dd/MM").format(dateTime);
  }

  static String timeFormatString(DateTime dateTime) {
    return DateFormat("HH:mm:ss").format(dateTime);
  }
}

class AnxolotlLocalizations {
  AnxolotlLocalizations();

  static AnxolotlLocalizations? _current;

  static AnxolotlLocalizations get current {
    assert(_current != null,
        'No instance of AnxolotlLocalizations was loaded. Try to initialize the AnxolotlLocalizations delegate before accessing AnxolotlLocalizations.current.');
    return _current!;
  }

  static final AnxolotlLocalizationsDelegate delegate =
      AnxolotlLocalizationsDelegate();

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
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static AnxolotlLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AnxolotlLocalizations>(
        context, AnxolotlLocalizations);
  }

  /// ******************************************************************
  ///***                   LOCALIZATION MESSAGES                    ****
  ///******************************************************************
  //Update cmd:
  //flutter pub run intl_generator:extract_to_arb --output-dir=lib/l10n/ lib/src/lang/anxolotl_localizations.dart

  String get homeTitle => Intl.message(
        'Home',
        name: 'homeTitle',
        desc: 'Home page title',
      );

  String get wellBeingTitle => Intl.message(
        'Well-being',
        name: 'wellBeingTitle',
        desc: 'Well-being page title',
      );

  String get eventsTitle => Intl.message(
        'Events',
        name: 'eventsTitle',
        desc: 'Events page title',
      );

  String get profileTitle => Intl.message(
        'Profile',
        name: 'profileTitle',
        desc: 'Profile page title',
      );

  String get exercises => Intl.message(
        'Exercises',
        name: 'exercises',
        desc: 'Exercises subtitle',
      );

  String get stressBreathingGuidance => Intl.message(
        'Stress Breathing Guidance',
        name: 'stressBreathingGuidance',
        desc: 'Stress Breathing Guidance',
      );

  String get anxietyBreathingGuidance => Intl.message(
        'Anxiety Breathing Guidance',
        name: 'anxietyBreathingGuidance',
        desc: 'Anxiety Breathing Guidance',
      );

  String get panicBreathingGuidance => Intl.message(
        'Panic Breathing Guidance',
        name: 'panicBreathingGuidance',
        desc: 'Panic Breathing Guidance',
      );

  String minutes(int howMany, String minutes) => Intl.plural(
        howMany,
        zero: 'Instant',
        one: '$minutes Minute',
        other: '$minutes Minutes',
        args: [howMany, minutes],
        name: 'minutes',
        desc: 'Minute counter',
      );

  String get mindfulness => Intl.message(
        'Mindfulness',
        name: 'mindfulness',
        desc: 'Mindfulness title',
      );

  String get mindfulnessExercise => Intl.message(
        'Mindfulness Exercise',
        name: 'mindfulnessExercise',
        desc: 'Mindfulness Exercise',
      );

  String get deepBreaths => Intl.message(
        'Take deep breaths',
        name: 'deepBreaths',
        desc: 'Describing the user to breath deep',
      );

  String get inhale => Intl.message(
        'Inhale',
        name: 'inhale',
        desc: 'Describing the user to inhale',
      );

  String get holdBreath => Intl.message(
        'Hold the breath',
        name: 'holdBreath',
        desc: 'Describing the user to hold the breath',
      );

  String get exhale => Intl.message(
        'Exhale',
        name: 'exhale',
        desc: 'Describing the user to exhale',
      );

  String get start => Intl.message(
        'Start',
        name: 'start',
        desc: 'Starting anything',
      );

  String get congratulations => Intl.message(
        'Congratulations',
        name: 'congratulations',
        desc: 'Congratulations expression',
      );

  String get continueExp => Intl.message(
        'Continue',
        name: 'continueExp',
        desc: 'Continue expression for buttons',
      );

  String breathingExerciseComplete(String breathCount) => Intl.message(
        'You have completed $breathCount breath cycles',
        args: [breathCount],
        name: 'breathingExerciseComplete',
        desc: 'Continue expression for buttons',
      );

  String mindfulnessExerciseComplete(String minutesDuration) => Intl.message(
        'You took $minutesDuration minutes to take care of your mental wellbeing',
        args: [minutesDuration],
        name: 'mindfulnessExerciseComplete',
        desc: 'Continue expression for buttons',
      );

  String get briefMindfulnessExerciseName => Intl.message(
        'Brief mindfulness practice',
        name: 'briefMindfulnessExerciseName',
        desc: 'The name of the brief mindfullness exercise (Audio in English)',
      );

  String get mountainMeditationExerciseName => Intl.message(
        'Mountain Meditation',
        name: 'mountainMeditationExerciseName',
        desc: 'The name of the Mountain Meditation exercise (Audio in English)',
      );

  String get openingGreeting => Intl.message(
        'Hey there,\nwelcome back',
        name: 'openingGreeting',
        desc: 'The greeting when a user enters the app',
      );

  String get loginWarning => Intl.message(
        "Login to your account to continue",
        name: 'loginWarning',
        desc: 'Warning the user a login is needed to proceed',
      );

  String logInMessage(String authProvider) => Intl.message(
        'Log in with $authProvider',
        args: [authProvider],
        name: 'logInMessage',
        desc: 'Message for log in button in a way',
      );

  String get logOutMessage => Intl.message(
        "Log out",
        name: 'logOutMessage',
        desc: 'Log out expression',
      );

  String get termsOfServiceMessage => Intl.message(
        "By continuing, you agree to the Terms of Service",
        name: 'termsOfServiceMessage',
        desc: 'Message saying the user agrees to the terms of service',
      );

  String get failedLogIn => Intl.message(
        "Log In Failed",
        name: 'failedLogIn',
        desc: 'Message warning that the log in process failed',
      );

  String get failedLogOut => Intl.message(
        "Sign Out Failed",
        name: 'failedLogOut',
        desc: 'Message warning that the log out process failed',
      );

  String get warningExp => Intl.message(
        "Warning",
        name: 'warningExp',
        desc: 'Expression to warn',
      );

  String get logOutWarning => Intl.message(
        "A new browser window might appear, in that case, wait for it to load and then close it to proceed. The log out will be fulfilled by then",
        name: 'logOutWarning',
        desc: 'Disclosing the log out process',
      );

  String get pleaseInsertValue => Intl.message(
        "Please insert a value",
        name: 'pleaseInsertValue',
        desc: 'Asking user to add a value into a textField',
      );

  String get aboutYou => Intl.message(
        "About you",
        name: 'aboutYou',
        desc: 'The section about a user data',
      );

  String get birthdayWord => Intl.message(
        "Birthday",
        name: 'birthdayWord',
        desc: 'Birthday word',
      );

  String get genderWord => Intl.message(
        "Gender",
        name: 'genderWord',
        desc: 'Gender word',
      );

  String get weightWord => Intl.message(
        "Weight",
        name: 'weightWord',
        desc: 'Weight word',
      );

  String get heightWord => Intl.message(
        "Height",
        name: 'heightWord',
        desc: 'Height Word',
      );

  String get deviceWord => Intl.message(
        "Device",
        name: 'deviceWord',
        desc: 'Device word',
      );

  String selectYourExp(String fillerWord) => Intl.message(
        'Select your $fillerWord',
        args: [fillerWord],
        name: 'selectYourExp',
        desc: 'The expression to select something',
      );

  String get connectNewDevice => Intl.message(
        "Connect to a device",
        name: 'connectNewDevice',
        desc: 'Expression to connect to a new device',
      );

  String get disconnectBluetoothDevice => Intl.message(
        "Are you sure you want to disconnect the current device",
        name: 'disconnectBluetoothDevice',
        desc:
            'Explaining the user is about to disconnect the current connected bluetooth device',
      );

  String get bluetoothOffMessage => Intl.message(
        "Bluetooth connectivity is off. To be able scan devices, you need to turn Bluetooth on",
        name: 'bluetoothOffMessage',
        desc:
            'Explaining the user that without turning on bluetooth, it is impossible to scan devices',
      );

  String get cancelExp => Intl.message(
        "Cancel",
        name: 'cancelExp',
        desc: 'Expression to cancel an action',
      );

  get connectDeviceTitle => Intl.message(
        "Device Connection",
        name: 'connectDeviceTitle',
        desc: 'Device Connection page title',
      );

  String get availableDevices => Intl.message(
        "Available Devices",
        name: 'availableDevices',
        desc: 'Devices available for an operation',
      );

  String get tryingConnection => Intl.message(
        "Trying to connect",
        name: 'tryingConnection',
        desc: 'Expression of connection try',
      );

  String get connectionError => Intl.message(
        "Error connecting",
        name: 'connectionError',
        desc: 'An error happened while connecting',
      );

  String get todayWord => Intl.message(
        "Today",
        name: 'todayWord',
        desc: 'Word for today',
      );

  String get yesterdayWord => Intl.message(
        "Yesterday",
        name: 'yesterdayWord',
        desc: 'Word for yesterday',
      );

  String get anxietyWord => Intl.message(
        "Anxiety",
        name: 'anxietyWord',
        desc: 'Word for anxiety',
      );

  String get stressWord => Intl.message(
        "Stress",
        name: 'stressWord',
        desc: 'Word for stress',
      );

  String get panicAttackWord => Intl.message(
        "Panic Attacks",
        name: 'panicAttackWord',
        desc: 'Word for panic attacks',
      );

  String mentalLevelTitle(int levelNumber) => Intl.plural(levelNumber,
      zero: '☀️ Level $levelNumber',
      one: '🌤️ Level $levelNumber',
      two: '🌧️ Level $levelNumber',
      other: "Calculating level",
      args: [levelNumber],
      name: 'mentalLevelTitle',
      desc: 'Only thing that changes are the emojis');

  String mentalLevelAdvice(int levelNumber) => Intl.plural(levelNumber,
      zero: 'Enjoy your day',
      one: 'Keep an eye on it',
      two: 'Take some time for yourself',
      other: "Wait some time",
      args: [levelNumber],
      name: 'mentalLevelAdvice',
      desc: 'Advice for high levels of mental monitoring');

  String lastDaysExp(int length) => Intl.message(
        'Last $length days',
        args: [length],
        name: 'lastDaysExp',
        desc: 'Expression for last few days',
      );

  String duringHoursExp(int hours) => Intl.plural(
        hours,
        zero: 'During $hours hours',
        one: 'During $hours hour',
        other: 'During $hours hours',
        args: [hours],
        name: 'duringHoursExp',
        desc: 'Expression for lasting some hours',
      );

  String get highestLevelTodayExp => Intl.message(
        "Highest level today",
        name: 'highestLevelTodayExp',
        desc: 'Expression for highest level today',
      );

  String get maleWord => Intl.message(
        "Male",
        name: 'maleWord',
        desc: 'Expression for male',
      );

  String get femaleWord => Intl.message(
        "Female",
        name: 'femaleWord',
        desc: 'Expression for female',
      );

  String get otherWord => Intl.message(
        "Other",
        name: 'otherWord',
        desc: 'Word for other',
      );

  String get measuringExp => Intl.message(
        "Taking measurements",
        name: 'measuringExp',
        desc: 'Expression for performing measurements',
      );

  String get preparingMeasure => Intl.message(
        "Preparing to measure",
        name: 'preparingMeasure',
        desc: 'Expression for preparing to take measurements',
      );

  String get lastMeasurement => Intl.message(
        "Last measurement performed at ",
        name: 'lastMeasurement',
        desc: 'Expression to perform a measurement',
      );

  String get syncingExpression => Intl.message(
        "Synchronization to the cloud finished",
        name: 'syncingExpression',
        desc: 'Expression to perform a synchronization',
      );

  String get connectDeviceNotPossible => Intl.message(
        "It was not possible to connect with the device",
        name: 'connectDeviceNotPossible',
        desc:
            'Indicating that it was not possible to establish a connection with a device',
      );

  String get errorWord => Intl.message(
        "Error",
        name: 'errorWord',
        desc: 'Error word',
      );

  String get successWord => Intl.message(
        "Success",
        name: 'successWord',
        desc: 'Success word',
      );

  String get notConnectedToTheInternet => Intl.message(
        "Not connected to the internet",
        name: 'notConnectedToTheInternet',
        desc: 'Warning user that they are not connected to the internet',
      );

  String get syncWord => Intl.message(
        "Synchronization",
        name: 'syncWord',
        desc: 'Synchronization word',
      );

  String get measureWord => Intl.message(
        "Measurement",
        name: 'measureWord',
        desc: 'Measurement word',
      );

  String get noHealthNotifications => Intl.message(
        "Nothing to worry about, enjoy your day.",
        name: 'noHealthNotifications',
        desc:
            'Expressions stating that the user should not worry, and should have a nice day',
      );

  String get lowAnxietyLevel => Intl.message(
        "Your anxiety level is quite good today.",
        name: 'lowAnxietyLevel',
        desc:
            'Expressions stating that the user should not worry, and should have a nice day',
      );

  String get dailyAverageExp => Intl.message(
        "Daily average",
        name: 'dailyAverageExp',
        desc: 'Expression stating the daily average',
      );

  String get currentLevelExp => Intl.message(
        "Current level",
        name: 'currentLevelExp',
        desc: 'Expression stating current level',
      );

  String get panicDetectedExp => Intl.message(
        "Panic attack detected",
        name: 'panicDetectedExp',
        desc: 'Expression stating a panic attack was detected',
      );

  get panicDetectedExplanation => Intl.message(
        "Our algorithms detected a panic attack happening. You can use our breathing exercises to try and get better.",
        name: 'panicDetectedExplanation',
        desc: 'Explanation for detecting panic attack',
      );

  get highAnxietyTodayExp => Intl.message(
        "High anxiety today",
        name: 'highAnxietyTodayExp',
        desc: 'Expression stating a high anxiety was detected today',
      );

  get highAnxietyTodayExplanation => Intl.message(
        'After performing some very hard calculations, our algorithms detected that today your anxiety level '
        'had an average superior to level 1. Would you like to do some exercises?',
        name: 'highAnxietyTodayExplanation',
        desc: 'Explanation for detecting high anxiety today',
      );

  get highAnxietyLastDaysExp => Intl.message(
        "High anxiety in the last few days",
        name: 'highAnxietyLastDaysExp',
        desc:
            'Expression stating a high anxiety was detected in the last few days',
      );

  get highAnxietyLastDaysExplanation => Intl.message(
        'How where the last few days ? Our algorithms detected a continuous high average anxiety level. Take this chance to take care of yourself.',
        name: 'highAnxietyLastDaysExplanation',
        desc: 'Explanation for detecting high anxiety the last few days',
      );

  get wellbeingExercisesExp => Intl.message(
        'Wellbeing Exercises',
        name: 'wellbeingExercisesExp',
        desc: 'Expression for wellbeing exercises',
      );
}
