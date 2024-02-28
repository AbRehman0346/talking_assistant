import 'package:rive/rive.dart';
import "package:flutter/material.dart";
import 'package:usegpt/constants.dart';

class BearAnimation{
  final RiveAnimationController _talkAnimation = SimpleAnimation("Talk");
  final RiveAnimationController _idleAnimation = SimpleAnimation("idle");

  @override
  Widget showAnimation() {
    return RiveAnimation.asset(ProjectPaths.bearOneAnimationPath, controllers: [_talkAnimation, _idleAnimation],
    onInit: (Artboard artboard) => stopTalkingAnimation(),
      placeHolder: const Center(child: Text("Loading...", style: TextStyle(fontSize: 28),)),
    );
  }

  void stopTalkingAnimation(){
    _talkAnimation.isActive = false;
    _idleAnimation.isActive = true;
  }

  void startTalkingAnimation(){
    _talkAnimation.isActive = true;
    _idleAnimation.isActive = false;
  }

  void toggleAnimation(){
    _talkAnimation.isActive = !_talkAnimation.isActive;
    _idleAnimation.isActive = !_idleAnimation.isActive;
  }
}
