import 'package:flutter/material.dart';
import 'package:usegpt/home.dart';
import 'package:usegpt/speech_to_text_continuous/speech_to_text_continuous.dart';
import 'package:usegpt/testScreen.dart';

void main() {
  runApp(const MyApp());
  SpeechToTextContinuous.getInstance().init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
