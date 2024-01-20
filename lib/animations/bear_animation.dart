import 'package:rive/rive.dart';
import "package:flutter/material.dart";

class BearAnimation{
  final String _animationPath = "assets/animations/bear_wave_hear_talk.riv";
  final RiveAnimationController _talkAnimation = SimpleAnimation("Talk");
  // final RiveAnimationController _idleAnimation = SimpleAnimation("idle");

  @override
  Widget showAnimation() {
    return RiveAnimation.asset(_animationPath, controllers: [_talkAnimation],
    onInit: (Artboard artboard) => stopTalkingAnimation(),
    );
  }

  void stopTalkingAnimation(){
    _talkAnimation.isActive = false;
    // _idleAnimation.isActive = true;
  }

  void startTalkingAnimation(){
    _talkAnimation.isActive = true;
    // _idleAnimation.isActive = false;
  }

  void toggleAnimation(){
    _talkAnimation.isActive = !_talkAnimation.isActive;
    // _idleAnimation.isActive = !_idleAnimation.isActive;
  }
}
