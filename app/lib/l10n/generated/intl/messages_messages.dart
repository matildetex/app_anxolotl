// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  static String m0(breathCount) =>
      "You have completed ${breathCount} breath cycles";

  static String m1(hours) =>
      "${Intl.plural(hours, zero: 'During ${hours} hours', one: 'During ${hours} hour', other: 'During ${hours} hours')}";

  static String m2(length) => "Last ${length} days";

  static String m3(authProvider) => "Log in with ${authProvider}";

  static String m4(levelNumber) =>
      "${Intl.plural(levelNumber, zero: 'Enjoy your day', one: 'Keep an eye on it', two: 'Take some time for yourself', other: 'Wait some time')}";

  static String m5(levelNumber) =>
      "${Intl.plural(levelNumber, zero: '☀️ Level ${levelNumber}', one: '🌤️ Level ${levelNumber}', two: '🌧️ Level ${levelNumber}', other: 'Calculating level')}";

  static String m6(minutesDuration) =>
      "You took ${minutesDuration} minutes to take care of your mental wellbeing";

  static String m7(howMany, minutes) =>
      "${Intl.plural(howMany, zero: 'Instant', one: '${minutes} Minute', other: '${minutes} Minutes')}";

  static String m8(fillerWord) => "Select your ${fillerWord}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutYou": MessageLookupByLibrary.simpleMessage("About you"),
        "anxietyBreathingGuidance":
            MessageLookupByLibrary.simpleMessage("Anxiety Breathing Guidance"),
        "anxietyWord": MessageLookupByLibrary.simpleMessage("Anxiety"),
        "availableDevices":
            MessageLookupByLibrary.simpleMessage("Available Devices"),
        "birthdayWord": MessageLookupByLibrary.simpleMessage("Birthday"),
        "bluetoothOffMessage": MessageLookupByLibrary.simpleMessage(
            "Bluetooth connectivity is off. To be able scan devices, you need to turn Bluetooth on"),
        "breathingExerciseComplete": m0,
        "briefMindfulnessExerciseName":
            MessageLookupByLibrary.simpleMessage("Brief mindfulness practice"),
        "cancelExp": MessageLookupByLibrary.simpleMessage("Cancel"),
        "congratulations":
            MessageLookupByLibrary.simpleMessage("Congratulations"),
        "connectDeviceTitle":
            MessageLookupByLibrary.simpleMessage("Device Connection"),
        "connectNewDevice":
            MessageLookupByLibrary.simpleMessage("Connect to a device"),
        "connectionError":
            MessageLookupByLibrary.simpleMessage("Error connecting"),
        "continueExp": MessageLookupByLibrary.simpleMessage("Continue"),
        "currentLevelExp":
            MessageLookupByLibrary.simpleMessage("Current level"),
        "dailyAverageExp":
            MessageLookupByLibrary.simpleMessage("Daily average"),
        "deepBreaths":
            MessageLookupByLibrary.simpleMessage("Take deep breaths"),
        "deviceWord": MessageLookupByLibrary.simpleMessage("Device"),
        "disconnectBluetoothDevice": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to disconnect the current device"),
        "duringHoursExp": m1,
        "eventsTitle": MessageLookupByLibrary.simpleMessage("Events"),
        "exercises": MessageLookupByLibrary.simpleMessage("Exercises"),
        "exhale": MessageLookupByLibrary.simpleMessage("Exhale"),
        "failedLogIn": MessageLookupByLibrary.simpleMessage("Log In Failed"),
        "failedLogOut": MessageLookupByLibrary.simpleMessage("Sign Out Failed"),
        "femaleWord": MessageLookupByLibrary.simpleMessage("Female"),
        "genderWord": MessageLookupByLibrary.simpleMessage("Gender"),
        "heightWord": MessageLookupByLibrary.simpleMessage("Height"),
        "highAnxietyLastDaysExp": MessageLookupByLibrary.simpleMessage(
            "High anxiety in the last few days"),
        "highAnxietyLastDaysExplanation": MessageLookupByLibrary.simpleMessage(
            "How where the last few days ? Our algorithms detected a continuous high average anxiety level. Take this chance to take care of yourself."),
        "highAnxietyTodayExp":
            MessageLookupByLibrary.simpleMessage("High anxiety today"),
        "highAnxietyTodayExplanation": MessageLookupByLibrary.simpleMessage(
            "After performing some very hard calculations, our algorithms detected that today your anxiety level had an average superior to level 1. Would you like to do some exercises?"),
        "highestLevelTodayExp":
            MessageLookupByLibrary.simpleMessage("Highest level today"),
        "holdBreath": MessageLookupByLibrary.simpleMessage("Hold the breath"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("Home"),
        "inhale": MessageLookupByLibrary.simpleMessage("Inhale"),
        "lastDaysExp": m2,
        "logInMessage": m3,
        "logOutMessage": MessageLookupByLibrary.simpleMessage("Log out"),
        "logOutWarning": MessageLookupByLibrary.simpleMessage(
            "A new browser window might appear, in that case, wait for it to load and then close it to proceed. The log out will be fulfilled by then"),
        "loginWarning": MessageLookupByLibrary.simpleMessage(
            "Login to your account to continue"),
        "lowAnxietyLevel": MessageLookupByLibrary.simpleMessage(
            "Your anxiety level is quite good today."),
        "maleWord": MessageLookupByLibrary.simpleMessage("Male"),
        "measuringExp":
            MessageLookupByLibrary.simpleMessage("Taking measurements"),
        "mentalLevelAdvice": m4,
        "mentalLevelTitle": m5,
        "mindfulness": MessageLookupByLibrary.simpleMessage("Mindfulness"),
        "mindfulnessExercise":
            MessageLookupByLibrary.simpleMessage("Mindfulness Exercise"),
        "mindfulnessExerciseComplete": m6,
        "minutes": m7,
        "mountainMeditationExerciseName":
            MessageLookupByLibrary.simpleMessage("Mountain Meditation"),
        "noHealthNotifications": MessageLookupByLibrary.simpleMessage(
            "Nothing to worry about, enjoy your day."),
        "openingGreeting":
            MessageLookupByLibrary.simpleMessage("Hey there,\nwelcome back"),
        "otherWord": MessageLookupByLibrary.simpleMessage("Other"),
        "panicBreathingGuidance":
            MessageLookupByLibrary.simpleMessage("Panic Breathing Guidance"),
        "panicDetectedExp":
            MessageLookupByLibrary.simpleMessage("Panic attack detected"),
        "panicDetectedExplanation": MessageLookupByLibrary.simpleMessage(
            "Our algorithms detected a panic attack happening. You can use our breathing exercises to try and get better."),
        "pleaseInsertValue":
            MessageLookupByLibrary.simpleMessage("Please insert a value"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "selectYourExp": m8,
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "stressBreathingGuidance":
            MessageLookupByLibrary.simpleMessage("Stress Breathing Guidance"),
        "stressWord": MessageLookupByLibrary.simpleMessage("Stress"),
        "termsOfServiceMessage": MessageLookupByLibrary.simpleMessage(
            "By continuing, you agree to the Terms of Service"),
        "todayWord": MessageLookupByLibrary.simpleMessage("Today"),
        "tryingConnection":
            MessageLookupByLibrary.simpleMessage("Trying to connect"),
        "warningExp": MessageLookupByLibrary.simpleMessage("Warning"),
        "weightWord": MessageLookupByLibrary.simpleMessage("Weight"),
        "wellBeingTitle": MessageLookupByLibrary.simpleMessage("Well-being"),
        "yesterdayWord": MessageLookupByLibrary.simpleMessage("Yesterday")
      };
}
