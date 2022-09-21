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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
              onTap: (){

                Navigator.pop(context);
              } ,
            ),

            ListTile(
              title: const Text('Dark Mode'),
              onTap: (){
                theme: ThemeData(
                  primarySwatch: Colors.grey,
                  primaryColor: Colors.blue,
                  brightness: Brightness.dark,

                );
                 
                Navigator.pop(context);
              },
            ),
          ],


        ),
      ),
    );
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
