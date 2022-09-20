import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Player extends StatefulWidget {
  Player({Key? key, this.rows = 20, this.columns = 20, this.cellSize = 10.0})
      : super(key: key) {
    assert(10 <= rows);
    assert(10 <= columns);
    assert(5.0 <= cellSize);
  }

  final int rows;
  final int columns;
  final double cellSize;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => PlayerState(rows, columns, cellSize);
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
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, size.bottomLeft(Offset.zero)),
      blackLine,
    );
    for (final p in state!.body) {
      final a = Offset(cellSize * p.x, cellSize * p.y);
      final b = Offset(cellSize * (p.x + 1), cellSize * (p.y + 1));

      canvas.drawRect(Rect.fromPoints(a, b), blackFilled);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PlayerState extends State<Player> {
  PlayerState(int rows, int columns, this.cellSize) {
    state = GameState(rows, columns);
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
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acceleration = event;
      });
    });

    subscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      print(event);

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

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _step();
      });
    });
  }

  //   _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
  //     setState(() {
  //       _step();
  //     });
  //   });
  // }

  void _step() {
    math.Point<int> newDirection = const math.Point<int>(0, 0);
    bool flag = direction == pastDir;
    if (direction == "back") {
      newDirection = const math.Point<int>(0, 1);
    } else if (direction == "forward") {
      newDirection = const math.Point<int>(0, -1);
    } else if (direction == "left") {
      newDirection = const math.Point<int>(1, 0);
    } else if (direction == "right") {
      newDirection = const math.Point<int>(-1, 0);
    }
    state!.step(newDirection);
  }

//   void _step() {
//     final newDirection = acceleration == null
//         ? null
//         : acceleration!.x.abs() < 1.0 && acceleration!.y.abs() < 1.0
//             ? null
//             : (acceleration!.x.abs() < acceleration!.y.abs())
//                 ? math.Point<int>(0, acceleration!.y.sign.toInt())
//                 : math.Point<int>(-acceleration!.x.sign.toInt(), 0);
//     state!.step(newDirection);
//   }
}

class GameState {
  GameState(this.rows, this.columns) {
    playerLength = 1;
  }

  int rows;
  int columns;
  late int playerLength;

  List<math.Point<int>> body = <math.Point<int>>[const math.Point<int>(0, 0)];
  math.Point<int> direction = const math.Point<int>(1, 0);

  void step(math.Point<int>? newDirection) {
    var next = body.last + direction;
    next = math.Point<int>(next.x % columns, next.y % rows);

    body.add(next);
    if (body.length > playerLength) body.removeAt(0);
    direction = newDirection ?? direction;
  }
}