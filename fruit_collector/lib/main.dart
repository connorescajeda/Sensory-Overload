import 'globals.dart' as globals;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'player.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
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
              title: 'Fruit Game!',
              theme: theme,
              darkTheme: darkTheme,
              home: MyHomePage(),
            ));
  }
}

// https://docs.flutter.dev/cookbook/navigation/navigation-basics

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeMode themeMode = ThemeMode.system;

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // THIS VARIABLE SHOULD UPDATE THE HIGH SCORE BUT IT'S NOT RELOADING!
    var highScore = globals.highScore;

    TextStyle titleTextStyle = const TextStyle(
        color: Color.fromARGB(255, 83, 218, 153),
        fontWeight: FontWeight.bold,
        fontSize: 24.0);
    Color redColor = const Color.fromARGB(255, 239, 79, 79);
    Color greenColor = const Color.fromARGB(255, 83, 218, 153);

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Fruit Game!", style: titleTextStyle),
          backgroundColor: redColor,
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
                    Text(('High Score: $highScore'),
                        key: const Key("High Score Text"), textScaleFactor: 2)),
            TextButton(
                key: const Key("Game Button"),
                style: TextButton.styleFrom(
                  backgroundColor: greenColor,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameScreen(
                            key: const Key("Game Screen"), onreload: reload)),
                  );
                },
                child: const Text(
                  'PLAY',
                  style: TextStyle(color: Colors.white, fontSize: 60),
                )),
          ],
        )),

        //https://docs.flutter.dev/cookbook/design/drawer
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: redColor,
                ),
                child: Text('App Preferences',
                    style: TextStyle(color: greenColor, fontSize: 40)),
              ),
              ListTile(
                title: const Text('Light Mode', style: TextStyle(fontSize: 20)),
                onTap: () {
                  AdaptiveTheme.of(context).setLight();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark Mode', style: TextStyle(fontSize: 20)),
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

typedef HotReload = Function();

// ignore: must_be_immutable
class GameScreen extends StatefulWidget {
  GameScreen({Key? key, required this.onreload}) : super(key: key);

  final HotReload onreload;

  Color redColor = const Color.fromARGB(255, 239, 79, 79);
  Color greenColor = const Color.fromARGB(255, 83, 218, 153);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
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
        const Duration(seconds: 20)); //this starts the timer countdown
    globals.points =
        0; //sets points to 0 because if we're starting the timer we're restarting the game
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    // printing here gives an ACCURATE update when game is over
    print("high score after timer stops: ${globals.highScore}");
    setState(() => countdownTimer!.cancel());
    widget.onreload();
  }

  @override
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //goadrich snake sensor demo

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = strDigits(globals.timerDuration.inSeconds.remainder(90));
    final pointTotal = globals.points;

    TextStyle titleTextStyle = const TextStyle(
        color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 24.0);

    Color redColor = const Color.fromARGB(255, 239, 79, 79);
    Color greenColor = const Color.fromARGB(255, 83, 218, 153);

    // printing high score here gives ACCURATE updates every second.
    //print("high score: ${globals.highScore}");

    Player game = Player(
      key: const Key("Game"),
      rows: _fruitRows,
      columns: _fruitColumns,
      cellSize: _fruitCellSize,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Get That Fruit!", style: titleTextStyle),
        backgroundColor: greenColor,
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
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
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              key: const Key("seconds"),
                              'Time Remaining: $seconds',
                              style: const TextStyle(fontSize: 22)),
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
