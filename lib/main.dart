import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/MinesweeperGame.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setPortrait();

  Flame.images.loadAll(<String>[
    'MINESWEEPER_0.png',
    'MINESWEEPER_1.png',
    'MINESWEEPER_2.png',
    'MINESWEEPER_3.png',
    'MINESWEEPER_4.png',
    'MINESWEEPER_5.png',
    'MINESWEEPER_6.png',
    'MINESWEEPER_7.png',
    'MINESWEEPER_8.png',
    'MINESWEEPER_C.png',
    'MINESWEEPER_F.png',
    'MINESWEEPER_M.png',
    'MINESWEEPER_X.png',
  ]);

  var storage = await SharedPreferences.getInstance();

  var game = MinesweeperGame(storage);
  runApp(game.widget);
}
