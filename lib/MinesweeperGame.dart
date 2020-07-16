import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:minesweeper/components/GameBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinesweeperGame extends Game with TapDetector {
  Size screenSize;
  double tileSize;
  int rows;
  int columns;
  int mines;
  GameBoard gameBoard;
  final SharedPreferences storage;

  MinesweeperGame(this.storage) {
    initialize();
  }

  void initialize() async {
    rows = 30;
    columns = 16;
    mines = 100;

    resize(await Flame.util.initialDimensions());
    gameBoard = GameBoard(this, rows, columns, mines);
  }

  void render(Canvas canvas) {
    gameBoard.render(canvas);
  }

  void update(double t) {}

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 16;
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    if (isHandled) return;

    isHandled = gameBoard.onTapDown(d);
  }
}
