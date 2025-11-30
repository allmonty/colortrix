import 'dart:math';

import 'package:colortrix/components/matrix_form.dart';
import 'package:colortrix/components/presets_list.dart';
import 'package:colortrix/components/reference_palette.dart';
import 'package:colortrix/models/input_model.dart';
import 'package:colortrix/components/preview_image_matrix_shader.dart';
import 'package:colortrix/models/image_model.dart';
import 'package:colortrix/components/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_container/tab_container.dart';

const String title = 'ColorTrix';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 42, 41, 42),
          brightness: Brightness.dark,
        ),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageModel()),
          ChangeNotifierProvider(create: (_) => InputModel()),
        ],
        child: const MyHomePage(title: title),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<InputModel>(context, listen: false).loadPresets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Container(
          margin: EdgeInsets.only(bottom: 13, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title),
              Consumer2<ImageModel, InputModel>(
                builder: (context, imageModel, inputModel, _) {
                  if (imageModel.texture != null) {
                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => imageModel.clear(),
                          child: Icon(Icons.clear),
                        ),
                        SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () => imageModel.download(
                            inputModel.matrix.transposed(),
                          ),
                          child: Icon(Icons.download),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Consumer2<ImageModel, InputModel>(
        builder: (context, imageModel, inputModel, _) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.95,
                ),
                child: imageModel.texture == null
                    ? ImageUploader()
                    : PreviewImageMatrixShader(),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        constraints: BoxConstraints.tight(
          Size(MediaQuery.of(context).size.width, 230),
        ),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(
          bottom: max(
            MediaQuery.of(context).viewInsets.bottom,
            MediaQuery.of(context).viewPadding.bottom,
          ),
        ),
        child: TabContainer(
          curve: Curves.easeInOut,
          tabEdge: TabEdge.bottom,
          tabBorderRadius: BorderRadius.circular(10),
          selectedTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.0,
          ),
          unselectedTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 13.0,
          ),
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface,
          ],
          childPadding: EdgeInsets.all(10),
          tabs: [Text("Matrix"), Text("Presets")],
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [MatrixForm(), SizedBox(width: 10), ReferencePalette()],
            ),
            Container(alignment: Alignment.center, child: PresetsList()),
          ],
        ),
      ),
    );
  }
}
