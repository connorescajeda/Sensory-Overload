//import 'dart:html';

import 'globals.dart' as globals;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fruit Game'),
    );
  }
}

// https://docs.flutter.dev/cookbook/navigation/navigation-basics

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'placeholder',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          globals.timerDuration = Duration(seconds: 0);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GameScreen()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  //State<GameScreen> createState() => _GameScreenState();
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int _fruitRows = 40;
  static const int _fruitColumns = 30;
  static const double _fruitCellSize = 10.0;

  double x = 0, y = 0, z = 0;
  String direction = "none";

// //https://www.flutterbeads.com/flutter-countdown-timer/#:~:text=Steps%20to%20add%20countdown%20timer,()%20to%20stop%20the%20timer.
  Timer? countdownTimer;

  //Duration timerDuration = Duration(seconds: 60);
  bool flag = false;
  void startTimer() {
<<<<<<<
    setState(() => globals.timerDuration = Duration(seconds: 30));
    globals.points = 0;
=======
    setState(() => globals.timerDuration =
        Duration(seconds: 90)); //this starts the timer countdown
    globals.points =
        0; //sets points to 0 because if we're starting the timer we're restarting the game
>>>>>>>
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void setCountDown() {
    //actually counting down the timer
    const reduceSecondsBy = 1;

    setState(() {
      final seconds = globals.timerDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        stopTimer();
      } else {
        globals.timerDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    //goadrich snake sensor demo

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = strDigits(globals.timerDuration.inSeconds.remainder(90));
    final pointTotal = globals.points;
    Player game = Player(
      rows: _fruitRows,
      columns: _fruitColumns,
      cellSize: _fruitCellSize,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Gyroscope Sensor in Flutter"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: startTimer,
                      child: const Text(
                        'Start!',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Time Remaining: $seconds'),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black38),
                    ),
                    child: SizedBox(
                      height: _fruitRows * _fruitCellSize,
                      width: _fruitColumns * _fruitCellSize,
                      child: game,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Points: $pointTotal'),
                    ],
                  ),
                ),
              ])),
    );
  }
}
