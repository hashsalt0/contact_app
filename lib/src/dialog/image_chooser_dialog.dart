import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../values/strings.dart';

/// Widget for choosing image from gallery or camera
/// [_onImagePicked] is a callback when the user successfully
/// chooses the image from device
/// @see [ImagePicker]

class ImageChooserDialog extends StatelessWidget {
  final Future<void> Function(XFile image) _onImagePicked;

  const ImageChooserDialog(
      {Key? key, required Future<void> Function(XFile image) onImagePick})
      : _onImagePicked = onImagePick,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: SizedBox(
          height: 300.0,
          width: 300.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: IconButton(
                    iconSize: 90,
                    icon: const Icon(
                      Icons.camera_alt,
                      semanticLabel: Strings.labelCamera,
                    ),
                    onPressed: () {
                      _pickImageAndPopBack(
                          context: context,
                          picker: picker,
                          source: ImageSource.camera);
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                    iconSize: 90,
                    icon: const Icon(
                      Icons.browse_gallery_rounded,
                      semanticLabel: Strings.labelGallery,
                    ),
                    onPressed: () {
                      _pickImageAndPopBack(
                          context: context,
                          picker: picker,
                          source: ImageSource.gallery);
                    }),
              )
            ],
          )),
    );
  }

  /// helper function to call [ImagePicker] to browse for image and pop back
  /// to the previous screen
  void _pickImageAndPopBack(
      {required BuildContext context,
      required ImagePicker picker,
      required ImageSource source}) async {
    XFile? image = await picker.pickImage(source: source);
    Navigator.of(context).pop();
    await _onImagePicked(image!);
  }
}
