# DATA.md — Recolha e exportação de sinais

Este documento descreve **o que o código faz hoje**, não o que seria desejável.
Todas as afirmações estão referenciadas ao ficheiro e linha correspondentes.

> Os sinais aqui descritos existem porque a app de monitorização original
> (tese de mestrado de Nuno Gomes) foi reaproveitada para recolha de dados —
> ver [README.md §1.1](README.md#11-origem-e-reaproveitamento-repurposing).
> Esta versão de recolha foi de facto utilizada para efetuar uma recolha de
> dados; os formatos abaixo são os que essa recolha produziu.

Ficheiros no caminho de dados:

- [app/ios/Runner Watch Kit App Watch App/HealthManager.swift](app/ios/Runner%20Watch%20Kit%20App%20Watch%20App/HealthManager.swift) — aquisição no relógio
- [app/lib/src/data/services/health/watch_streaming_service.dart](app/lib/src/data/services/health/watch_streaming_service.dart) — receção, buffer e escrita do CSV

---

## 1. Sinais recolhidos

O relógio adquire sinais por **duas vias independentes**, com temporizações
distintas.

| Sinal | Coluna CSV | Unidade | Fonte | Via |
|---|---|---|---|---|
| Frequência cardíaca | `hr_bpm` | bpm (`count/min`) | `HKQuantityTypeIdentifier.heartRate` | HealthKit |
| Intervalo inter-batimento (derivado) | `ibi_ms` | ms | calculado a partir de `hr_bpm` | HealthKit |
| Passos (acumulado) | `steps` | contagem | `HKQuantityTypeIdentifier.stepCount` | HealthKit |
| Energia ativa (acumulado) | `calories_kcal` | kcal | `HKQuantityTypeIdentifier.activeEnergyBurned` | HealthKit |
| Distância (acumulado) | `distance_m` | m | `HKQuantityTypeIdentifier.distanceWalkingRunning` | HealthKit |
| Aceleração X | `acc_x` | **g** | `CMAccelerometerData.acceleration.x` | Core Motion |
| Aceleração Y | `acc_y` | **g** | `CMAccelerometerData.acceleration.y` | Core Motion |
| Aceleração Z | `acc_z` | **g** | `CMAccelerometerData.acceleration.z` | Core Motion |

### 1.1. HR — frequência cardíaca

`HealthManager.swift:146-150`

```swift
case HKQuantityTypeIdentifier.heartRate.rawValue:
    if let value = stats?.mostRecentQuantity()?.doubleValue(for: HKUnit(from: "count/min")) {
        data["hr"] = value
        data["ibi"] = value > 0 ? (60.0 / value) * 1000 : 0
    }
```

- Unidade: **bpm** (`count/min`), explicitamente pedida ao HealthKit.
- Estatística usada: `mostRecentQuantity()` — o valor mais recente conhecido pelo
  `HKLiveWorkoutBuilder` no momento da entrega, **não** a média do intervalo.
- Origem: `HKLiveWorkoutDataSource` associado a um `HKWorkoutSession` de
  `activityType = .other`, `locationType = .unknown`.

### 1.2. ACC — acelerometria tri-axial

`HealthManager.swift:89-114`

```swift
motionManager.accelerometerUpdateInterval = 1.0 / 25.0

motionManager.startAccelerometerUpdates(to: motionQueue) { [weak self] data, error in
    batch.append([
        "x": data.acceleration.x,
        "y": data.acceleration.y,
        "z": data.acceleration.z,
        "t": Date().timeIntervalSince1970
    ])
    if batch.count >= 5 {
        self.sendToPhone(data: ["acc_batch": batch])
        batch = []
    }
}
```

- Unidade: **g** (aceleração gravitacional, 1 g ≈ 9,81 m/s²). É a unidade nativa
  de `CMAccelerometerData.acceleration` — o código não aplica qualquer conversão
  nem escalamento.
- **Inclui a componente gravitacional.** É o acelerómetro em bruto
  (`startAccelerometerUpdates`), não `deviceMotion.userAcceleration`. Em repouso,
  a norma do vetor é ≈ 1 g. Para obter aceleração de utilizador é preciso
  filtrar a gravidade em pós-processamento.
- Referencial: eixos do dispositivo (Apple Watch), não referencial do mundo.
- Cada amostra transporta o seu próprio timestamp `t`, gerado com
  `Date().timeIntervalSince1970` **no callback do Core Motion** (não é o
  `data.timestamp` do `CMLogItem`).

### 1.3. IBI — intervalo inter-batimento (derivado)

`HealthManager.swift:149`

```swift
data["ibi"] = value > 0 ? (60.0 / value) * 1000 : 0
```

Ou seja, `IBI_ms = 60000 / HR_bpm`.

> ### ⚠️ Este sinal **não é uma série beat-to-beat genuína**
>
> O IBI exportado é uma **pseudo-variabilidade derivada da HR**, obtida por
> inversão aritmética do valor de frequência cardíaca fornecido pelo
> `HKLiveWorkoutBuilder`. Consequências para a análise:
>
> - **Não há informação beat-to-beat.** O HealthKit entrega uma HR já agregada
>   pelo sensor óptico do relógio; a inversão não recupera os intervalos RR
>   individuais que foram perdidos nessa agregação.
> - **Métricas de HRV no domínio do tempo são inválidas.** RMSSD, SDNN, pNN50 e
>   afins calculados sobre esta série medem a variação *da estimativa de HR do
>   relógio* entre entregas consecutivas, não a variabilidade cardíaca real. Os
>   valores serão sistematicamente subestimados e enviesados pelo algoritmo de
>   suavização interno da Apple.
> - **Métricas no domínio da frequência são inválidas.** A série é irregularmente
>   amostrada a ~0,2–1 Hz, muito abaixo do necessário para resolver a banda HF
>   (0,15–0,40 Hz) de forma fiável.
> - **A coluna é redundante.** `ibi_ms` é uma função determinística de `hr_bpm`;
>   não acrescenta informação. Pode ser reconstruída a partir de `hr_bpm` em
>   qualquer momento.
> - Quando `hr_bpm == 0`, `ibi_ms` é escrito como `0` (e não como valor em
>   falta) — ver §5.
>
> **Alternativa disponível e não usada.** O `HealthManager` já pede autorização
> de leitura para `HKQuantityTypeIdentifier.heartRateVariabilitySDNN`
> (`HealthManager.swift:40`), mas nunca o recolhe: o `HKLiveWorkoutDataSource`
> não o inclui por omissão e não é adicionado explicitamente com
> `enableCollection(for:)`. O tipo `.heartbeatSeries` (`HKHeartbeatSeriesSample`),
> que **contém** intervalos beat-to-beat reais, não é pedido de todo.

### 1.4. Passos, calorias e distância

`HealthManager.swift:151-162` — todos usam `stats?.sumQuantity()`.

**São valores acumulados desde o início da `HKWorkoutSession`, não incrementos
por intervalo.** Para obter incrementos é preciso diferenciar a série em
pós-processamento. As unidades pedidas ao HealthKit são, respetivamente,
`.count()`, `.kilocalorie()` e `.meter()`.

---

## 2. Frequência de amostragem

| Sinal | Cadência de aquisição | Cadência de transmissão | Controlada por |
|---|---|---|---|
| ACC (x, y, z) | **25 Hz** nominal | lotes de 5 amostras → ~5 mensagens/s | `accelerometerUpdateInterval = 1.0 / 25.0` |
| HR / IBI | **event-driven**, ~0,2–1 Hz | 1 mensagem por entrega | `HKLiveWorkoutBuilder` (Apple, não configurável) |
| Passos | event-driven, irregular | 1 mensagem por entrega | idem |
| Calorias | event-driven, irregular | 1 mensagem por entrega | idem |
| Distância | event-driven, irregular | 1 mensagem por entrega | idem |

### Notas sobre a cadência

**HR — não é amostragem periódica.** O `HKLiveWorkoutBuilder` chama
`workoutBuilder(_:didCollectDataOf:)` quando o HealthKit tem novos dados; nem o
período nem a jitter são configuráveis pela app. Durante um workout ativo, o
Apple Watch tipicamente atualiza a HR a cada 1–5 segundos, mas isto é
comportamento observado, não contratual. **Não assumir cadência fixa na
análise** — usar sempre os timestamps.

**Nenhum sinal é reamostrado ou alinhado.** Não há interpolação, nem sincronismo
entre a via HealthKit e a via Core Motion. Cada amostra é escrita na sua própria
linha, com o seu próprio timestamp.

---

## 3. Formato exato do ficheiro exportado

### 3.1. Localização e nome

`watch_streaming_service.dart:144-167`

```
<Application Documents Directory>/anxolotl_sessions/session_NNNN.csv
```

- `NNNN` é um contador de 4 dígitos com *zero-padding* (`session_0001.csv`,
  `session_0002.csv`, …).
- O contador é incrementado **antes** de escrever e persistido em
  `<Application Documents Directory>/session_counter.txt`, lido no arranque
  (`init()`, linhas 78-82). Sobrevive a reinícios da app; é perdido se a app for
  desinstalada.
- O ficheiro só é escrito se o buffer da sessão não estiver vazio
  (`stopRecording()`, linha 133) — sessões sem dados não produzem ficheiro e
  **não consomem número de contador**.

### 3.2. Cabeçalho e ordem das colunas

`watch_streaming_service.dart:157`

```csv
timestamp_unix,hr_bpm,ibi_ms,steps,calories_kcal,distance_m,acc_x,acc_y,acc_z
```

**9 colunas, sempre nesta ordem.** Terminador de linha `\n` (`writeln`).
Codificação UTF-8. Sem aspas, sem escaping (nenhum campo pode conter vírgulas).
Não há BOM. Há uma linha em branco final (o último `writeln` emite `\n`).

| # | Coluna | Unidade | Formato | Precisão |
|---|---|---|---|---|
| 1 | `timestamp_unix` | segundos desde a época Unix (UTC) | `toStringAsFixed(3)` | 3 casas decimais (ms) |
| 2 | `hr_bpm` | bpm | `toStringAsFixed(2)` | 2 casas decimais |
| 3 | `ibi_ms` | ms | `toStringAsFixed(2)` | 2 casas decimais |
| 4 | `steps` | contagem (acumulada) | `toStringAsFixed(0)` | inteiro |
| 5 | `calories_kcal` | kcal (acumulada) | `toStringAsFixed(3)` | 3 casas decimais |
| 6 | `distance_m` | metros (acumulada) | `toStringAsFixed(1)` | 1 casa decimal |
| 7 | `acc_x` | g | `toStringAsFixed(4)` | 4 casas decimais |
| 8 | `acc_y` | g | `toStringAsFixed(4)` | 4 casas decimais |
| 9 | `acc_z` | g | `toStringAsFixed(4)` | 4 casas decimais |

### 3.3. ⚠️ O ficheiro é *esparso*: cada linha contém um só sinal

Esta é a característica mais importante do formato e a mais fácil de interpretar
mal.

Do lado do relógio, `workoutBuilder(_:didCollectDataOf:)` itera sobre
`collectedTypes` e faz **uma chamada `sendToPhone` separada por cada tipo**
(`HealthManager.swift:139-170`). Do lado do Flutter, cada mensagem recebida
produz **uma linha**. Resultado: uma linha nunca contém HR e passos ao mesmo
tempo, nem HR e acelerometria.

Campos ausentes são escritos como **string vazia** (`?? ""`), não como `NaN`,
`null` ou `0`.

Exemplo real do aspeto de um ficheiro:

```csv
timestamp_unix,hr_bpm,ibi_ms,steps,calories_kcal,distance_m,acc_x,acc_y,acc_z
1774094401.210,,,,,,-0.0234,-0.9812,0.1145
1774094401.250,,,,,,-0.0219,-0.9834,0.1102
1774094401.290,,,,,,-0.0241,-0.9798,0.1187
1774094401.330,,,,,,-0.0208,-0.9821,0.1163
1774094401.370,,,,,,-0.0226,-0.9807,0.1129
1774094401.512,72.00,833.33,,,,,,
1774094401.514,,,143,,,,,
1774094401.516,,,,2.451,,,,
1774094401.518,,,,,118.4,,,
1774094401.610,,,,,,-0.0231,-0.9815,0.1151
```

Note-se que as linhas de HR/passos/calorias/distância chegam praticamente no
mesmo instante — vêm todas da mesma invocação do delegate — mas ocupam linhas
distintas.

Para reconstruir uma tabela densa é necessário, em pós-processamento:
1. separar as linhas por sinal (linha ACC = `acc_x` não vazio; linha HR =
   `hr_bpm` não vazio; etc.);
2. tratar cada uma como série temporal independente;
3. reamostrar/interpolar para uma grelha comum, se a análise o exigir;
4. diferenciar `steps`, `calories_kcal` e `distance_m` para obter incrementos.

### 3.4. Semântica do timestamp

`timestamp_unix` é **o instante de entrega no relógio, não o instante de medição
do sensor**.

- Linhas ACC: `Date().timeIntervalSince1970` avaliado dentro do callback do
  Core Motion (`HealthManager.swift:106`). É o mais próximo do instante de
  amostragem, mas ainda assim sujeito à latência da fila
  (`motionQueue`, `OperationQueue` sem `maxConcurrentOperationCount` definido).
- Linhas HealthKit: `Date().timeIntervalSince1970` avaliado no início do
  delegate (`HealthManager.swift:143`). O `HKQuantitySample` subjacente tem
  `startDate`/`endDate` próprios, que **são descartados**. A defasagem entre a
  medição real e este timestamp pode ser de vários segundos.
- Se a mensagem não trouxer `timestamp`, o lado Dart usa a hora do **iPhone** no
  momento da receção (`watch_streaming_service.dart:105-107`). Na prática este
  ramo não é atingido, porque o relógio inclui sempre o campo.
- Todos os relógios são relógios de parede do dispositivo, sujeitos a ajustes
  NTP durante a sessão.

### 3.5. Ordenação das linhas

As linhas são gravadas por **ordem de chegada ao iPhone**
(`_sessionBuffer.add(...)`), não por timestamp. Como a acelerometria é enviada em
lotes de 5, um lote ACC pode ser escrito *depois* de uma linha HealthKit cujo
timestamp lhe é posterior. **A coluna `timestamp_unix` não é garantidamente
monótona** — ordenar antes de analisar.

### 3.6. Exportação para fora da app

`home_fragment.dart:279-288` — cada sessão listada no card *Saved sessions* tem
um botão de partilha que invoca `Share.shareXFiles` (`share_plus`), abrindo a
folha de partilha nativa do iOS. Não há upload automático: os CSV de sessão
**não** passam pelo canal AMQP, que serve apenas o caminho de aquisição legado da
pulseira BLE H-Band.

---

## 4. Quando é que os dados são gravados

Distinção importante entre *streaming* e *recording*:

| | Início | Fim |
|---|---|---|
| **Streaming** (relógio → iPhone) | `ContentView.onAppear` no relógio | nunca é parado no código |
| **Recording** (iPhone → buffer → CSV) | botão START (`startRecording()`) | botão STOP (`stopRecording()`) |

- O relógio começa a transmitir assim que a app do relógio abre e **nunca deixa
  de transmitir** — não existe `stopStreaming()`, nem se chama
  `motionManager.stopAccelerometerUpdates()` ou
  `workoutSession.end()` em lado nenhum.
- A mensagem `{'recording': bool}` enviada pelo iPhone apenas atualiza o
  indicador visual no relógio (`HealthManager.swift:183-190`). Não afeta a
  aquisição.
- Fora de uma gravação, as amostras recebidas são emitidas na `dataStream` (e
  usadas para mostrar "Apple Watch connected") mas **descartadas**, porque
  `_sessionBuffer.add` só corre se `_isRecording` for verdadeiro
  (`watch_streaming_service.dart:99` e `:119`).
- Durante a gravação, o `WakelockPlus` mantém o ecrã do iPhone ligado
  (`home_fragment.dart:138-141`).
- O buffer é mantido **inteiramente em memória** até ao STOP
  (`_sessionBuffer`, `watch_streaming_service.dart:69`). Não há escrita
  incremental: se a app for terminada pelo iOS a meio de uma sessão, **todos os
  dados dessa sessão são perdidos**. A 25 Hz, uma hora de acelerometria são
  ~90 000 objetos `WatchData` retidos.

---

## 5. Valores em falta e casos limite

| Situação | O que aparece no CSV |
|---|---|
| Campo não presente na mensagem | string vazia |
| `hr_bpm == 0` (HealthKit devolveu 0) | `ibi_ms` = `0.00`, e **não** vazio — `HealthManager.swift:149` |
| Relógio não *reachable* | dados **perdidos silenciosamente** — ver §6 |
| Sessão parada sem amostras | nenhum ficheiro criado, `stopRecording()` devolve `null` |
| Erro na escrita do CSV | capturado e engolido, devolve `null` — `watch_streaming_service.dart:164-166` |
| Erro no envio de `{'recording': …}` | `catch` vazio, sem log — `watch_streaming_service.dart:140-141` |

Ao analisar, tratar `ibi_ms == 0` como **valor em falta**, não como um IBI de
0 ms.

---

## 6. Perda de dados no fallback de conectividade

`HealthManager.swift:175-181`

```swift
private func sendToPhone(data: [String: Any]) {
    guard let session = wcSession, session.isReachable else {
        try? wcSession?.updateApplicationContext(data)
        return
    }
    session.sendMessage(data, replyHandler: nil, errorHandler: nil)
}
```

Quando o iPhone não está *reachable*, os dados vão para
`updateApplicationContext`. Este caminho **não recupera nada**, por três razões
cumulativas:

1. `updateApplicationContext` guarda **apenas o último dicionário** enviado —
   substitui o anterior. Não é uma fila.
2. Do lado Dart, `WatchStreamingService.init()` subscreve apenas
   `_connectivity.messageReceived`. O plugin entrega o *application context*
   numa stream distinta, `applicationContextUpdated`, que não é subscrita.
3. `sendMessage` é chamado com `errorHandler: nil`, pelo que falhas de envio no
   caminho principal também são silenciosas.

Resultado prático: qualquer interrupção da ligação Watch↔iPhone produz um
**buraco não sinalizado** no CSV. Não há forma de distinguir, a partir do
ficheiro, entre "o utilizador estava parado" e "a ligação caiu". Recomenda-se
verificar a continuidade temporal da coluna `timestamp_unix` antes de qualquer
análise.

---

## 7. Checklist para quem for analisar os CSV

1. Ordenar por `timestamp_unix` — não vem ordenado (§3.5).
2. Separar em séries por sinal — o ficheiro é esparso (§3.3).
3. Tratar `ibi_ms == 0` como valor em falta (§5).
4. Não calcular HRV a partir de `ibi_ms` (§1.3).
5. Diferenciar `steps`, `calories_kcal`, `distance_m` para obter incrementos (§1.4).
6. Verificar buracos temporais — podem indicar perda de conectividade, não repouso (§6).
7. Confirmar a taxa efetiva do ACC a partir dos timestamps; 25 Hz é o pedido, não
   a garantia (§2).
8. Se precisar de aceleração de utilizador, remover a componente gravitacional —
   o sinal é acelerómetro em bruto (§1.2).
