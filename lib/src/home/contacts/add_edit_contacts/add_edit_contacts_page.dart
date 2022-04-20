import 'package:contact_app/src/dialog/image_chooser_dialog.dart';
import 'package:contact_app/src/home/contacts/add_edit_contacts/add_edit_contact_view_model.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:contact_app/src/utils/validations.dart';
import 'package:contact_app/src/values/keys.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../repo/contact_state.dart';
import '../../../values/strings.dart';
import 'avatar_widget.dart';

/// Screen for adding contacts
class AddEditContactsPage extends StatelessWidget {
  static String tag = 'add-edit-contact-page';

  static final _formKey = GlobalKey<FormState>();

  const AddEditContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddEditContactViewModel model =
        Provider.of<AddEditContactViewModel>(context);

    ContactState contact = model.contact;
    final phoneNumberController = MaskedTextController(
        mask: Strings.phoneNumberMasks[contact.phoneNumber.length] ??
            Strings.defaultPhoneMask,
        text: contact.phoneNumber);

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
        controller: TextEditingController(text: contact.firstName),
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
        controller: TextEditingController(text: contact.lastName),
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
        title: Text(model.title),
        actions: <Widget>[
          SizedBox(
              width: 80,
              child: MaterialButton(
                onPressed: () {
                  _submitFormAndPopBack(context, model);
                },
                elevation: 0,
                child: const Text(Strings.save),
              ))
        ],
      ),
      body: content,
    );
  }

  /// creates/updates a contact by validating and submitting form data;
  /// pop back to previous screen
  void _submitFormAndPopBack(
      BuildContext context, AddEditContactViewModel model) async {
    if (_formKey.currentState?.validate() == true) {
      try {
        /// Message to be show to user
        String message = await model.submit();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } catch (e, stackTrace) {
        ServiceLocator.instance.logger.e(e);
        ServiceLocator.instance.logger.e(stackTrace);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(Strings.fatalErrorMessage)));
      }
      Navigator.pop(context);
    }
  }
}
