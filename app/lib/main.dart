import 'dart:io';

import 'package:anxolotl_app/globals/app_routes.dart';
import 'package:anxolotl_app/src/data/data_acces/api/amqp/amqp_api.dart';
import 'package:anxolotl_app/src/data/data_acces/database/object_box_db.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/health_results_repository.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/implementation/user_info_repository.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/secure_storage_repository.dart';
import 'package:anxolotl_app/src/data/data_acces/repositories/shared_preferences_repository.dart';
import 'package:anxolotl_app/src/data/services/authentication/authentication_service.dart';
import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_service.dart';
import 'package:anxolotl_app/src/data/services/device/device_service.dart';
import 'package:anxolotl_app/src/data/services/foreground_operations/foreground_operations_service.dart';
import 'package:anxolotl_app/src/data/services/health_labels/health_event_service.dart';
import 'package:anxolotl_app/src/data/services/health_labels/health_label_service.dart';
import 'package:anxolotl_app/src/data/services/health_profile/health_profile_service.dart';
import 'package:anxolotl_app/src/data/services/wellbeing_exercises/exercises_service.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations_delegate.dart';
import 'package:anxolotl_app/src/ui/view/auth_page/log_in_page.dart';
import 'package:anxolotl_app/src/ui/view/landing/landing_page.dart';
import 'package:anxolotl_app/src/ui/viewmodels/anxiety_data_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/authentication_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/bluetooth_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/breathing_exercise_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/health_events_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/health_profile_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/meditation_exercise_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

import 'src/ui/viewmodels/panic_data_vm.dart';
import 'package:anxolotl_app/src/data/services/health/watch_streaming_service.dart';
import 'package:anxolotl_app/src/ui/viewmodels/watch_vm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  if (Platform.isIOS) {
    AudioPlayer.global.setAudioContext(const AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: [AVAudioSessionOptions.mixWithOthers],
      ),
    ));
  }

  await dotenv.load();

  final String dbPath =
      await getApplicationSupportDirectory().then((value) => value.path);
  await ObjectBoxDb().init();

  /*constraints: WorkManagerConstraintConfig(
      requiresCharging: true,
      networkType: NetworkType.connected,
    ),*/

  final AmqpApi amqpApi = AmqpApi();
  await amqpApi.initClient(dotenv.env["RABBITMQ_HOST_ADDRESS"] ?? "localhost",
      dotenv.env["RABBITMQ_HOST_PORT"] ?? "5671");

  final WellbeingExercisesService wellbeingExercisesService =
      WellbeingExercisesService();
  final SharedPreferencesRepository sharedPreferencesRepo =
      SharedPreferencesRepository(await SharedPreferences.getInstance());
  final SecureStorageRepository secureStorageRepo =
      SecureStorageRepository(const FlutterSecureStorage());
  final UserInfoRepository userInfoRepo = UserInfoRepository(amqpApi);
  final HealthResultsRepository healthResultsRepository =
      HealthResultsRepository(amqpApi);

  final AuthenticationService authenticationService =
      AuthenticationService(secureStorageRepo);
  final HealthProfileService healthProfileService =
      HealthProfileService(secureStorageRepo, userInfoRepo);
  final BluetoothService bluetoothService = BluetoothService();
  final HealthResultLabelService healthResultLabelService =
      HealthResultLabelService(healthResultsRepository);
  final DeviceService deviceService =
      DeviceService(sharedPreferencesRepo, userInfoRepo);

  final WatchStreamingService watchService = WatchStreamingService();

  if (Platform.isIOS) {
    await watchService.init(); 
  }

  await _requestInitialPermissions(bluetoothService, deviceService);

  AudioPlayer.global.setAudioContext(const AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: [AVAudioSessionOptions.mixWithOthers],
    ),
  ));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(
        value: await AuthenticationViewModel(authenticationService).init()),
    ChangeNotifierProvider.value(
        value: AnxietyDataViewModel(
            healthResultLabelService, authenticationService)),
    ChangeNotifierProvider.value(
        value: PanicDataViewModel(
            healthResultLabelService, authenticationService)),
    ChangeNotifierProvider.value(
        value: HealthEventsViewModel(
            await HealthEventService(healthResultsRepository).init(),
            authenticationService)),
    ChangeNotifierProvider(
        create: (_) => WatchViewModel(watchService),),
    ChangeNotifierProvider.value(
        value: BreathingExerciseViewModel(wellbeingExercisesService)),
    ChangeNotifierProvider.value(
        value: MeditationExerciseViewModel(wellbeingExercisesService)),
    ChangeNotifierProvider.value(
        value: HealthProfileViewModel(
            healthProfileService, authenticationService)),
    Provider<WatchStreamingService>.value(value: watchService),
    ChangeNotifierProvider.value(
        value: BluetoothViewModel(
      bluetoothService,
      authenticationService,
      deviceService,
      await ForegroundOperationsService(secureStorageRepo).init(),
    )),
  ], child: const AppImplementation()));

  await bluetoothService
      .askForBluetoothPermissions()
      .then((value) async => await deviceService.askForPermissions());
}

Future<void> _requestInitialPermissions(BluetoothService bt, DeviceService ds) async {
  List<Permission> permissions = [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse,
  ];
  if (Platform.isIOS) {
    permissions.add(Permission.sensors);
  }
  Map<Permission, PermissionStatus> statuses = await permissions.request();
  print("Permissões obtidas: $statuses");

  await bt.askForBluetoothPermissions();
  await ds.askForPermissions();
}

class AppImplementation extends StatefulWidget {
  const AppImplementation({super.key});

  @override
  State<AppImplementation> createState() => _AppImplementationState();
}

class _AppImplementationState extends State<AppImplementation> {
  late Locale _locale;
  String initialRoute = Routes.LOGIN_PAGE;

  @override
  void initState() {
    super.initState();
    //TO retrieve only the acronym for language and ignore the country
    //_locale = Locale( Locale.fromSubtags(languageCode: "pt").languageCode.split("_")[0]);//Test Portuguese
    _locale = Locale(Locale(Platform.localeName).languageCode.split("_")[0]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthenticationViewModel authenticationVM =
        Provider.of<AuthenticationViewModel>(context);

    return ThemeProvider(
      // saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              SchedulerBinding.instance.window.platformBrightness;
          controller.setTheme(LightTheme.theme.id);
          controller.forgetSavedTheme();
          //if (platformBrightness == Brightness.dark) controller.setTheme(LightTheme.theme.id);
          //else controller.setTheme(LightTheme.theme.id+"2");
        }
      },
      themes: <AppTheme>[
        LightTheme.theme,
        DarkTheme.theme,
      ],
      child: ThemeConsumer(
        child: Builder(
            builder: (BuildContext context) => MaterialApp(
                  title: APP_NAME,
                  localizationsDelegates: [
                    AnxolotlLocalizationsDelegate(),
                    ...GlobalMaterialLocalizations.delegates,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  locale: _locale,
                  supportedLocales:
                      AnxolotlLocalizationsDelegate.SUPPORTED_LOCALES,
                  theme: ThemeProvider.themeOf(context).data,
                  initialRoute: authenticationVM.isUserLoggedIn()
                      ? Routes.LANDING_PAGE
                      : Routes.LOGIN_PAGE,
                  routes: {
                    Routes.LANDING_PAGE: (context) => const LandingPage(),
                    Routes.LOGIN_PAGE: (context) => const LogInPage(),
                  },
                )),
      ),
    );
  }
}
