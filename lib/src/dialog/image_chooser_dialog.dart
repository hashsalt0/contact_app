import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../values/strings.dart';

/// Widget for choosing image from gallery or camera
/// [_onImagePicked] is a callback when the user successfully
/// chooses the image from device
/// @see [ImagePicker]

class ImageChooserDialog extends StatelessWidget {
  final Function(XFile image) onImagePicked;

  const ImageChooserDialog({Key? key, required this.onImagePicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: SizedBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: const Icon(
              Icons.camera_alt,
              semanticLabel: Strings.labelCamera,
            ),
            onPressed: () async {
              XFile? image = await picker.pickImage(source: ImageSource.camera);
              Navigator.of(context).pop();
              onImagePicked(image!);
            },
            label: const Text(Strings.labelCamera),
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.browse_gallery_rounded,
              semanticLabel: Strings.labelGallery,
            ),
            onPressed: () async {
              XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              Navigator.of(context).pop();
              onImagePicked(image!);
            },
            label: const Text(Strings.labelGallery),
          )
        ],
      )),
    );
  }
}
