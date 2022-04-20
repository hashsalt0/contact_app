import 'package:contact_app/src/home/contacts/add_edit_contacts/add_edit_contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/lazy_image_widget.dart';

/// used in add contact page to show avatar
class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddEditContactViewModel model = context.watch<AddEditContactViewModel>();
    return LazyImageWidget(
        image: model.contact.avatar,
        fallbackWidget: const Icon(
          Icons.face,
          size: 100,
        ));
  }
}
