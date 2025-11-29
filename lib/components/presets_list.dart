import 'package:colortrix/models/image_model.dart';
import 'package:colortrix/models/input_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:provider/provider.dart';

class PresetsList extends StatefulWidget {
  const PresetsList({super.key});

  @override
  PresetsListState createState() => PresetsListState();
}

class PresetsListState extends State<PresetsList> {
  final ScrollController scrollController = ScrollController();

  List<String> get presetNames => ['Sepia', 'Grayscale'];

  List<Matrix4> get presets => [
    // Sepia matrix example
    Matrix4(
      0.393,
      0.769,
      0.189,
      0, //
      0.349,
      0.686,
      0.168,
      0, //
      0.272,
      0.534,
      0.131,
      0, //
      0,
      0,
      0,
      1,
    ),
    Matrix4(
      0.299,
      0.587,
      0.114,
      0, //
      0.299,
      0.587,
      0.114,
      0, //
      0.299,
      0.587,
      0.114,
      0, //
      0,
      0,
      0,
      1, //
    ),
    Matrix4(
      1,
      0,
      0,
      0, //
      0,
      0,
      1,
      0, //
      0,
      1,
      0,
      0, //
      0,
      0,
      0,
      1, //
    ),
    Matrix4(
      0.75,
      0.60,
      0.05,
      0, //
      0.05,
      0.10,
      0.85,
      0, //
      0.35,
      0.65,
      0,
      0, //
      0,
      0,
      0,
      1, //
    ),
    Matrix4(
      0.92,
      0.30,
      0.02,
      0, //
      0.03,
      0.70,
      0.27,
      0, //
      0.15,
      0.45,
      0.80,
      0, //
      0,
      0,
      0,
      1, //
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final imageModel = Provider.of<ImageModel>(context);
    final inputModel = Provider.of<InputModel>(context, listen: false);

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: imageModel.texture != null
          ? Row(
              children: [
                for (int i = 0; i < presets.length; i++)
                  MaterialButton(
                    onPressed: () => inputModel.set(presets[i].transposed()),
                    child: ImageShaderPreview(
                      texture: imageModel.texture!,
                      configuration: ColorMatrixShaderConfiguration()
                        ..colorMatrix = presets[i]
                        ..intensity = 1.0,
                      fix: BoxFit.contain,
                    ),
                  ),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: const Text("Pick image to show presets"),
            ),
    );
  }
}
