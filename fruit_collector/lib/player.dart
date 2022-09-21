import 'dart:async';
import 'dart:ffi' as prefix;
import 'dart:math' as math;
import 'dart:math';
import 'globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fruit_collector/fruit.dart';

class Player extends StatefulWidget {
  Player(
      {Key? key,
      this.rows = 20,
      this.columns = 20,
      this.cellSize = 10.0,
      this.fruitAmount = 6})
      : super(key: key) {
    assert(10 <= rows);
    assert(10 <= columns);
    assert(5.0 <= cellSize);
  }

  final int rows;
  final int columns;
  final double cellSize;
  final int fruitAmount;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() =>
      PlayerState(rows, columns, cellSize, fruitAmount);
}

class PlayerBoardPainter extends CustomPainter {
  PlayerBoardPainter(this.state, this.cellSize);

  GameState? state;
  double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final blackLine = Paint()..color = Colors.black;
    final blackFilled = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final fruitFilled = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    state?.fruitCreation();

    canvas.drawRect(
      Rect.fromPoints(Offset.zero, size.bottomLeft(Offset.zero)),
      blackLine,
    );
    for (final p in state!.body) {
      final a = Offset(cellSize * p.x, cellSize * p.y);
      final b = Offset(cellSize * (p.x + 1), cellSize * (p.y + 1));

      canvas.drawRect(Rect.fromPoints(a, b), blackFilled);
    }
    for (final p in state!.fruits) {
      final a = Offset(cellSize * p.x, cellSize * p.y);
      final b = Offset(cellSize * (p.x + 1), cellSize * (p.y + 1));

      canvas.drawRect(Rect.fromPoints(a, b), fruitFilled);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PlayerState extends State<Player> {
  PlayerState(int rows, int columns, this.cellSize, int fruitAmount) {
    state = GameState(rows, columns, fruitAmount);
  }

  double cellSize;
  GameState? state;
  AccelerometerEvent? acceleration;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;
  late Timer _timer;
  late StreamSubscription<GyroscopeEvent> subscription;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: PlayerBoardPainter(state, cellSize));
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    _timer.cancel();
  }

  String direction = "none";
  String pastDir = "none";
  double x = 0, y = 0, z = 0;

  @override
  void initState() {
    super.initState();

    subscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      //print(event);

      //rough calculation, you can use
      //advance formula to calculate the orentation
      if (x > 0) {
        direction = "back";
        pastDir = direction;
      } else if (x < 0) {
        direction = "forward";
        pastDir = direction;
      } else if (y > 0) {
        direction = "left";
        pastDir = direction;
      } else if (y < 0) {
        direction = "right";
        pastDir = direction;
      } else if (x == 0) {
        direction = pastDir;
      }

      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
    if (globals.timerDuration.inSeconds < 0) {
      subscription.pause();
    }
    if (subscription.isPaused && globals.timerDuration.inSeconds > 0) {
      subscription.resume();
    }

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _step();
        if (state!.fruits.length < 4) {}
      });
    });
  }

  void _step() {
    math.Point<int> newDirection = const math.Point<int>(0, 0);

    if (direction == "back") {
      newDirection = const math.Point<int>(0, 1);
    } else if (direction == "forward") {
      newDirection = const math.Point<int>(0, -1);
    } else if (direction == "left") {
      newDirection = const math.Point<int>(1, 0);
    } else if (direction == "right") {
      newDirection = const math.Point<int>(-1, 0);
    }

    final seconds = globals.timerDuration.inSeconds;

    if (seconds < 1) {
      newDirection = const math.Point<int>(0,
          0); //if the game time has run out, the player object is unable to move
    }

    state!.step(newDirection);
  }
}

class GameState {
  GameState(this.rows, this.columns, this.fruitAmount) {
    playerLength = 1;
  }

  int rows;
  int columns;
  late int playerLength;
  int fruitAmount;
  var rand = math.Random();
  List<Fruit> fruits = <Fruit>[Fruit(const math.Point<int>(2, 2))];
  List<math.Point<int>> body = <math.Point<int>>[const math.Point<int>(0, 0)];
  math.Point<int> direction = const math.Point<int>(1, 0);

  void step(math.Point<int>? newDirection) {
    var next = body.last + direction;
    next = math.Point<int>(next.x % columns, next.y % rows);

    body.add(next);
    if (body.length > playerLength) body.removeAt(0);
    direction = newDirection ?? direction;
    checkCollision();
  }

  void fruitCreation() {
    if (fruits.length < 4) {
      for (var i = 0; i < fruitAmount; i++) {
        Fruit tmp =
            Fruit(math.Point<int>(rand.nextInt(columns), (rand.nextInt(rows))));
        fruits.add(tmp);
      }
    }
  }

  void checkCollision() {
    //This method checks to see if the player has collided or "ran over" a fruit
    List<int> fruitX = [];
    List<int> fruitY = [];

    for (var i = 0; i < fruits.length; i++) {
      //this makes two lists containing the x and y's of each fruit
      fruitX.add(fruits.elementAt(i).x);
      fruitY.add(fruits.elementAt(i).y);
    }
    //print("test");
    for (var j = 0; j < fruitX.length; j++) {
      if (fruitX.elementAt(j) == body.elementAt(0).x &&
          fruitY.elementAt(j) == body.elementAt(0).y) {
        globals.points += 1;
        fruits.removeAt(j);
        //matches the current x,y of the player's body
      }
    }
  }
}
