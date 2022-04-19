import 'package:contact_app/src/dialog/image_chooser_dialog.dart';
import 'package:contact_app/src/home/contacts/add_edit_contacts/add_edit_contact_view_model.dart';
import 'package:contact_app/src/utils/validations.dart';
import 'package:contact_app/src/values/keys.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../values/strings.dart';
import 'image_with_placeholder_icon.dart';

/// Screen for adding contacts
class AddEditContactsPage extends StatelessWidget {
  static String tag = 'add-edit-contact-page';

  static final _formKey = GlobalKey<FormState>();

  const AddEditContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddEditContactViewModel model =
        Provider.of<AddEditContactViewModel>(context);

    final phoneNumberController = MaskedTextController(
        mask: '0000-0000',
        text: context.watch<AddEditContactViewModel>().contact.phoneNumber);

    phoneNumberController.beforeChange = (previous, next) {
      final unmasked = next.replaceAll(RegExp(Strings.digitsRegex), '');
      phoneNumberController.updateMask(
          Strings.phoneNumberMasks[unmasked.length] ?? Strings.defaultPhoneMask,
          shouldMoveCursorToEnd: false);
      return true;
    };

    TextFormField inputFirstName = TextFormField(
        key: Keys.inputFirstNameKey,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(45)],
        onChanged: model.setFirstName,
        controller: TextEditingController(
            text: context.watch<AddEditContactViewModel>().contact.firstName),
        autofocus: true,
        decoration: const InputDecoration(
            labelText: Strings.firstNameLabel, icon: Icon(Icons.person)),
        validator: Validations.nameValidation);

    TextFormField inputLastName = TextFormField(
        key: Keys.inputLastNameKey,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(45)],
        onChanged: model.setLastName,
        controller: TextEditingController(
            text: context.watch<AddEditContactViewModel>().contact.lastName),
        decoration: const InputDecoration(
            labelText: Strings.lastNameLabel, icon: Icon(Icons.person)),
        validator: Validations.nameValidation);

    TextFormField inputPhoneNumber = TextFormField(
      key: Keys.inputPhoneNumberKey,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]*'))],
      onChanged: model.setPhoneNumber,
      controller: phoneNumberController,
      maxLength: 16,
      validator: (_) =>
          Validations.phoneNumberValidation(phoneNumberController.unmasked),
      decoration: const InputDecoration(
        labelText: Strings.phoneNumberLabel,
        icon: Icon(Icons.phone),
      ),
    );

    final picture = SizedBox(
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        child: GestureDetector(
          onTap: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) => const ImageChooserDialog());
          },
          child:
              const CircleAvatar(child: UserAvatarWidget(key: Keys.avatarKey)),
        ));

    ListView content = ListView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      children: <Widget>[
        const SizedBox(height: 20),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              picture,
              inputFirstName,
              inputLastName,
              inputPhoneNumber
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(context.watch<AddEditContactViewModel>().title),
        actions: <Widget>[
          SizedBox(
            width: 80,
            child: IconButton(
              icon: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                _submitFormAndPopBack(context, model);
              },
            ),
          )
        ],
      ),
      body: content,
    );
  }

  /// creates/updates a contact by validating and submitting form data;
  /// pop back to previous screen
  void _submitFormAndPopBack(
      BuildContext context, AddEditContactViewModel model) {
    if (_formKey.currentState?.validate() == true) {
      if (model.submit()) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(Strings.updateContactSuccessMessage)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(Strings.createdContactSuccessMessage)));
      }
      Navigator.pop(context);
    }
  }
}
