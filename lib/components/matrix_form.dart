import 'dart:math';

import 'package:colortrix/models/input_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatrixForm extends StatefulWidget {
  const MatrixForm({super.key});

  @override
  MatrixFormState createState() => MatrixFormState();
}

class MatrixFormState extends State<MatrixForm> {
  MatrixFormState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 150,
      child: Column(
        children: [
          for (var i = 0; i < 3; i++)
            SizedBox(
              width: 300,
              height: 50,
              child: Row(
                children: [
                  for (var j = 0; j < 3; j++)
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        child: Text(
                          Provider.of<InputModel>(
                            context,
                          ).matrix.entry(i, j).toStringAsFixed(2),
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
        height: 200,
        padding: EdgeInsets.only(
          bottom: max(
            MediaQuery.of(context).viewInsets.bottom,
            MediaQuery.of(context).viewPadding.bottom,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Slider(
                min: -1,
                value: min(1, value),
                onChanged: (value) {
                  setState(() {
                    value = value;
                    inputModel.setEntry(i, j, value);
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: TextEditingController.fromValue(
                  TextEditingValue(text: text),
                ),
                onChanged: (newValue) {
                  setState(() {
                    value = double.tryParse(newValue) ?? 0.0;
                    text = value.toStringAsFixed(2);
                  });
                  inputModel.setEntry(i, j, double.tryParse(newValue) ?? 0.0);
                },
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    },
  );
}
