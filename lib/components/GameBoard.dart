import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:minesweeper/MinesweeperGame.dart';
import 'package:minesweeper/components/Cell.dart';
import 'package:tuple/tuple.dart';

class GameBoard {
  List<List<Cell>> board;
  MinesweeperGame game;
  final int rows;
  final int columns;
  final int mines;
  Random rnd;
  bool isFirstTap = true;

  final List<int> drow = [1, 1, 1, 0, 0, -1, -1, -1];
  final List<int> dcol = [-1, 0, 1, -1, 1, -1, 0, 1];

  GameBoard(this.game, this.rows, this.columns, this.mines) {
    rnd = Random();

    board = List<List<Cell>>();
    for (int i = 0; i < rows; i++) {
      board.add(List<Cell>());
      for (int j = 0; j < columns; j++) {
        board[i].add(Cell(game, i, j));
      }
    }
  }

  void initializeBoard(int initialRow, int initialColumn) {
    isFirstTap = false;

    // sort mine placement
    var matrix = List<Tuple2<int, int>>();
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        matrix.add(Tuple2(i, j));
      }
    }

    matrix.shuffle(rnd);

    for (int i = 0, curMines = 0; curMines < mines; i++) {
      int row = matrix[i].item1;
      int col = matrix[i].item2;

      if ((row - initialRow).abs() <= 1 && (col - initialColumn).abs() <= 1)
        continue;
      curMines++;
      board[row][col].setMine();
    }

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        if (board[i][j].isMine()) continue;
        int qtt = 0;
        for (int k = 0; k < drow.length; k++) {
          int ni = i + drow[k];
          int nj = j + dcol[k];

          if (ni >= 0 &&
              ni < rows &&
              nj >= 0 &&
              nj < columns &&
              board[ni][nj].isMine()) qtt++;
        }
        board[i][j].setValue(qtt);
      }
    }
  }

  void render(Canvas c) {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++) {
        board[i][j].render(c);
      }
  }

  Cell getCellByPosition(Offset position) {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        if (board[i][j].cellRect.contains(position)) {
          return board[i][j];
        }

    return null;
  }

  bool onTapDown(TapDownDetails d) {
    Cell tappedCell = getCellByPosition(d.globalPosition);

    if (tappedCell == null) return false;

    int row = tappedCell.row;
    int column = tappedCell.column;

    if (isFirstTap) {
      initializeBoard(row, column);
    }

    var Q = Queue<Tuple2<int, int>>();
    Q.add(Tuple2(row, column));
    tappedCell.onTapDown();

    while (Q.isNotEmpty) {
      Tuple2<int, int> vertex = Q.removeFirst();

      if (board[vertex.item1][vertex.item2].value != 0) continue;

      for (int k = 0; k < drow.length; k++) {
        int ni = vertex.item1 + drow[k];
        int nj = vertex.item2 + dcol[k];

        if (ni >= 0 &&
            ni < rows &&
            nj >= 0 &&
            nj < columns &&
            board[ni][nj].hidden) {
          board[ni][nj].onTapDown();
          Q.add(Tuple2(ni, nj));
        }
      }
    }

    return true;
  }
}
