import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mario_game/button.dart';
import 'package:mario_game/shrooms.dart';
import 'button.dart';
import 'jumpingMario.dart';
import 'mario.dart';

class MyHomePage extends StatefulWidget {



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  double marioX = 0;
  static double marioY = 1;
  double marioSize = 50;
  double shroomY = 1;
  double shroomX = 0.5;
  double time = 0;
  double height = 0;
  double initialHeight = marioY;
  String direction = "right";
  bool midrun = false;
  bool midjump = false;

  void preJump() {
    time = 0;
    initialHeight = marioY;
  }

  void ateShrooms() {
    if ((marioX-shroomX).abs() < 0.05 && (marioY - shroomY).abs() < 0.05)
      setState(() {
        shroomX = 2;
        marioSize = 100;
      });
  }

  void jump() {
  if (midjump == false){
    midjump = true;
    preJump();
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 5 * time;
      if ((initialHeight - height) > 1){
        midjump = false;
        setState(() {
          marioY = 1;
        });
        timer.cancel();
      } else {
        setState (() {
          marioY = initialHeight - height;
        });
     }
    });
  }
  }

  void moveRight() {
    midrun = !midrun;
    ateShrooms();
    direction = "right";
    Timer.periodic(Duration(milliseconds: 50 ), (timer) {
      ateShrooms();
      if(MyButton.userIsHoldingButton() == true && marioX + 0.02 < 1) {
        setState(() {
          marioX += 0.02;
           midrun = !midrun;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void moveLeft() {
    midrun = !midrun;
    ateShrooms();
    direction = "left";
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      ateShrooms();
     if(MyButton.userIsHoldingButton() == true && marioX - 0.02 > -1){
        setState(() {
          marioX -= 0.02;
          midrun = !midrun;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
              child: Stack(
                children: [
                  Container(
                    color: Colors.blue,
                    child: AnimatedContainer(
                      alignment: Alignment(marioX,marioY),
                      duration: Duration(milliseconds: 0),
                      child: midjump ? JumpingMario(
                        direction: direction,
                        size: marioSize,
                      ) :
                      MyMario(
                        direction: direction,
                        midrun: midrun,
                        size: marioSize,
                      ),
                    ),
                  ),
                 Container(
                   alignment: Alignment(shroomX, shroomY),
                   child: MyShroom(),
                 ),
                 Padding(
                     padding: EdgeInsets.only(top: 10.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Column(
                         children: [
                           Text("Mario"),
                           Text("0000")
                         ],
                       ),
                       Column(
                         children: [
                           Text("World"),
                           Text("1-1")
                         ],
                       ),
                       Column(
                         children: [
                           Text("Time"),
                           Text("9999")
                         ],
                       )
                     ],
                   ),
                 ),
                ],
              )
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    child: Icon(Icons.arrow_back, color: Colors.white,),
                    function: () {moveLeft();},
                  ),
                 MyButton(
                    child: Icon(Icons.arrow_upward, color: Colors.white),
                   function: jump,
                  ),
                  MyButton(
                    child: Icon(Icons.arrow_forward,color: Colors.white),
                    function: moveRight,
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
