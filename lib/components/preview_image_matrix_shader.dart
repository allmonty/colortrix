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

        return Container(
          alignment: Alignment.center,
          child: imageModel.texture != null
              ? GestureDetector(
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxW = constraints.maxWidth.isFinite && constraints.maxWidth > 0
                          ? constraints.maxWidth
                          : MediaQuery.of(context).size.width;
                      final maxH = constraints.maxHeight.isFinite && constraints.maxHeight > 0
                          ? constraints.maxHeight
                          : MediaQuery.of(context).size.height;

                      final aspect = imageModel.texture!.aspectRatio;
                      // Compute a finite size that fits within available space while keeping aspect.
                      double width = maxW;
                      double height = width / aspect;
                      if (height > maxH) {
                        height = maxH;
                        width = height * aspect;
                      }

                      return InteractiveViewer(
                        boundaryMargin: const EdgeInsets.all(20.0),
                        minScale: 0.5,
                        maxScale: 5.0,
                        child: SizedBox(
                          width: maxW,
                          height: maxH,
                          child: Center(
                            child: SizedBox(
                              width: width,
                              height: height,
                              child: ImageShaderPreview(
                                texture: imageModel.texture!,
                                configuration: configuration,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}