import 'dart:async';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextContinuous {
  final SpeechToText _stt = SpeechToText();
  Timer? _subscribe;
  static SpeechToTextContinuous? _instance;
  bool _isContinuousListening = false;

  /*Force disable listening removes access to the microphone listen method.
  Access can be regained by calling startListening method again.*/
  bool _forceDisableListening = false;

  SpeechToTextContinuous._();

  factory SpeechToTextContinuous.getInstance() {
    _instance ??= SpeechToTextContinuous._();
    return _instance!;
  }

  Future<void> init() async {
    await _stt.initialize();
  }

  Future<void> startListening({
    Function(SpeechRecognitionResult)? onresult,
    Function? notify,
    bool continuous = false,
  }) async {
    releaseForceDisableListening();
    await _startListening(onresult: onresult);
    if (continuous) {
      _subscribe =
          Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        _isContinuousListening = true;
        await _startListening(onresult: onresult, notify: notify);
      });
    }
  }

  Future<void> _startListening(
      {Function(SpeechRecognitionResult)? onresult, Function? notify}) async {
    if (_stt.isListening) return;
    if (notify != null) {
      await notify();
    }
    if (_forceDisableListening) return;
    await _stt.listen(
      onResult: onresult ?? _onResult,
      listenFor: const Duration(minutes: 10),
      cancelOnError: false,
    );
  }

  Future<void> stopListening({
    Function? notify,
    bool forceDisableListening = false,
  }) async {
    if (forceDisableListening) this.forceDisableListening();

    if (_subscribe != null) {
      _subscribe?.cancel();
    }

    if (notify != null) {
      await notify();
    }
    _isContinuousListening = false;
    await _stt.stop();
  }

  void releaseForceDisableListening() {
    _forceDisableListening = false;
  }

  void forceDisableListening() {
    _forceDisableListening = true;
  }

  Future<void> _onResult(SpeechRecognitionResult result) async {
    print(result.recognizedWords);
  }

  bool get isListening => _isContinuousListening ? true : _stt.isListening;
}
