import 'package:colortrix/l10n/generated/app_localizations.dart';
import 'package:colortrix/models/image_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageUploader extends StatelessWidget {
  ImageUploader({super.key});

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageModel>(
      builder: (context, model, child) {
        return SizedBox(
          height: 300,
          width: 300,
          child: ElevatedButton(
            onPressed: () => showModalBootomImagePicker(context, model),
            child: Text(AppLocalizations.of(context)!.image_upload__title),
          ),
        );
      },
    );
  }

  void showModalBootomImagePicker(BuildContext context, ImageModel? model) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.image_upload__library),
                onTap: () {
                  _imgFromGallery(model!);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text(AppLocalizations.of(context)!.image_upload__camera),
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
    await picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        model.set(value);
      }
    });
  }

  void _imgFromGallery(ImageModel model) async {
    // Pick an image from gallery.
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        model.set(value);
      }
    });
  }
}
