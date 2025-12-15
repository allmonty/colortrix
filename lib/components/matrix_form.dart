import 'dart:math';

import 'package:colortrix/models/input_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatrixForm extends StatefulWidget {
  const MatrixForm({super.key});

  @override
  MatrixFormState createState() => MatrixFormState();
}

class MatrixFormState extends State<MatrixForm> {
  MatrixFormState();

  List<Color> colorsList = [Colors.red, Colors.green, Colors.blue];

  List<String> colorsText = ["R", "G", "B"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            SizedBox(
              width: 300,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorsList[i],
                    ),
                    child: Center(
                      child: Text(
                        colorsText[i],
                        textScaler: TextScaler.linear(1.5),
                      ),
                    ),
                  ),
                  for (var j = 0; j < 3; j++)
                    SizedBox(
                      width: 80,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: colorsList[j], width: 2),
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            barrierColor: Colors.transparent,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            builder: (_) =>
                                showModal(i, j, context.watch<InputModel>()),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              Provider.of<InputModel>(
                                context,
                              ).matrix.entry(i, j).toStringAsFixed(2),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Widget showModal(int i, int j, InputModel inputModel) {
  return StatefulBuilder(
    builder: (context, setState) {
      double value = inputModel.getEntry(i, j);
      String text = inputModel.getEntry(i, j).toStringAsFixed(2);

      return Container(
        height: 100,
        margin: EdgeInsets.only(
          bottom: max(
            MediaQuery.of(context).viewInsets.bottom,
            MediaQuery.of(context).viewPadding.bottom,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Slider(
                label: text,
                min: -1.0,
                max: 1.0,
                value: clampDouble(-1.0, value, 1.0),
                onChanged: (value) {
                  setState(() {
                    value = value < -0.02 || 0.02 < value ? value : 0.0;
                    text = value.toStringAsFixed(2);
                    inputModel.setEntry(i, j, value);
                  });
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
