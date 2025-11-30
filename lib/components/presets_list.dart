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

  @override
  Widget build(BuildContext context) {
    final imageModel = Provider.of<ImageModel>(context);
    final inputModel = Provider.of<InputModel>(context);

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: imageModel.texture != null
          ? Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
                  onPressed: () => inputModel.savePreset(),
                  child: Icon(Icons.add, size: 50),
                ),
                for (int i = 0; i < inputModel.presets.length; i++)
                  MaterialButton(
                    onLongPress: () => inputModel.removePreset(i),
                    onPressed: () =>
                        inputModel.set(inputModel.presets[i].transposed()),
                    child: ImageShaderPreview(
                      texture: imageModel.texture!,
                      configuration: ColorMatrixShaderConfiguration()
                        ..colorMatrix = inputModel.presets[i]
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
