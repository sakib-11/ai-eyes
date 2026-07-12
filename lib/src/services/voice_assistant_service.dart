import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistantService {
  VoiceAssistantService({SpeechToText? speechToText, FlutterTts? flutterTts})
    : _speechToText = speechToText ?? SpeechToText(),
      _flutterTts = flutterTts ?? FlutterTts();

  final SpeechToText _speechToText;
  final FlutterTts _flutterTts;
  bool _initialized = false;

  Future<void> initialize({SpeechStatusListener? onStatus}) async {
    if (_initialized) {
      return;
    }

    _initialized = await _speechToText.initialize(
      onStatus: onStatus,
      onError: (_) {},
    );
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(0.95);
    await _flutterTts.setLanguage('en-US');
  }

  Future<void> speak(String text) async {
    await initialize();
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<bool> startListening({
    required Function(String) onResult,
    required Function() onDone,
  }) async {
    await initialize(
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          onDone();
        }
      },
    );

    if (!_speechToText.isAvailable) {
      return false;
    }

    final success = await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      onSoundLevelChange: (_) {},
      listenOptions: SpeechListenOptions(listenMode: ListenMode.confirmation),
    );

    return success;
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }
}
