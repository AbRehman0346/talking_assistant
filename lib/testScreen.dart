import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State createState() => _TestScreen();
}

class _TestScreen extends State {
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Screen"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    print("Second Passed");
                  });
                },
                child: const Text("Subscribe")),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  timer.cancel();
                },
                child: const Text("UnSubscribe")),
          ],
        ),
      ),
    );
  }
}
