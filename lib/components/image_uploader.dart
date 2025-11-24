import 'package:colortrix/models/image_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageUploader extends StatelessWidget {
  ImageUploader({super.key, this.model});

  final ImagePicker picker = ImagePicker();

  final ImageModel? model;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: SizedBox(
        height: 300,
        width: 300,
        child: ElevatedButton(
          onPressed: () => showModalBootomImagePicker(context),
          child: Text("Image Picker"),
        ),
      ),
    );
  }

  void showModalBootomImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _imgFromGallery(model!);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _imgFromCamera(model!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _imgFromCamera(ImageModel model) async {
    // Capture a photo from camera.
    await picker
        .pickImage(source: ImageSource.camera)
        .then((value) => model.set(value!));
  }

  void _imgFromGallery(ImageModel model) async {
    // Pick an image from gallery.
    await picker
        .pickImage(source: ImageSource.gallery)
        .then((value) => model.set(value!));
  }
}
