import 'dart:io';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/datatypes/overview_datatypes.dart';
import 'package:anxolotl_app/src/ui/view/data_overview/anxiety_overview_page.dart';
import 'package:anxolotl_app/src/ui/view/landing/widgets/data_overview_graph_card.dart';
import 'package:anxolotl_app/src/ui/view/landing/widgets/data_overview_slider_card.dart';
import 'package:anxolotl_app/src/ui/viewmodels/anxiety_data_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/panic_data_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/watch_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
 
class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});
 
  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}
 
class _HomeFragmentState extends State<HomeFragment> {
  List<File> _sessions = [];
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnxietyDataViewModel>(context, listen: false).setupListeners();
      _loadSessions();
    });
  }
 
  Future<void> _loadSessions() async {
    final watchVM = Provider.of<WatchViewModel>(context, listen: false);
    final sessions = await watchVM.listSessions();
    if (mounted) setState(() => _sessions = sessions);
  }
 
  @override
  Widget build(BuildContext context) {
    final anxietyDataVM = Provider.of<AnxietyDataViewModel>(context);
    final panicDataVM = Provider.of<PanicDataViewModel>(context);
    final watchVM = Provider.of<WatchViewModel>(context);
 
    // Recarregar lista quando terminar uma sessão
    if (watchVM.lastSavedPath != null && !watchVM.isRecording) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSessions());
    }
 
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(DesignTheme.singlePadding),
        children: [
          // ── Recolha de dados ─────────────────────────────────────────
          _DataCollectionCard(watchVM: watchVM),
 
          const SizedBox(height: 12),
 
          // ── Saved sessions ────────────────────────────────────────
          if (_sessions.isNotEmpty) _SessionsCard(sessions: _sessions),
 
          if (_sessions.isNotEmpty) const SizedBox(height: 12),
 
          // ── Ansiedade e Ataques de Pânico ────────────────────────────
          DataOverviewSliderCard(
            title: LocalizationsUtil.l10n(context).anxietyWord,
            nextPage: AnxietyOverviewPage(
                dataName: LocalizationsUtil.l10n(context).anxietyWord),
            sliderInterval: anxietyDataVM.getAnxietyLevelsInterval(),
            currentData: anxietyDataVM.getTodayAnxietyAverage().value > 0
                ? anxietyDataVM.getTodayAnxietyAverage()
                : OverviewDataType(
                    anxietyDataVM.getTodayAnxietyAverage().date, 0),
          ),
 
          const SizedBox(height: 12),
 
          DataOverviewGraphCard(
            title: LocalizationsUtil.l10n(context).panicAttackWord,
            todayValues: panicDataVM.getTodayPanicOccurrences(),
            graphValues: panicDataVM.getLastWeekPanicOccurrences(),
          ),
        ],
      ),
    );
  }
}
 
// ─────────────────────────────────────────────────────────────────────────────
// Card de recolha: só Watch ligado + Start/Stop
// ─────────────────────────────────────────────────────────────────────────────
 
class _DataCollectionCard extends StatelessWidget {
  final WatchViewModel watchVM;
  const _DataCollectionCard({required this.watchVM});
 
  @override
  Widget build(BuildContext context) {
    final isRecording = watchVM.isRecording;
    final isConnected = watchVM.isConnected;
 
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Estado do Watch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.watch,
                  size: 18,
                  color: isConnected ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  isConnected ? 'Apple Watch connected' : 'Waiting for Apple Watch...',
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
 
            const SizedBox(height: 20),
 
            // Botão grande Start/Stop
            GestureDetector(
              onTap: isConnected
                  ? () {
                      if (isRecording) {
                        watchVM.stopRecording();
                        WakelockPlus.disable();
                      } else {
                        watchVM.startRecording();
                        WakelockPlus.enable();
                      }
                    }
                  : null,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnected
                      ? (isRecording ? Colors.red : Colors.green)
                      : Colors.grey.shade300,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isRecording ? Icons.stop : Icons.fiber_manual_record,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isRecording ? 'STOP' : 'START',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
 
            const SizedBox(height: 16),
 
            // Estado da sessão
            if (isRecording)
              const _RecordingIndicator()
            else if (watchVM.lastSavedPath != null)
              Text(
                'Sessão guardada ✓',
                style: TextStyle(color: Colors.green.shade700, fontSize: 13),
              )
            else
              Text(
                isConnected ? 'Ready to start' : '',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }
}
 
// Indicador animado de gravação
class _RecordingIndicator extends StatefulWidget {
  const _RecordingIndicator();
 
  @override
  State<_RecordingIndicator> createState() => _RecordingIndicatorState();
}
 
class _RecordingIndicatorState extends State<_RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Recording...',
            style: TextStyle(color: Colors.red, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
 
// ─────────────────────────────────────────────────────────────────────────────
// Card com lista de sessões guardadas
// ─────────────────────────────────────────────────────────────────────────────
 
class _SessionsCard extends StatelessWidget {
  final List<File> sessions;
  const _SessionsCard({required this.sessions});
 
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saved sessions',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...sessions.map((file) {
              final name = file.path.split('/').last;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.insert_drive_file_outlined, size: 20),
                title: Text(name, style: const TextStyle(fontSize: 13)),
                trailing: IconButton(
                  icon: const Icon(Icons.share_outlined, size: 20),
                  onPressed: () async {
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      text: 'Dados Anxolotl — $name',
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
