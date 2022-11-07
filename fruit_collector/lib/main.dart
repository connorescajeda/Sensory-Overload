import 'globals.dart' as globals;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'player.dart';
//import 'dart:html';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // https://pub.dev/packages/adaptive_theme#Changing-Theme-Mode

    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.red,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.red,
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
              title: 'Flutter Demo',
              theme: theme,
              darkTheme: darkTheme,
              home: const MyHomePage(
                title: 'Fruit Game',
              ),
            ));
  }
}

// https://docs.flutter.dev/cookbook/navigation/navigation-basics

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var highScore = globals.highScore;
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
            Container(
                padding: const EdgeInsets.only(bottom: 150),
                child:
                    //displaying the high score
                    Text(('High Score: ${highScore}'),
                        key: const Key("High Score Text"), textScaleFactor: 2)),
            TextButton(
                key: const Key("Game Button"),
                style: TextButton.styleFrom(
                  backgroundColor:
                      Colors.greenAccent, //backgroundColor: Colors.white,
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
          ],
        )),

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
                  AdaptiveTheme.of(context).setLight();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark Mode'),
                onTap: () {
                  AdaptiveTheme.of(context).setDark();

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
    setState(() => globals.timerDuration =
        Duration(seconds: 90)); //this starts the timer countdown
    globals.points =
        0; //sets points to 0 because if we're starting the timer we're restarting the game
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    print("high score: ${globals.highScore}");
    setState(() => countdownTimer!.cancel());
  }

  void dispose() {
    super.dispose();
    countdownTimer?.cancel();
  }

  void setCountDown() {
    //actually counting down the timer
    const reduceSecondsBy = 1;

    setState(() {
      final seconds = globals.timerDuration.inSeconds - reduceSecondsBy;
      if (seconds == 0) {
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
      key: const Key("Game"),
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
