import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:usegpt/gpt/gpt.dart';
import 'package:usegpt/speech_to_text_continuous/speech_to_text_continuous.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'animations/bear_animation.dart';
import 'models/message.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({Key? key}) : super(key: key);

  @override
  State createState() => _AnimationScreen();
}

class _AnimationScreen extends State {
  List<Message> msgs = [];
  bool isLoading = false;
  late bool isSpeaking;
  SpeechToTextContinuous stt = SpeechToTextContinuous.getInstance();
  late FlutterTts tts;
  Message? myMessage;
  GPT gpt = GPT();
  bool internetStatus = true;
  final BearAnimation _bearAnimation = BearAnimation();

  @override
  void initState() {
    super.initState();
    tts = FlutterTts();
    tts.awaitSpeakCompletion(true);
    isSpeaking = false;
    Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) async {
        print("Setting Internet State");
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color pageBackgroundColor = Colors.grey.shade300;
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: _bearAnimation.showAnimation(),
      floatingActionButton: FutureBuilder(
          future: InternetConnectionChecker().hasConnection,
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.hasData) {
              if (snap.data) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      if (isSpeaking) {
                        tts.stop();
                      } else {
                        stopAndStartListening();
                      }
                    });
                  },
                  icon: isSpeaking
                      ? const Icon(
                    Icons.stop_circle,
                    size: 32,
                  )
                      : isLoading
                      ? const CircularProgressIndicator()
                      : Icon(
                    SpeechToTextContinuous.getInstance().isListening
                        ? Icons.mic
                        : Icons.mic_off_outlined,
                    size: 32,
                  ),
                );
              } else {
                return const Text("Internet Not Connected");
              }
            } else {
              return const Text("Checking Internet Connection");
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void onResult(SpeechRecognitionResult result) async {
    setState(() {
      if (myMessage == null) {
        addUserMessage();
      }
      myMessage?.content = result.recognizedWords;
    });
  }

  void actionCall() async {
    if (myMessage == null) return;
    if (myMessage?.content == null) return;
    if (myMessage?.content == "") return;

    //Setting the loading indicator
    setState(() {
      isLoading = true;
    });
    await stopListening();

    //Trying to get response from openai
    String response = await gpt.askGPT(myMessage!.content);
    setState(() {
      msgs.add(Message(content: response, isMe: false));
      myMessage = null;
      isSpeaking = true;
      _bearAnimation.startTalkingAnimation();
    });

    await tts.speak(response);

    await startListening();
    setState(() {
      //setting loading indicator
      isLoading = false;
      isSpeaking = false;
      _bearAnimation.stopTalkingAnimation();
    });
  }

  void addUserMessage() {
    myMessage = Message(content: "", isMe: true);
    msgs.add(myMessage!);
  }

  //Listening Methods...
  void stopAndStartListening() {
    if (SpeechToTextContinuous.getInstance().isListening) {
      print("Stopping Listening");
      stopListening();
    } else {
      print("Starting Listening");
      startListening();
    }
  }

  Future<void> stopListening() async {
    await SpeechToTextContinuous.getInstance()
        .stopListening(forceDisableListening: true);
  }

  Future<void> startListening() async {
    await SpeechToTextContinuous.getInstance().startListening(
        onresult: onResult, continuous: true, notify: actionCall);
  }
}

