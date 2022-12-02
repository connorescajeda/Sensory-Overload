// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;
import 'package:fruit_collector/main.dart';
import 'package:fruit_collector/player.dart';
import 'package:fruit_collector/globals.dart' as globals;

void main() {
//This test makes sure that the home page loads up correctly
  testWidgets('Home Page Loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    final homePageFinder = find.text("Fruit Game");

    expect(homePageFinder, findsOneWidget);
  });

//This test ensures that clicking the play button will take you to the next page
  testWidgets('Button takes you to game screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    final buttonFinder = find.byKey(const Key("Game Button"));

    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle(const Duration(milliseconds: 4000));

    final gameScreenFinder = find.byKey(const Key("Game Screen"));

    expect(gameScreenFinder, findsOneWidget);
  });

//This test ensures hitting the timer starts the game
  testWidgets('Game timer starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    final buttonFinder1 = find.byKey(const Key("Game Button"));

    await tester.tap(buttonFinder1);
    await tester.pumpAndSettle(const Duration(milliseconds: 4000));

    final timerFinder = find.text('Time Remaining: 00');

    final buttonFinder2 = find.byKey(const Key("Start Button"));

    expect(buttonFinder2, findsOneWidget);

    await tester.tap(buttonFinder2);
    await tester.pumpAndSettle(const Duration(milliseconds: 4000));

    expect(timerFinder, findsNothing);
  });

// This test ensures that the game starts when a player clicks the timer button
  testWidgets('Game timer starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    final buttonFinder1 = find.byKey(const Key("Game Button"));

    await tester.tap(buttonFinder1);
    await tester.pumpAndSettle(const Duration(milliseconds: 4000));

    final timerFinder = find.text('Time Remaining: 00');

    final buttonFinder2 = find.byKey(const Key("Start Button"));

    expect(buttonFinder2, findsOneWidget);

    await tester.tap(buttonFinder2);
    await tester.pumpAndSettle(const Duration(milliseconds: 4000));

    expect(timerFinder, findsNothing);
  });

// This test replicates a player moving
  test('Player Movement', () {
    final player = Player();
    final player_s = PlayerState(
        player.rows, player.columns, player.cellSize, player.fruitAmount);
    final game_s = GameState(player.rows, player.columns, player.fruitAmount);

    expect(game_s.body, <math.Point<int>>[const math.Point<int>(0, 0)]);

    game_s.step(const math.Point<int>(1, 0));

    expect(game_s.body, <math.Point<int>>[const math.Point<int>(1, 0)]);
  });

//This test uses player movement along with collecting a fruit and adding it to the score.
  test('Fruit Collection', () {
    final player = Player();
    final gameS = GameState(player.rows, player.columns, player.fruitAmount);

    gameS.body = <math.Point<int>>[const math.Point<int>(2, 2)];
    gameS.checkCollision();

    expect(globals.points, 1);
  });

  testWidgets('High Score', (WidgetTester tester) async {
    //for some reason, this requires to be run on its own instead of all the tests at once.

    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    //high score starts at 0
    expect(globals.highScore, 0);

    //high points score should set a new high score
    final player = Player();
    final gameS = GameState(player.rows, player.columns, player.fruitAmount);

    gameS.body = <math.Point<int>>[const math.Point<int>(2, 2)];
    gameS.checkCollision();
    expect(globals.points, 1);
    expect(globals.highScore, 1);
    await tester.pump();

    //this high score is independent of points in other rounds
    globals.points = 0;
    await tester.pump();
    expect(globals.highScore, 1);
  });

  testWidgets('High Score Display', (WidgetTester tester) async {
    // tests if the high score is displayed correctly

    // given a high score of 3
    globals.highScore = 3;

    //builds and tests display
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));
    expect(find.byKey(const Key("High Score Text")), findsOneWidget);
    expect(find.text("High Score: 3"), findsOneWidget);
  });
}
