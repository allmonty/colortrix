import 'dart:math';
import 'dart:ui' as ui;

import 'package:colortrix/components/matrix_form.dart';
import 'package:colortrix/models/input_model.dart';
import 'package:colortrix/components/preview_image_matrix_shader.dart';
import 'package:colortrix/models/image_model.dart';
import 'package:colortrix/components/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:provider/provider.dart';

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
          seedColor: const Color.fromARGB(255, 38, 0, 104),
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
                  return ElevatedButton(
                    onPressed: () async {
                      await Gal.requestAccess();
                      final image = await imageModel.textureAsImage(
                        inputModel.matrix.transposed(),
                      );
                      if (image == null) return;

                      final byteData = await image.toByteData(
                        format: ui.ImageByteFormat.png,
                      );
                      if (byteData != null) {
                        await Gal.putImageBytes(byteData.buffer.asUint8List());
                      }
                    },
                    child: Icon(Icons.download),
                  );
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    padding: EdgeInsets.all(10),
                    child: imageModel.texture == null
                        ? ImageUploader(model: imageModel)
                        : PreviewImageMatrixShader(
                            imageModel: imageModel,
                            inputModel: inputModel,
                          ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MatrixForm(),
                      SizedBox(width: 10),
                      buildReferencePalette(inputModel),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        height: max(
          MediaQuery.of(context).viewInsets.bottom,
          MediaQuery.of(context).viewPadding.bottom,
        ),
      ),
    );
  }

  Widget buildReferencePalette(InputModel inputModel) {
    List<Color> colors = [
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 0, 255, 0),
      Color.fromARGB(255, 0, 0, 255),
      Color.fromARGB(255, 255, 0, 255),
      Color.fromARGB(255, 0, 255, 255),
      Color.fromARGB(255, 255, 255, 0),
    ];

    return SizedBox(
      height: 150,
      child: Column(
        children: [
          for (Color color in colors)
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  width: 20,
                  height: 20,
                ),
                Icon(Icons.arrow_forward),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(
                      255,
                      ((color.r * inputModel.matrix[0] +
                                  color.g * inputModel.matrix[1] +
                                  color.b * inputModel.matrix[2]) *
                              255)
                          .toInt(),
                      ((color.r * inputModel.matrix[4] +
                                  color.g * inputModel.matrix[5] +
                                  color.b * inputModel.matrix[6]) *
                              255)
                          .toInt(),
                      ((color.r * inputModel.matrix[8] +
                                  color.g * inputModel.matrix[9] +
                                  color.b * inputModel.matrix[10]) *
                              255)
                          .toInt(),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
