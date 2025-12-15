import 'package:colortrix/models/input_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A widget that displays a reference palette showing the effect of the
/// current color transformation matrix on a set of predefined colors.
class ReferencePalette extends StatelessWidget {
  const ReferencePalette({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 0, 255, 0),
      Color.fromARGB(255, 0, 0, 255),
      Color.fromARGB(255, 255, 0, 255),
      Color.fromARGB(255, 0, 255, 255),
      Color.fromARGB(255, 255, 255, 0),
    ];

    return Consumer<InputModel>(
      builder: (context, inputModel, child) => SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
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
      ),
    );
  }
}
