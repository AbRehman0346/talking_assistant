import 'package:flutter/material.dart';
import 'package:usegpt/home.dart';
import 'package:usegpt/o3d_animation.dart';
import 'package:usegpt/speech_to_text_continuous/speech_to_text_continuous.dart';
import 'package:usegpt/test.dart';
import 'package:usegpt/testScreen.dart';
import "./animation_screen.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  runApp(const MyApp());
  SpeechToTextContinuous.getInstance().init();
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnimationScreen(),
    );
  }
}
