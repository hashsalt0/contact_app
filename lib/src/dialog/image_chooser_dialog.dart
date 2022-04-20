import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../home/contacts/add_edit_contacts/add_edit_contact_view_model.dart';
import '../values/strings.dart';

/// Widget for choosing image from gallery or camera
/// [_onImagePicked] is a callback when the user successfully
/// chooses the image from device
/// @see [ImagePicker]

class ImageChooserDialog extends StatelessWidget {
  const ImageChooserDialog({Key? key}) : super(key: key);

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
              Provider.of<AddEditContactViewModel>(context, listen: false)
                  .setContactPhoto(image);

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
              context.read<AddEditContactViewModel>().setContactPhoto(image);
            },
            label: const Text(Strings.labelGallery),
          )
        ],
      )),
    );
  }
}
