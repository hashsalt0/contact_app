import 'dart:typed_data';

import 'package:contact_app/src/home/contacts/add_edit_contacts/add_edit_contact_view_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List? contactPhoto =
        context.watch<AddEditContactViewModel>().contact.avatar;
    if (contactPhoto != null) {
      return ExtendedImage.memory(contactPhoto,
          height: MediaQuery.of(context).size.width * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          fit: BoxFit.fill,
          shape: BoxShape.circle,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)));
    } else {
      return const Icon(
        Icons.face,
        size: 100,
      );
    }
  }
}
