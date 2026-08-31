// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
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
  String get localeName => 'pt';

  static String m0(breathCount) =>
      "Completou ${breathCount} ciclos respiratórios";

  static String m1(hours) =>
      "${Intl.plural(hours, zero: 'Durante ${hours} horas', one: 'Durante ${hours} hora', other: 'Durante ${hours} horas')}";

  static String m2(length) => "Últimos ${length} dias";

  static String m3(authProvider) => "Entrar com ${authProvider}";

  static String m4(levelNumber) =>
      "${Intl.plural(levelNumber, zero: 'Aproveita o dia', one: 'Tem atenção ao teu estado', two: 'Tira um tempo para ti', other: 'Espere um pouco')}";

  static String m5(levelNumber) =>
      "${Intl.plural(levelNumber, zero: '☀️ Nível ${levelNumber}', one: '🌤️ Nível ${levelNumber}', two: '🌧️ Nível ${levelNumber}', other: 'A calcular o nível')}";

  static String m6(minutesDuration) =>
      "Tirou ${minutesDuration} minutos para cuidar da saúde mental";

  static String m7(howMany, minutes) =>
      "${Intl.plural(howMany, zero: 'Instantâneo', one: '${minutes} Minuto', other: '${minutes} Minutos')}";

  static String m8(fillerWord) => "Selecione o seu ${fillerWord}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutYou": MessageLookupByLibrary.simpleMessage("Dados Pessoais"),
        "anxietyBreathingGuidance": MessageLookupByLibrary.simpleMessage(
            "Orientação de Respiração para Ansiedade"),
        "anxietyWord": MessageLookupByLibrary.simpleMessage("Ansiedade"),
        "availableDevices":
            MessageLookupByLibrary.simpleMessage("Dispositivos disponíveis"),
        "birthdayWord": MessageLookupByLibrary.simpleMessage("Aniversário"),
        "bluetoothOffMessage": MessageLookupByLibrary.simpleMessage(
            "A conectividade por Bluetooth está desligada. Para poder procurar dispositivos, por falor ligue o Bluetooth"),
        "breathingExerciseComplete": m0,
        "briefMindfulnessExerciseName": MessageLookupByLibrary.simpleMessage(
            "Meditação Breve (Áudio em Inglês)"),
        "cancelExp": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "congratulations": MessageLookupByLibrary.simpleMessage("Parabéns"),
        "connectDeviceTitle":
            MessageLookupByLibrary.simpleMessage("Conexão de dispositivos"),
        "connectNewDevice": MessageLookupByLibrary.simpleMessage(
            "Conectar-se a um novo dispositivo"),
        "connectionError":
            MessageLookupByLibrary.simpleMessage("Erro durante a conexão"),
        "continueExp": MessageLookupByLibrary.simpleMessage("Continuar"),
        "currentLevelExp": MessageLookupByLibrary.simpleMessage("Nível atual"),
        "dailyAverageExp": MessageLookupByLibrary.simpleMessage("Média diária"),
        "deepBreaths":
            MessageLookupByLibrary.simpleMessage("Respire profundamente"),
        "deviceWord": MessageLookupByLibrary.simpleMessage("Dispositivo"),
        "disconnectBluetoothDevice": MessageLookupByLibrary.simpleMessage(
            "Pretende disconectar o dispositivo Bluetooth atualmente ligado?"),
        "duringHoursExp": m1,
        "eventsTitle": MessageLookupByLibrary.simpleMessage("Eventos"),
        "exercises": MessageLookupByLibrary.simpleMessage("Exercícios"),
        "exhale": MessageLookupByLibrary.simpleMessage("Expire"),
        "failedLogIn":
            MessageLookupByLibrary.simpleMessage("A entrada na conta falhou"),
        "failedLogOut":
            MessageLookupByLibrary.simpleMessage("A saída da conta falhou"),
        "femaleWord": MessageLookupByLibrary.simpleMessage("Feminino"),
        "genderWord": MessageLookupByLibrary.simpleMessage("Género"),
        "heightWord": MessageLookupByLibrary.simpleMessage("Altura"),
        "highAnxietyLastDaysExp": MessageLookupByLibrary.simpleMessage(
            "Ansiedade alta nos últimos dias"),
        "highAnxietyLastDaysExplanation": MessageLookupByLibrary.simpleMessage(
            "Como correram os últimos dias ? Os nossos algoritmos detectaram um nível alto de ansiedade nos últimos dias. Usa esta oportunidade para cuidar de ti."),
        "highAnxietyTodayExp":
            MessageLookupByLibrary.simpleMessage("Ansiedade alta hoje"),
        "highAnxietyTodayExplanation": MessageLookupByLibrary.simpleMessage(
            "Após efectuar cálculos complicados, os nossos algoritmos detectaram que o nível médio de ansiedade hoje foi superior a nível 1. Queres fazer algum exercício ?"),
        "highestLevelTodayExp":
            MessageLookupByLibrary.simpleMessage("Nível mais elevado hoje"),
        "holdBreath":
            MessageLookupByLibrary.simpleMessage("Sustenha a respiração"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("Página Inicial"),
        "inhale": MessageLookupByLibrary.simpleMessage("Inspire"),
        "lastDaysExp": m2,
        "logInMessage": m3,
        "logOutMessage": MessageLookupByLibrary.simpleMessage("Sair da conta"),
        "logOutWarning": MessageLookupByLibrary.simpleMessage(
            "Uma nova janela do navegador da Internet poderá aparecer. Nesse caso, espere que carregue e feche para proceder. A saída de conta terá sido concluída."),
        "loginWarning": MessageLookupByLibrary.simpleMessage(
            "Entre na sua conta para continuar"),
        "lowAnxietyLevel": MessageLookupByLibrary.simpleMessage(
            "Os níveis de ansiedade estão bons hoje."),
        "maleWord": MessageLookupByLibrary.simpleMessage("Masculino"),
        "measuringExp": MessageLookupByLibrary.simpleMessage("A tirar medidas"),
        "mentalLevelAdvice": m4,
        "mentalLevelTitle": m5,
        "mindfulness": MessageLookupByLibrary.simpleMessage("Meditação"),
        "mindfulnessExercise":
            MessageLookupByLibrary.simpleMessage("Exercício de Meditação"),
        "mindfulnessExerciseComplete": m6,
        "minutes": m7,
        "mountainMeditationExerciseName": MessageLookupByLibrary.simpleMessage(
            "Meditação da Montanha (Áudio em Inglês)"),
        "noHealthNotifications": MessageLookupByLibrary.simpleMessage(
            "Nada para te preocurares, aproveita o dia."),
        "openingGreeting":
            MessageLookupByLibrary.simpleMessage("Olá,\nBem-vindo de volta"),
        "otherWord": MessageLookupByLibrary.simpleMessage("Outro"),
        "panicBreathingGuidance": MessageLookupByLibrary.simpleMessage(
            "Orientação de Respiração para Pânico"),
        "panicDetectedExp":
            MessageLookupByLibrary.simpleMessage("Ataque de pânico detectado"),
        "panicDetectedExplanation": MessageLookupByLibrary.simpleMessage(
            "Os nossos algoritmos detectaram um ataque de pânico. Podes usar os nossos exercícios para estabilizar."),
        "pleaseInsertValue":
            MessageLookupByLibrary.simpleMessage("Por favor insira um valor"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("Perfil"),
        "selectYourExp": m8,
        "start": MessageLookupByLibrary.simpleMessage("Começar"),
        "stressBreathingGuidance": MessageLookupByLibrary.simpleMessage(
            "Orientação de Respiração para Stress"),
        "stressWord": MessageLookupByLibrary.simpleMessage("Stress"),
        "termsOfServiceMessage": MessageLookupByLibrary.simpleMessage(
            "Ao continuar, está a aceitar os Termos de Serviço"),
        "todayWord": MessageLookupByLibrary.simpleMessage("Hoje"),
        "tryingConnection":
            MessageLookupByLibrary.simpleMessage("A tentar conectar"),
        "warningExp": MessageLookupByLibrary.simpleMessage("Aviso"),
        "weightWord": MessageLookupByLibrary.simpleMessage("Peso"),
        "wellBeingTitle": MessageLookupByLibrary.simpleMessage("Bem-Estar"),
        "yesterdayWord": MessageLookupByLibrary.simpleMessage("Ontem")
      };
}
