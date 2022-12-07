import 'dart:math';

import 'package:flutter/material.dart';


class MyMario extends StatelessWidget {
  final direction;
  final midrun;
  final size;

  MyMario({required this.direction, required this.midrun, required this.size});

  @override
  Widget build(BuildContext context) {
    if (direction == "right"){
    return Container(
      width: 50,
      height: 50,
      child: midrun
              ? Image.asset('lib/images/right.png')
              : Image.asset('lib/images/mario.png'),
    );
  } else {
      return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Container(
              width: 50,
              height: 50,
              child: midrun
              ? Image.asset('lib/images/mario.png')
               : Image.asset('lib/images/mario.png')
          ),
      );

    }
    }
}
