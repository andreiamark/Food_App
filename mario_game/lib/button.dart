import 'dart:async';

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final child;
  final function;
  static bool isStillHolding = false;
  static bool shouldCancelTimer = false;
  static bool holdingButton = false;
  MyButton({required this.child, required this.function});

  static bool userIsHoldingButton() {
    return holdingButton;
  }
  bool isUserHoldingButton(){
    return holdingButton;
  }

  void checkButton(){

    shouldCancelTimer = false;

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      isStillHolding = false;
      if(shouldCancelTimer){
        timer.cancel();
      }
    });

    Timer.periodic(Duration(milliseconds: 800), (timer) {
      if(!isStillHolding){
        holdingButton = false;
        shouldCancelTimer = true;
        timer.cancel();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details){
        holdingButton = true;
        isStillHolding = true;
        checkButton();
        function();
      },
      onTapUp: (details){
        holdingButton = false;
        isStillHolding = false;
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.brown[300],
            child: child,
          ),
        ),
      ),
    );
  }
}