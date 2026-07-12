import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppMode { scene, text, medicine, currency, obstacle }

extension AppModeExtensions on AppMode {
  String get title {
    switch (this) {
      case AppMode.scene:
        return 'Live Scene';
      case AppMode.text:
        return 'Text Reader';
      case AppMode.medicine:
        return 'Medicine Scan';
      case AppMode.currency:
        return 'Currency Check';
      case AppMode.obstacle:
        return 'Obstacle Alert';
    }
  }

  String get subtitle {
    switch (this) {
      case AppMode.scene:
        return 'Describe the world instantly.';
      case AppMode.text:
        return 'Read text, signs and labels.';
      case AppMode.medicine:
        return 'Verify product details safely.';
      case AppMode.currency:
        return 'Detect notes and values quickly.';
      case AppMode.obstacle:
        return 'Spot hazards in your path.';
    }
  }

  String get heroTag {
    return title.replaceAll(' ', '-').toLowerCase();
  }
}

final appModeProvider = StateProvider<AppMode>((ref) => AppMode.scene);
final assistantMessageProvider = StateProvider<String>(
  (ref) => 'AI Lens ready. Select a mode or tap the voice command button.',
);
final isListeningProvider = StateProvider<bool>((ref) => false);
