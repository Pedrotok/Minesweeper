import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:minesweeper/MinesweeperGame.dart';

class Cell {
  bool hidden;
  Sprite hiddenSprite;
  Sprite trueSprite;
  int value;
  final int row, column;
  Rect cellRect;
  MinesweeperGame game;

  Cell(this.game, this.row, this.column) {
    hidden = true;
    cellRect = Rect.fromLTWH(this.column * game.tileSize,
        this.row * game.tileSize, game.tileSize, game.tileSize);
    hiddenSprite = Sprite('MINESWEEPER_X.png');
  }

  void render(Canvas c) {
    if (hidden)
      hiddenSprite.renderRect(c, cellRect);
    else
      trueSprite.renderRect(c, cellRect);
  }

  void update(double t) {}

  void setMine() {
    setValue(-1);
  }

  void setValue(int value) {
    this.value = value;
    if (value == -1)
      trueSprite = Sprite('MINESWEEPER_M.png');
    else
      trueSprite = Sprite('MINESWEEPER_$value.png');
  }

  bool isMine() {
    return value == -1;
  }

  void onTapDown() {
    if (hidden) {
      hidden = false;
    }
  }
}
