import 'package:flutter/material.dart';

class InputModel extends ChangeNotifier {
  Matrix4 matrix = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);

  void set(Matrix4 newMatrix) {
    matrix = newMatrix;
    notifyListeners();
  }

  double getEntry(int row, int column) {
    return matrix.entry(row, column);
  }

  void setEntry(int row, int column, double value) {
    matrix.setEntry(row, column, value);
    notifyListeners();
  }
}
