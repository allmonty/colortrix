import 'package:colortrix/models/image_model.dart';
import 'package:colortrix/models/input_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:provider/provider.dart';

// A widget that displays a preview of the image with the color matrix shader applied.
class PreviewImageMatrixShader extends StatefulWidget {
  const PreviewImageMatrixShader({super.key});

  @override
  State<PreviewImageMatrixShader> createState() =>
      _PreviewImageMatrixShaderState();
}

class _PreviewImageMatrixShaderState extends State<PreviewImageMatrixShader> {
  late ColorMatrixShaderConfiguration configuration;
  bool enabled = true;

  @override
  void initState() {
    super.initState();
    configuration = ColorMatrixShaderConfiguration();
    configuration.colorMatrix = Matrix4.identity();
    configuration.intensity = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ImageModel, InputModel>(
      builder: (context, imageModel, inputModel, _) {
        configuration.colorMatrix = enabled
            ? inputModel.matrix.transposed()
            : Matrix4.identity();

        return GestureDetector(
          onTapUp: (_) {
            setState(() {
              enabled = true;
            });
          },
          onTapDown: (_) {
            setState(() {
              enabled = false;
            });
          },
          child: imageModel.texture != null
              ? ImageShaderPreview(
                  texture: imageModel.texture!,
                  configuration: configuration,
                  fix: BoxFit.contain,
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
