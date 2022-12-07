import 'package:flutter/material.dart';

class MyPlayer extends StatefulWidget {
  const MyPlayer({Key? key}) : super(key: key);

  @override
  State<MyPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
    child:Image.asset('lib/images/pacman.png') ,);
  }
}
