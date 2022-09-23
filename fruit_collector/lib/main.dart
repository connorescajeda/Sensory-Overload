//import 'dart:html';

import 'dart:html';

import 'globals.dart' as globals;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:animated_background/animated_background.dart';
import 'player.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Fruit Game'),
    );
  }
}

// https://docs.flutter.dev/cookbook/navigation/navigation-basics

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

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
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  key: const Key("Game Button"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GameScreen(
                                key: Key("Game Screen"),
                              )),
                    );
                  },
                  child: Text(
                    'PLAY',
                    style: Theme.of(context).textTheme.headlineLarge,
                  )),
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //     image: NetworkImage(
                    //         "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/9aaaf7a6-b1a5-40a3-8eb8-02712a91a568/dcyp8zl-e675430f-2807-4d7f-b4bd-acaf945ec0a9.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzlhYWFmN2E2LWIxYTUtNDBhMy04ZWI4LTAyNzEyYTkxYTU2OFwvZGN5cDh6bC1lNjc1NDMwZi0yODA3LTRkN2YtYjRiZC1hY2FmOTQ1ZWMwYTkucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.LQXDkZsOdq9kCEB55QYXnfeplFcHyoqeWxHA_C2S7ik"),
                    //     fit: BoxFit.cover),
                    ),
              ),
            ],
          ),
        ),

        //https://docs.flutter.dev/cookbook/design/drawer
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Text('App Preferences'),
              ),
              ListTile(
                title: const Text('Light Mode'),
                onTap: () {
                  theme:
                  ThemeData(
                    brightness: Brightness.light,
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark Mode'),
                onTap: () {
                  theme:
                  ThemeData(
                    brightness: Brightness.dark,
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
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
    setState(() => globals.timerDuration = Duration(seconds: 30));
    globals.points = 0;
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }
  void dispose() {
    super.dispose();
    countdownTimer?.cancel();
    
  }

  void setCountDown() {
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
        title: Text("Get That Fruit!"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: [
                    ElevatedButton(
                      key: const Key("Start Button"),
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
                          Text(
                              key: const Key("seconds"),
                              'Time Remaining: $seconds'),
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
