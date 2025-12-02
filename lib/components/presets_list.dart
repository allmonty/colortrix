import 'package:colortrix/l10n/generated/app_localizations.dart';
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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(debugLabel: "PresetsListScrollController");
  }

  @override
  Widget build(BuildContext context) {
    final imageModel = Provider.of<ImageModel>(context);

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: imageModel.texture != null
          ? Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
                  onPressed: () {
                    context.read<InputModel>().savePreset();
                    setState(() {});
                  },
                  child: Icon(Icons.add, size: 50),
                ),
                for (int i = 0; i < Provider.of<InputModel>(context, listen: false).presets.length; i++)
                  MaterialButton(
                    onLongPress: () {
                      context.read<InputModel>().removePreset(i);
                      setState(() {});
                    },
                    onPressed: () =>
                        context.read<InputModel>().set(context.read<InputModel>().presets[i].transposed()),
                    child: ImageShaderPreview(
                      texture: imageModel.texture!,
                      configuration: ColorMatrixShaderConfiguration()
                        ..colorMatrix = context.read<InputModel>().presets[i]
                        ..intensity = 1.0,
                      fix: BoxFit.contain,
                    ),
                  ),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!.presets__disabled_message),
            ),
    );
  }
}
