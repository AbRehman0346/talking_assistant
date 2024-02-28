import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:o3d/o3d.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:usegpt/general_functions.dart';
import 'package:usegpt/speech_to_text_continuous/speech_to_text_continuous.dart';
import 'gpt/gpt.dart';
import 'models/message.dart';

class O3DTalkingAnimation extends StatefulWidget {
  const O3DTalkingAnimation({super.key});

  @override
  State<O3DTalkingAnimation> createState() => _O3DTalkingAnimationState();
}

class _O3DTalkingAnimationState extends State<O3DTalkingAnimation> {
  O3DController controller = O3DController();
  List<Message> msgs = [];
  bool isLoading = false;
  late bool isSpeaking;
  SpeechToTextContinuous stt = SpeechToTextContinuous.getInstance();
  late FlutterTts tts;
  Message? myMessage;
  GPT gpt = GPT();
  bool internetStatus = true;
  Color iconColor = Colors.white;
  String speakingText = "";
  GeneralFunctions _generalFunctions = GeneralFunctions();

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
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          O3D.asset(
            src: "assets/animations/readyToUseAnimatedModel.glb",
            cameraControls: false,
            controller: controller,
            cameraOrbit: CameraOrbit(0, 90, 0.5),
            cameraTarget: CameraTarget(0, 1.5, -1),
            animationName: "talking",
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                isSpeaking ? speakingText : myMessage?.content ?? "",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
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
                      ? Icon(
                          Icons.stop_circle,
                          size: 32,
                          color: iconColor,
                        )
                      : isLoading
                          ? const CircularProgressIndicator()
                          : Icon(
                              SpeechToTextContinuous.getInstance().isListening
                                  ? Icons.mic
                                  : Icons.mic_off_outlined,
                              size: 32,
                              color: iconColor,
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
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        controller.play();
      });
    });

    tts.setProgressHandler((text, start, end, word) {
      setState(() {
        if (speakingText.length > 50){
          speakingText = "";
        }
        speakingText += "$word ";

      });
    });
    await tts.speak(response);

    speakingText = "";

    await startListening();
    setState(() {
      //setting loading indicator
      isLoading = false;
      isSpeaking = false;
      controller.pause();
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
