import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputModel extends ChangeNotifier {
  Matrix4 matrix = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);

  List<Matrix4> presets = [
    Matrix4(
      0, 1, 0, 0,
      1, 0, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1),
    Matrix4(
      0, 0, 1, 0,
      0, 1, 0, 0,
      1, 0, 0, 0,
      0, 0, 0, 1),
    Matrix4(
      1, 0, 0, 0,
      0, 0, 1, 0,
      0, 1, 0, 0,
      0, 0, 0, 1),
    Matrix4(
      0.75, 0.60, 0.05, 0,
      0.05, 0.10, 0.85, 0,
      0.35, 0.65, 0.00, 0,
      0,    0,    0,    1,
    ),
    Matrix4(
      0.92, 0.30, 0.02, 0,
      0.03, 0.70, 0.27, 0,
      0.15, 0.45, 0.80, 0,
      0, 0, 0, 1,
    ),
    Matrix4(
      0.393, 0.769, 0.189, 0,
      0.349, 0.686, 0.168, 0,
      0.272, 0.534, 0.131, 0,  
      0,     0,     0,     1,),
    Matrix4(
      0.299, 0.587, 0.114, 0,
      0.299, 0.587, 0.114, 0,
      0.299, 0.587, 0.114, 0,
      0,     0,     0,     1,),
  ];

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

  void loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('presets') ?? [];
    final loadedPresets = list.map((s) {
      final values = (jsonDecode(s) as List)
          .map((e) => (e as num).toDouble())
          .toList();
      return Matrix4.fromList(values);
    }).toList();
    presets = loadedPresets.isEmpty ? presets : loadedPresets;
    notifyListeners();
  }

  void savePreset() async {
    presets.insert(0, matrix.transposed());
    _savePresets();
    notifyListeners();
  }

  void removePreset(int index) async {
    presets.removeAt(index);
    _savePresets();
    notifyListeners();
  }

  void _savePresets() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = presets
        .map((m) => jsonEncode(m.storage.toList()))
        .toList();
    await prefs.setStringList('presets', serialized);
  }
}
