import 'package:flutter/material.dart';

enum Status { matrixInput, presets }

class TabControlModel extends ChangeNotifier {
  Status status = Status.matrixInput;

  void set(Status newStatus) async {
    status = newStatus;
    notifyListeners();
  }
}
