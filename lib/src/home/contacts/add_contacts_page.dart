import 'dart:io';

import 'package:contact_app/src/dialog/image_chooser_dialog.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:contact_app/src/utils/validations.dart';
import 'package:contact_app/src/values/keys.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../values/strings.dart';

/// Screen for adding contacts
class AddContactsPage extends StatefulWidget {
  static String tag = 'add-contact-page';

  const AddContactsPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddContactsPage> {
  final _formKey = GlobalKey<FormState>();
  final _contactFirstName = TextEditingController();
  final _contactLastName = TextEditingController();
  final _contactPhoneNumber = MaskedTextController(mask: '0000-0000');

  XFile? _contactPhoto;

  @override
  void initState() {
    beforeChange(_contactPhoneNumber);
    _askPermissions(null);
    super.initState();
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
                    ImageChooserDialog(onImagePick: (image) {
                      setState(() {
                        _contactPhoto = image;
                      });
                    }));
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
        title: const Text(Strings.addContactPageTitle),
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

  /// creates a contact by validating and submitting form data;
  /// pop back to previous screen
  void _submitFormAndPopBack() async {
    if (_formKey.currentState?.validate() == true) {
      PermissionStatus permissionStatus = await _getContactPermission();
      if (permissionStatus.isGranted) {
        ServiceLocator.instance.contactsRepository.addContact(
            firstName: _contactFirstName.text,
            lastName: _contactLastName.text,
            phoneNumber: _contactPhoneNumber.unmasked,
            avatar: _contactPhoto);
        Navigator.pop(context);
      } else {
        _handleInvalidPermissions(permissionStatus);
      }
    }
  }

  /// ask for permission and the navigates to another screen as specified by [routeName]
  Future<void> _askPermissions(String? routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (routeName != null) {
        Navigator.of(context).pushNamed(routeName);
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  /// Retrieves the contact permission status
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  /// Handles [PermissionStatus] when it is denied by showing a snackbar.
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class ImageWithPlaceholderIcon extends StatelessWidget {
  const ImageWithPlaceholderIcon({
    Key? key,
    required XFile? image,
  })  : _image = image,
        super(key: key);

  final XFile? _image;

  @override
  Widget build(BuildContext context) {
    if (_image == null) return const Icon(Icons.add);
    return ExtendedImage.file(File(_image!.path),
        width: 100,
        height: 100,
        fit: BoxFit.fill,
        shape: BoxShape.circle,
        borderRadius: const BorderRadius.all(Radius.circular(30.0)));
  }
}
