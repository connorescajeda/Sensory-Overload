// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_collector/fruit.dart';
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

    await tester
        .pumpWidget(const MaterialApp(home: MyHomePage(title: "Fruit Game")));

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
    await tester
        .pumpWidget(const MaterialApp(home: MyHomePage(title: "Fruit Game")));

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
    await tester
        .pumpWidget(const MaterialApp(home: MyHomePage(title: "Fruit Game")));

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
    final player_s = PlayerState(
        player.rows, player.columns, player.cellSize, player.fruitAmount);
    final game_s = GameState(player.rows, player.columns, player.fruitAmount);

    game_s.body = <math.Point<int>>[const math.Point<int>(2, 2)];
    game_s.checkCollision();

    expect(globals.points, 1);
  });
}
