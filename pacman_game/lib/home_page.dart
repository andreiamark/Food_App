import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman_game/ghost.dart';
import 'package:pacman_game/path.dart';
import 'package:pacman_game/pixel.dart';
import 'package:pacman_game/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 15 + 1;
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    166,
    167,
    168,
    169,
    170,
    171,
    172,
    173,
    174,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    129,
    140,
    151,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149,
  ];

  List<int> food = [];
bool preGame = true;
bool mouthClosed = false;
int score = 0;
  String direction = "right";
bool paused = false;

  void startGame() {
    moveGhost();
    getFood();
    preGame = false;
    Timer.periodic(Duration(milliseconds: 190), (timer) {
      if (!paused) {
        moveGhost();
      }
    });
    Timer.periodic(Duration(milliseconds: 200), (timer){
      setState(() {
        mouthClosed = mouthClosed;
      });

      if (food.contains(player)){
        setState(() {
          food.remove(player);
        });
        score++;
      }
      if (player == ghost || ghost == player){
        player = -1;
        paused = true;
        showDialog(context: context, builder: (context) =>
            Column(
            children:[
              Container(
                padding: EdgeInsets.all(30),
                alignment: Alignment.center,
                child: Text('Game Over', style: TextStyle(decoration: TextDecoration.none),) ,),
              TextButton(
                onPressed: () {
                  restartGame();
                  } ,
                child: Text('Play Again', style: TextStyle(color: Colors.white, fontSize: 40),),),
            ]

              //Text('Game Over', style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
        ));
      }
      switch(direction) {
        case "left":
          moveLeft();
          break;
        case "right":
          moveRight();
          break;
        case "up":
          moveUp();
          break;
          case "down":
            moveDown();
          break;
      }
    });
   // getFood();
  }

void restartGame() {
  setState(() {
    player = numberInRow * 14 + 1;
    ghost = numberInRow * 2 - 2;
    paused = false;
    preGame = false;
    mouthClosed = false;
    direction = "left";
    food.clear();
    getFood();
    score = 0;
    Navigator.pop(context);
  });


}
void getFood(){
    for(int i=0; i<numberOfSquares; i++ ){
      if(!barriers.contains(i)){
        food.add(i);
      }
    }
}
  void moveLeft() {
    if(!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
  }
  }
  void moveRight() {
    if(!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
  }
  }
  void moveUp() {
    if(!barriers.contains(player - numberInRow)) {
    setState(() {
      player -= numberInRow;
    });
    }
  }

  void moveDown() {
    if(!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }
  int ghost = numberInRow * 2 - 2;
  String ghostDirection = "left";

  void moveGhost() {
    switch (ghostDirection) {
      case "left":
        if (!barriers.contains(ghost - 1)) {
          setState(() {
            ghost--;
          });
        } else {
          if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostDirection = "down";
            });
          } else if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostDirection = "right";
            });
          } else if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostDirection = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost + 1)) {
          setState(() {
            ghost++;
          });
        } else {
          if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostDirection = "up";
            });
          } else if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostDirection = "down";
            });
          } else if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostDirection = "left";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost - numberInRow)) {
          setState(() {
            ghost -= numberInRow;
            ghostDirection = "up";
          });
        } else {
          if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostDirection = "right";
            });
          } else if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostDirection = "left";
            });
          } else if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostDirection = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost + numberInRow)) {
          setState(() {
            ghost += numberInRow;
            ghostDirection = "down";
          });
        } else {
          if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostDirection = "left";
            });
          } else if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostDirection = "right";
            });
          } else if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostDirection = "up";
            });
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
             flex: 5,
              child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if(details.delta.dy > 0){
                  direction = "down";
                } else if(details.delta.dy < 0){
                  direction = "up";
                }
              },
                  onHorizontalDragUpdate: (details) {
                    if(details.delta.dx > 0){
                      direction = "right";
                    } else if(details.delta.dx < 0){
                      direction = "left";
                    }
                    print(direction);
                  },
              child: Container(
               child: GridView.builder(
                 physics: NeverScrollableScrollPhysics(),
                 itemCount: numberOfSquares,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: numberInRow),
                   itemBuilder: (BuildContext context, int index) {
                   if (mouthClosed && player == index) {
                     return Padding(
                         padding: EdgeInsets.all(4),
                      child: Container(
                       decoration: BoxDecoration(
                         color: Colors.yellow,
                         shape: BoxShape.circle,
                       ),
                     ));
                   } else if(player == index){
                       switch(direction) {
                         case "left":
                           Transform.rotate(angle: pi, child: MyPlayer(),);
                           break;
                         case "right":
                           break;
                        case "up":
                          Transform.rotate(angle: pi/2, child: MyPlayer(),);
                         break;
                         case "down":
                           Transform.rotate(angle: 3*pi/2, child: MyPlayer(),);
                           break;
                         default: return MyPlayer();
                       }
                     }  else if (ghost == index) {
                          return MyGhost();}
                   else if(barriers.contains(index)){
                      return MyPixel(
                        // child: Text(index.toString()),
                         innerColor: Colors.blue[800],
                        outerColor: Colors.blue[900],
                       );
                     } else if(preGame || food.contains(index)){
                       return  MyPath(
                         //child: Text(index.toString()),
                         innerColor: Colors.yellow,
                         outerColor: Colors.black,
                       );
                     } else {
                          return MyPath(
                          innerColor: Colors.black,
                          outerColor: Colors.black,
                          );
                          }return MyPlayer();
                 }
                 )
          )
          ),),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('score: ' + score.toString(), style: TextStyle(color: Colors.white, fontSize: 40),),
                  GestureDetector(
                    onTap: startGame,
                      child: Text("PLAY", style: TextStyle(color: Colors.white, fontSize: 40))),
                ],
              ),
          ),
          )
        ],
      ),
    );
  }
}
