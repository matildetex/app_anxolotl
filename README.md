# Anxolotl — App Móvel

Continuação do projeto Anxolotl, focada na aplicação móvel: recolha de sinais
fisiológicos através de um **Apple Watch** para deteção de **stress** como
*proxy* de **ansiedade**.

> Trabalho adaptado da tese de mestrado de Nuno Gomes (projeto Anxolotl), com a
> app original de monitorização reaproveitada para recolha de dados — ver §1.1.
> Para citação, ver [CITATION.cff](CITATION.cff).

---

## 1. Objetivo

A app recolhe, em tempo real e a partir do Apple Watch do utilizador, um
conjunto de sinais fisiológicos e de movimento (frequência cardíaca,
acelerometria tri-axial, passos, calorias, distância), grava-os localmente em
sessões CSV e permite exportá-los para posterior análise offline.

O objetivo científico é usar estes sinais como entrada para deteção de
**episódios de stress**, tratados como *proxy* mensurável de **ansiedade** — a
ansiedade em si não é diretamente observável por sensores de pulso.

Para além da recolha, a app inclui a componente de acompanhamento do projeto
Anxolotl original: registo e visualização de níveis de ansiedade e de ataques de
pânico, exercícios de respiração e de meditação, e sincronização com um
*data center* via AMQP. Esta funcionalidade não foi utilizada durante a recolha de dados conduzida com esta versão da app, embora o código continue funcional.

### 1.1. Origem e reaproveitamento (*repurposing*)

Este repositório é um **trabalho adaptado da tese de mestrado de Nuno Gomes**
sobre o projeto Anxolotl. A app original foi concebida como uma app de
**monitorização** de ansiedade — registo de eventos, ataques de pânico,
exercícios de bem-estar e acompanhamento longitudinal do utilizador, sem
recolha de sinais fisiológicos em bruto.

Para este trabalho, a app foi **reaproveitada** ("*repurposed*"): em vez de se
limitar a monitorizar, ganhou uma componente de **recolha de dados** —
o watch app nativo (`HealthManager.swift`), o `WatchStreamingService` e o
card de recolha em `home_fragment.dart` foram todos adicionados sobre a base
de monitorização já existente. Esta versão de recolha **foi de facto utilizada
para efetuar uma recolha de dados** — as sessões CSV descritas em
[DATA.md](DATA.md) são o produto direto dessa recolha.

Por a app de monitorização original continuar a ser um artefacto relevante
(nomeadamente para reprodutibilidade da tese), o código das duas versões
coexiste no mesmo repositório: ver §3.1 (toolchain do CI) e §4.1 (flag de
recolha) para como cada versão é obtida.

> **Nota importante sobre o sinal IBI.** O IBI exportado **não é uma série
> beat-to-beat genuína**. É derivado aritmeticamente da frequência cardíaca
> (`IBI_ms = 60000 / HR_bpm`), pelo que constitui *pseudo-variabilidade*. Ver
> [DATA.md](DATA.md) para a discussão completa e para as implicações na análise
> de HRV.

---

## 2. Stack

| Camada | Tecnologia |
|---|---|
| App móvel (iPhone) | Flutter / Dart |
| App do relógio | SwiftUI nativo (watchOS), target Xcode separado |
| Aquisição de sinais | HealthKit (`HKWorkoutSession` + `HKLiveWorkoutBuilder`) e Core Motion (`CMMotionManager`) |
| Ponte Watch ↔ iPhone | `WatchConnectivity` (`WCSession`) |
| Ponte nativo ↔ Flutter | Plugin `flutter_watch_os_connectivity` (Method Channels) |
| Persistência local | ObjectBox, `shared_preferences`, `flutter_secure_storage`, ficheiros CSV |
| Backend | AMQP (`dart_amqp`) sobre TLS |
| Autenticação | Auth0 + Google Sign-In |
| Segundo dispositivo (legado) | Pulseira BLE H-Band via `flutter_blue_plus` |

### 2.1. Como é feita a ponte entre o Flutter e o Apple Watch

Não existe nenhum `MethodChannel` escrito à mão neste repositório —
[app/ios/Runner/AppDelegate.swift](app/ios/Runner/AppDelegate.swift) apenas
regista os plugins gerados. A ponte é feita em **três saltos**:

```
┌──────────────────────────── Apple Watch (watchOS) ────────────────────────────┐
│                                                                               │
│  ContentView.onAppear                                                         │
│      └─> HealthManager.requestPermissions()   (HealthKit authorization)       │
│      └─> HealthManager.startStreaming()                                       │
│              ├─ startWorkoutSession()                                         │
│              │     HKWorkoutSession + HKLiveWorkoutBuilder                    │
│              │     delegate: workoutBuilder(_:didCollectDataOf:)              │
│              │        -> hr, ibi, steps, calories, distance                   │
│              └─ startAccelerometer()                                          │
│                    CMMotionManager @ 1/25 s -> lotes de 5 amostras            │
│                       -> {"acc_batch": [ {x,y,z,t}, ... ]}                    │
│                                                                               │
│  sendToPhone(data:)                                                           │
│      └─> WCSession.sendMessage(...)              [se isReachable]             │
│      └─> WCSession.updateApplicationContext(...) [fallback — ver §2.2]        │
└───────────────────────────────────┬───────────────────────────────────────────┘
                                    │  WatchConnectivity (framework Apple)
┌───────────────────────────────────▼───────────────────────────────────────────┐
│                            iPhone — lado nativo (iOS)                         │
│                                                                               │
│  SwiftFlutterWatchOsConnectivityPlugin : WCSessionDelegate                     │
│      (do package flutter_watch_os_connectivity, registado automaticamente      │
│       pelo GeneratedPluginRegistrant)                                          │
│                                                                               │
│      session(_:didReceiveMessage:)                                            │
│          └─> callbackChannel.invokeMethod("messageReceived", arguments: ...)   │
│                                                                               │
│      MethodChannels:                                                          │
│          "sstonn/flutter_watch_os_connectivity"           (Dart -> nativo)     │
│          "sstonn/flutter_watch_os_connectivity_callback"  (nativo -> Dart)     │
└───────────────────────────────────┬───────────────────────────────────────────┘
                                    │  Flutter Method Channel
┌───────────────────────────────────▼───────────────────────────────────────────┐
│                            iPhone — lado Dart (Flutter)                       │
│                                                                               │
│  WatchStreamingService.init()                                                 │
│      _connectivity.configureAndActivateSession()                              │
│      _connectivity.messageReceived.listen((message) { ... })                   │
│          ├─ se contém "acc_batch" -> N x WatchData (só acc_x/y/z)             │
│          └─ caso contrário        -> 1 x WatchData (hr/ibi/steps/...)         │
│      -> StreamController<WatchData> (broadcast)                               │
│                                                                               │
│  WatchViewModel (ChangeNotifier, injetado por provider)                        │
│  HomeFragment / _DataCollectionCard  -> botão START/STOP                       │
└───────────────────────────────────────────────────────────────────────────────┘
```

**Canal de retorno (iPhone → Watch).** Quando o utilizador carrega em START/STOP,
`WatchStreamingService.sendRecordingState(bool)` envia
`{'recording': true|false}` para o relógio. Do lado do watchOS,
`HealthManager.session(_:didReceiveMessage:)` atualiza apenas a propriedade
`@Published isRecording`, que controla o ponto verde/amarelo no ecrã do relógio.
**Não inicia nem pára a aquisição** — o relógio transmite continuamente desde que
o `ContentView` aparece. O que o botão START/STOP controla é exclusivamente se o
lado Flutter escreve as amostras recebidas no `_sessionBuffer`.

Ficheiros relevantes:

- [app/ios/Runner Watch Kit App Watch App/HealthManager.swift](app/ios/Runner%20Watch%20Kit%20App%20Watch%20App/HealthManager.swift) — aquisição e envio
- [app/ios/Runner Watch Kit App Watch App/ContentView.swift](app/ios/Runner%20Watch%20Kit%20App%20Watch%20App/ContentView.swift) — UI do relógio e arranque do streaming
- [app/lib/src/data/services/health/watch_streaming_service.dart](app/lib/src/data/services/health/watch_streaming_service.dart) — receção, buffer e exportação CSV
- [app/lib/src/ui/viewmodels/watch_vm.dart](app/lib/src/ui/viewmodels/watch_vm.dart) — estado de UI
- [app/lib/src/ui/view/landing/home_fragment.dart](app/lib/src/ui/view/landing/home_fragment.dart) — card de recolha

#### 2.2. Limitação conhecida do fallback

`HealthManager.sendToPhone` recorre a `updateApplicationContext` quando a
`WCSession` não está *reachable*. Do lado Dart, o `WatchStreamingService` só
subscreve `messageReceived`; o plugin expõe o *application context* numa stream
separada (`applicationContextUpdated`) que **não é subscrita**. Na prática, tudo
o que passe pelo caminho de fallback é **perdido silenciosamente**. Além disso,
`updateApplicationContext` guarda apenas o último dicionário, pelo que também
não serviria como buffer.

---

## 3. Requisitos

### 3.1. Toolchain

| Ferramenta | Versão |
|---|---|
| Flutter | `3.41.1` (pinado em [app/.fvmrc](app/.fvmrc)) |
| Dart SDK | `>=3.0.0 <4.0.0` (constraint do [app/pubspec.yaml](app/pubspec.yaml)) |
| Xcode | 16+ para iOS; **26.x** necessário para o target watchOS (ver §3.2) |
| CocoaPods | necessário para `pod install` em `app/ios` |

> **O CI usa deliberadamente uma versão de Flutter mais antiga.**
> [codemagic.yaml](codemagic.yaml) pina Flutter `3.24.0`, enquanto o
> desenvolvimento local usa `3.41.1` ([.fvmrc](app/.fvmrc)). Isto não é um
> desalinhamento acidental: o Codemagic serve para continuar a conseguir
> construir e correr a **versão antiga** da app (a app de monitorização da
> tese de Nuno Gomes, anterior ao reaproveitamento para recolha de dados —
> ver §1.1), com o toolchain com que essa versão foi originalmente validada.
> O desenvolvimento da versão de recolha de dados corre à parte, com Flutter
> mais recente.

### 3.2. Plataformas mínimas

| Alvo | Mínimo | Fonte |
|---|---|---|
| iOS (Podfile) | 15.0 | [app/ios/Podfile](app/ios/Podfile) |
| iOS (`IPHONEOS_DEPLOYMENT_TARGET`) | 15.6 | `Runner.xcodeproj` |
| watchOS (`WATCHOS_DEPLOYMENT_TARGET`) | **26.2** | `Runner.xcodeproj` |

O `WATCHOS_DEPLOYMENT_TARGET = 26.2` é extremamente restritivo: exclui todo o
hardware que não corra watchOS 26.2 ou superior. Nada no código do
`HealthManager` requer APIs recentes — é provavelmente o valor por omissão
herdado da criação do target no Xcode. Baixar para `10.0` (ou `9.0`) alargaria
muito a compatibilidade sem alterar lógica.

### 3.3. Dispositivos

- **iPhone físico** com iOS ≥ 15.6. O simulador não serve: `WCSession`,
  HealthKit e Bluetooth não funcionam em simulador.
- **Apple Watch físico** emparelhado com esse iPhone, com a app
  *Runner Watch Kit App* instalada.
- Conta de programador Apple para assinar ambos os targets.
- (Opcional, legado) Pulseira BLE H-Band, para o caminho de aquisição
  alternativo via `flutter_blue_plus`.

### 3.4. Permissões

- **iPhone** ([app/ios/Runner/Info.plist](app/ios/Runner/Info.plist)):
  `NSHealthShareUsageDescription`, `NSHealthUpdateUsageDescription`. Bluetooth e
  localização são pedidos em runtime via `permission_handler`, e as
  *entitlements* de Bluetooth/localização são injetadas pelo script do Codemagic.
- **Watch** (`INFOPLIST_KEY_*` no `Runner.xcodeproj` + `.entitlements`):
  `NSHealthShareUsageDescription`, `NSHealthUpdateUsageDescription`,
  `com.apple.developer.healthkit`.

### 3.5. Configuração (`.env`)

O ficheiro `app/.env` é declarado como asset no `pubspec.yaml` e **tem de
existir** para a app arrancar (`dotenv.load()` no `main`). Copiar de
[app/.env-example](app/.env-example) e preencher:

```
RABBITMQ_HOST_ADDRESS=
RABBITMQ_HOST_PORT=
AUTH0_DOMAIN=
AUTH0_CLIENT_ID=
AUTH0_CUSTOM_SCHEME=
AUTH0_RETURN_URL=
WORK_RECONNECT_INTERVAL=
UPLOAD_WORK_INTERVAL=
```

---

## 4. Build e execução

```bash
cd app

# 1. Dependências Dart
flutter pub get

# 2. Configuração
cp .env-example .env      # e preencher os valores

# 3. Pods iOS
cd ios && pod install && cd ..

# 4. Correr no iPhone (dispositivo físico)
flutter devices           # identificar o id do iPhone
flutter run -d <device-id>
```

### 4.1. Modo de recolha de dados (flag) — versão antiga vs. nova

Como referido em §1.1, o mesmo código-base contém tanto a app de
**monitorização** original (tese de Nuno Gomes) como a versão
**reaproveitada para recolha de dados**. A diferença entre as duas, ao nível
de UI, resume-se ao card de recolha em
[app/lib/src/ui/view/landing/home_fragment.dart](app/lib/src/ui/view/landing/home_fragment.dart).

**Estado atual — `NÃO` implementado.** Hoje esse card é ativado/desativado
comentando à mão estas linhas:

```dart
_DataCollectionCard(watchVM: watchVM),
const SizedBox(height: 12),
if (_sessions.isNotEmpty) const SizedBox(height: 12),
```

**Proposta, ainda por aplicar** (aguarda a tua aprovação do diff): mover isto
para uma flag de compilação única, `kEnableDataCollection`, definida em
`app/lib/globals/feature_flags.dart` (ficheiro ainda não criado):

```dart
const bool kEnableDataCollection =
    bool.fromEnvironment('ENABLE_DATA_COLLECTION', defaultValue: true);
```

com as linhas acima envolvidas em `if (kEnableDataCollection)`, e arranque via:

```bash
flutter run --dart-define=ENABLE_DATA_COLLECTION=true    # versão nova (recolha)
flutter run --dart-define=ENABLE_DATA_COLLECTION=false   # versão antiga (monitorização)
```

**Porquê uma flag em vez de duas cópias do código.** O objetivo é manter as
duas versões — a antiga (monitorização, fiel à tese) e a nova (recolha de
dados) — no **mesmo código-base**, selecionáveis em tempo de compilação, em
vez de bifurcar o repositório em dois projetos a divergir. `bool.fromEnvironment`
é resolvido em tempo de compilação: em modo release o ramo desativado é
removido pelo *tree shaking*, pelo que a versão antiga não carrega código morto
da recolha nem vice-versa.

**Âmbito previsto da flag:** por si só, desliga apenas a *interface* de
recolha. A `WatchStreamingService` continua a ser inicializada no `main.dart`
e a `WCSession` continua ativa mesmo com a flag a `false`. Para que a flag
reproduza fielmente a app de monitorização original, seria necessário também
envolver a chamada `await watchService.init()` em
[app/lib/main.dart:96-98](app/lib/main.dart#L96-L98) na mesma flag.

### 4.2. Build watchOS

O target *Runner Watch Kit App Watch App* faz parte do
`app/ios/Runner.xcodeproj` e é embebido na app iOS
(`WKCompanionAppBundleIdentifier = ipl.isel.meic.anxolotlApp`,
`WKRunsIndependentlyOfCompanionApp = NO`). Não é construído pelo
`flutter build ios`. Para instalar no relógio:

```bash
open app/ios/Runner.xcworkspace
```

e correr o esquema do watch app a partir do Xcode, com o iPhone emparelhado
ligado.

### 4.3. CI (Codemagic) — build contínuo da versão antiga

[codemagic.yaml](codemagic.yaml) define um workflow `flutter-build` que produz um
APK de debug e um IPA iOS não assinado (com *entitlements* injetadas via `ldid`).
O workflow **não constrói o target watchOS** — coerente com o facto de o CI
servir a versão de **monitorização** (§1.1, §3.1), que não tem componente
watchOS. Enquanto o `.fvmrc` local segue a versão de Flutter usada no
desenvolvimento da app de recolha, o `codemagic.yaml` fica intencionalmente
preso ao Flutter `3.24.0` para continuar a construir a versão antiga com o
toolchain original.

---

## 5. Estrutura de diretórios

```
anxolotl_app-main/
├── README.md                    Este ficheiro
├── DATA.md                      Especificação dos sinais e do formato de exportação
├── LICENSE                      Licença MIT
├── CITATION.cff                 Metadados de citação
├── .gitignore
├── codemagic.yaml               Configuração de CI (Codemagic)
└── app/                         Projeto Flutter
    ├── pubspec.yaml             Dependências e assets
    ├── .fvmrc                   Versão de Flutter pinada (FVM)
    ├── .env / .env-example      Segredos e endpoints (não versionar .env)
    ├── analysis_options.yaml    Configuração do analisador Dart
    ├── docker-compose.yml       Serviços de apoio (broker AMQP)
    ├── flutter_native_splash.yaml
    │
    ├── lib/                     ── Código Dart ──────────────────────────────
    │   ├── main.dart            Bootstrap: dotenv, ObjectBox, AMQP, providers
    │   ├── globals/             Constantes globais: rotas, caminhos de assets,
    │   │                        feature flags
    │   ├── assets/              Imagens, branding, exercícios, certificados TLS
    │   ├── l10n/generated/      Traduções geradas (intl) — não editar à mão
    │   └── src/
    │       ├── lang/            Delegate de localização e chaves de tradução
    │       ├── util/            Helpers e tema visual (aesthetics/)
    │       ├── data/            ── Camada de dados ──────────────────────────
    │       │   ├── model/
    │       │   │   ├── user/            Perfil, perfil de saúde, eventos
    │       │   │   └── entities/
    │       │   │       ├── common/      Abstrações de dispositivo e sensor
    │       │   │       ├── hband/       Implementação da pulseira BLE H-Band
    │       │   │       └── measurements/Modelo de medição
    │       │   ├── data_acces/
    │       │   │   ├── api/             Cliente AMQP + TLS
    │       │   │   ├── database/        ObjectBox (+ código gerado)
    │       │   │   ├── dto/             DTOs API / DB / local storage
    │       │   │   └── repositories/    Repositórios e implementações
    │       │   ├── services/
    │       │   │   ├── health/          ★ watch_streaming_service.dart
    │       │   │   │                      Receção do Watch, buffer e export CSV
    │       │   │   ├── health_labels/   Eventos e labels de saúde
    │       │   │   ├── health_profile/  Perfil clínico do utilizador
    │       │   │   ├── authentication/  Auth0 / Google Sign-In
    │       │   │   ├── bluetooth/       Scan e ligação BLE
    │       │   │   ├── device/          Controlo de dispositivos de aquisição
    │       │   │   ├── measurement/     Ciclo de vida das medições
    │       │   │   ├── foreground_operations/  Tarefas em background
    │       │   │   ├── services_aggregator/    Composição de serviços
    │       │   │   └── wellbeing_exercises/    Respiração e meditação
    │       │   └── utils/        Validação de rede
    │       └── ui/              ── Camada de apresentação ───────────────────
    │           ├── viewmodels/  ChangeNotifiers (provider)
    │           │                ★ watch_vm.dart — estado do card de recolha
    │           ├── view/
    │           │   ├── landing/      Home, eventos, perfil, bem-estar
    │           │   │                 ★ home_fragment.dart — card de recolha
    │           │   ├── auth_page/    Login
    │           │   ├── connection/   Emparelhamento BLE
    │           │   ├── data_overview/Gráficos de ansiedade / pânico
    │           │   ├── breathing_exercise/
    │           │   ├── meditation_exercise/
    │           │   └── common_widgets/
    │           ├── datatypes/   Tipos de apoio à UI
    │           └── animations/  Transições de página
    │
    ├── ios/                     ── Projeto Xcode ───────────────────────────
    │   ├── Runner/              App iOS (AppDelegate, SceneDelegate, Info.plist)
    │   ├── Runner Watch Kit App Watch App/   ★ App watchOS
    │   │   ├── Runner_Watch_Kit_AppApp.swift  Entry point SwiftUI
    │   │   ├── ContentView.swift              UI e arranque do streaming
    │   │   ├── HealthManager.swift            ★ HealthKit + CoreMotion + WCSession
    │   │   └── *.entitlements                 com.apple.developer.healthkit
    │   ├── Runner.xcodeproj/    Targets iOS e watchOS
    │   ├── Runner.xcworkspace/  Abrir este ficheiro no Xcode
    │   ├── Podfile              platform :ios, '15.0'
    │   └── Flutter/             Ficheiros gerados pelo Flutter
    │
    ├── android/                 Projeto Gradle (a recolha via Watch é iOS-only)
    ├── macos/ linux/ windows/ web/   Runners gerados pelo Flutter, não usados
    ├── legacy/                  Código morto preservado para referência
    │   └── wacth_vm.dart        Duplicado de watch_vm.dart (nome com erro
    │                            ortográfico), nunca importado. Movido para
    │                            fora de lib/ para não ser confundido com o
    │                            viewmodel em uso.
    └── test/                    widget_test.dart (template por preencher)
```

`★` marca os ficheiros no caminho crítico da recolha de sinais.