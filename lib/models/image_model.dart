import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

class ImageModel extends ChangeNotifier {
  TextureSource? texture;

  void clear() {
    texture = null;
    notifyListeners();
  }

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

  Future<void> download(Matrix4 matrix) async {
    if (kIsWeb) {
      return;
    } else if (Platform.isAndroid || Platform.isIOS) {
      await _downloadMobile(matrix);
    }
  }

  Future<void> _downloadMobile(Matrix4 matrix) async {
    await Gal.requestAccess();

    final image = await textureAsImage(matrix);
    if (image == null) return;

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      await Gal.putImageBytes(byteData.buffer.asUint8List());
    }
  }
}
