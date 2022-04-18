import 'dart:typed_data';

import 'package:contact_app/src/dialog/image_chooser_dialog.dart';
import 'package:contact_app/src/repo/contact_model.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:contact_app/src/utils/validations.dart';
import 'package:contact_app/src/values/keys.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import '../../values/strings.dart';

/// Screen for adding contacts
class AddEditContactsPage extends StatefulWidget {
  static String tag = 'add-edit-contact-page';

  final ContactModel? _contact;

  const AddEditContactsPage({Key? key, ContactModel? contactModel})  : _contact = contactModel,  super(key: key);

  @override
  _AddEditContactPageState createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactsPage> {
  final _formKey = GlobalKey<FormState>();
  final _contactFirstName = TextEditingController();
  final _contactLastName = TextEditingController();
  final _contactPhoneNumber = MaskedTextController(mask: '0000-0000');

  Uint8List? _contactPhoto;
  String appTitle = Strings.addContactPageTitle;

  @override
  void initState() {
    beforeChange(_contactPhoneNumber);
    initializeFormFields();
    super.initState();
  }

  void initializeFormFields() {
    ContactModel? contact = widget._contact;
    if(contact != null){
      _contactPhoto = contact.avatar;
      _contactFirstName.text = contact.firstName;
      _contactLastName.text = contact.lastName;
      _contactPhoneNumber.text = contact.phoneNumber;
      appTitle = Strings.editContactPageTitle;
    }
  }

  /// Formats the phone number field as (xx) xxxx xxxx
  void beforeChange(MaskedTextController controller) {
    controller.beforeChange = (previous, next) {
      final unmasked = next.replaceAll(RegExp(r'[^0-9\+]'), '');
      if (unmasked.length <= 8) {
        controller.updateMask('0000-0000', shouldMoveCursorToEnd: false);
      } else if (unmasked.length <= 9) {
        controller.updateMask('00000-0000', shouldMoveCursorToEnd: false);
      } else if (unmasked.length <= 10) {
        controller.updateMask('(00) 0000-0000', shouldMoveCursorToEnd: false);
      } else if (unmasked.length <= 11) {
        controller.updateMask('(000) 00000-0000', shouldMoveCursorToEnd: false);
      } else if (unmasked.length <= 12) {
        controller.updateMask('(000) 00000-00000',
            shouldMoveCursorToEnd: false);
      }
      return true;
    };
  }

  @override
  Widget build(BuildContext context) {

    TextFormField inputFirstName = TextFormField(
        key: Keys.inputFirstNameKey,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(45)],
        controller: _contactFirstName,
        autofocus: true,
        decoration: const InputDecoration(
            labelText: Strings.firstNameLabel, icon: Icon(Icons.person)),
        validator: Validations.nameValidation);

    TextFormField inputLastName = TextFormField(
        key: Keys.inputLastNameKey,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(45)],
        controller: _contactLastName,
        decoration: const InputDecoration(
            labelText: Strings.lastNameLabel, icon: Icon(Icons.person)),
        validator: Validations.nameValidation);

    TextFormField inputPhoneNumber = TextFormField(
      key: Keys.inputPhoneNumberKey,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]*'))],
      controller: _contactPhoneNumber,
      maxLength: 16,
      validator: (_) {
        return Validations.phoneNumberValidation(_contactPhoneNumber.unmasked);
      },
      decoration: const InputDecoration(
        labelText: Strings.phoneNumberLabel,
        icon: Icon(Icons.phone),
      ),
    );

    final picture = SizedBox(
        width: 120.0,
        height: 120.0,
        child: GestureDetector(
          onTap: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    ImageChooserDialog(onImagePick: _onImagePick));
          },
          child: CircleAvatar(
              child: ImageWithPlaceholderIcon(
                  key: Keys.avatarKey, image: _contactPhoto)),
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
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(appTitle),
        actions: <Widget>[
          SizedBox(
            width: 80,
            child: IconButton(
              icon: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _submitFormAndPopBack,
            ),
          )
        ],
      ),
      body: content,
    );
  }

  Future<void> _onImagePick(image) async {
    Uint8List photo = await image.readAsBytes();
    setState(() {
      _contactPhoto = photo;
    });
  }

  /// creates/updates a contact by validating and submitting form data;
  /// pop back to previous screen
  void _submitFormAndPopBack() async {
    if (_formKey.currentState?.validate() == true) {
      ContactModel? contact = widget._contact;
      if (contact != null) {
        /// Contact is provided as argument so updating
        _updateContact(contact);
      } else {
        _addNewContact();
      }
      Navigator.pop(context);
    }
  }

  void _addNewContact() {
    ServiceLocator.instance.contactsRepository.addContact(
        firstName: _contactFirstName.text,
        lastName: _contactLastName.text,
        phoneNumber: _contactPhoneNumber.unmasked,
        avatar: _contactPhoto);
  }

  void _updateContact(ContactModel contact) {
    contact.avatar = _contactPhoto;
    contact.firstName = _contactFirstName.text;
    contact.lastName = _contactLastName.text;
    contact.phoneNumber = _contactPhoneNumber.unmasked;
    contact.save();
  }
}

class ImageWithPlaceholderIcon extends StatelessWidget {
  const ImageWithPlaceholderIcon({
    Key? key,
    required Uint8List? image,
  })  : _image = image,
        super(key: key);

  final Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return ExtendedImage.memory(_image!,
          width: 100,
          height: 100,
          fit: BoxFit.fill,
          shape: BoxShape.circle,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)));
    } else {
      return const Icon(Icons.add);
    }
  }
}
