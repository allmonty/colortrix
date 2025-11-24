import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image_picker/image_picker.dart';

class ImageModel extends ChangeNotifier {
  TextureSource? texture;

  void set(XFile file) async {
    if (file.path.isEmpty) return;

    await TextureSource.fromMemory(
      await file.readAsBytes(),
    ).then((value) => texture = value).whenComplete(() => notifyListeners());
  }

  Future<ui.Image?> textureAsImage(Matrix4 matrix) async {
    ColorMatrixShaderConfiguration configuration;
    configuration = ColorMatrixShaderConfiguration();
    configuration.colorMatrix = matrix;
    configuration.intensity = 1.0;

    if (texture == null) return Future.value(null);

    ui.Image image = await configuration.export(texture!, texture!.size);
    return image;
  }
}
