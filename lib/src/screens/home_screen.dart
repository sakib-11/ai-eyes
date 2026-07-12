import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state.dart';
import '../services/voice_assistant_service.dart';
import '../theme/app_theme.dart';
import '../widgets/feature_tile.dart';
import '../widgets/info_chip.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final VoiceAssistantService _voiceAssistantService;

  @override
  void initState() {
    super.initState();
    _voiceAssistantService = VoiceAssistantService();
  }

  Future<void> _selectMode(AppMode mode) async {
    ref.read(appModeProvider.notifier).state = mode;
    ref.read(assistantMessageProvider.notifier).state =
        'Switched to ${mode.title}. ${mode.subtitle}';
    await _voiceAssistantService.speak(
      'Activated ${mode.title} mode. ${mode.subtitle}',
    );
  }

  Future<void> _startVoiceCommand() async {
    final isListening = ref.read(isListeningProvider);
    if (isListening) {
      await _voiceAssistantService.stopListening();
      ref.read(isListeningProvider.notifier).state = false;
      return;
    }

    ref.read(isListeningProvider.notifier).state = true;
    ref.read(assistantMessageProvider.notifier).state =
        'Listening for your command...';

    final success = await _voiceAssistantService.startListening(
      onResult: (result) async {
        ref.read(assistantMessageProvider.notifier).state = 'Heard: $result';
        await _voiceAssistantService.speak('You said: $result');
      },
      onDone: () {
        ref.read(isListeningProvider.notifier).state = false;
        ref.read(assistantMessageProvider.notifier).state =
            'Voice command ended. Tap again to listen.';
      },
    );

    if (!success) {
      ref.read(isListeningProvider.notifier).state = false;
      ref.read(assistantMessageProvider.notifier).state =
          'Voice command unavailable. Try again later.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(appModeProvider);
    final assistantMessage = ref.watch(assistantMessageProvider);
    final isListening = ref.watch(isListeningProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('AI EYES'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.backgroundTop,
                  AppColors.backgroundMid,
                  AppColors.backgroundBottom,
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.6, -0.8),
                    radius: 1.1,
                    colors: [
                      AppColors.primary.withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildStatusPanel(mode, assistantMessage),
                  const SizedBox(height: 24),
                  _buildModeSelector(mode),
                  const SizedBox(height: 20),
                  Expanded(child: _buildFeatureGrid()),
                  const SizedBox(height: 16),
                  _buildVoiceControl(isListening),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPanel(AppMode mode, String assistantMessage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.5),
          width: 1.2,
        ),
        gradient: const LinearGradient(
          colors: [AppColors.primarySoft, AppColors.accentMint],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GENTLE AI LENS',
            style: TextStyle(
              letterSpacing: 2,
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            mode.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mode.subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            assistantMessage,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              InfoChip(label: 'Latency', value: '75ms'),
              const InfoChip(label: 'Vision', value: 'Multi-modal'),
              InfoChip(label: 'Mode', value: mode.title),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(AppMode currentMode) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: AppMode.values.map((mode) {
          final selected = mode == currentMode;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => _selectMode(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                width: 170,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary.withOpacity(0.3)
                      : AppColors.surface.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.primarySoft.withOpacity(0.9),
                    width: 1.1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        mode.subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    const featureTiles = [
      FeatureTile(
        title: 'Gesture AI',
        description: 'Use hand gestures to switch mode',
        icon: Icons.waves,
      ),
      FeatureTile(
        title: 'Neural Snapshot',
        description: 'Instant scene snapshot with clarity',
        icon: Icons.camera_enhance,
      ),
      FeatureTile(
        title: 'Horizon Map',
        description: 'Spatial awareness for navigation',
        icon: Icons.explore,
      ),
      FeatureTile(
        title: 'Speech Memory',
        description: 'Recall last command quickly',
        icon: Icons.history,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.05,
      padding: EdgeInsets.zero,
      children: featureTiles,
    );
  }

  Widget _buildVoiceControl(bool isListening) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.secondarySoft, AppColors.accentBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.primarySoft.withOpacity(0.9),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice Command',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap to speak a command.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isListening
                  ? AppColors.danger
                  : AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onPressed: _startVoiceCommand,
            icon: Icon(
              isListening ? Icons.mic_off : Icons.mic,
              color: AppColors.textOnAccent,
            ),
            label: Text(
              isListening ? 'Stop' : 'Speak',
              style: const TextStyle(
                color: AppColors.textOnAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
