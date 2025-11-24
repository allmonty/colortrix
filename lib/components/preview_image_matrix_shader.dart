import 'package:colortrix/models/image_model.dart';
import 'package:colortrix/models/input_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

class PreviewImageMatrixShader extends StatefulWidget {
  final ImageModel? imageModel;
  final InputModel? inputModel;

  const PreviewImageMatrixShader({super.key, this.imageModel, this.inputModel});

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
    configuration.colorMatrix = enabled
        ? widget.inputModel!.matrix.transposed()
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
      child: widget.imageModel!.texture != null
          ? ImageShaderPreview(
              texture: widget.imageModel!.texture!,
              configuration: configuration,
              fix: BoxFit.contain,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
