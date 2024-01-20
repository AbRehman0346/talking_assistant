import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:usegpt/animations/bear_animation.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final BearAnimation _bearAnimation = BearAnimation();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          print("Gesture Detector is working");
          setState(() {
            _bearAnimation.toggleAnimation();
          });
        },

        child: _bearAnimation.showAnimation());
  }
}
