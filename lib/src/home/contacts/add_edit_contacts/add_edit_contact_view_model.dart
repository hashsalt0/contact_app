import 'package:contact_app/src/repo/contact_model.dart';
import 'package:contact_app/src/repo/contact_state.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../values/strings.dart';

class AddEditContactViewModel extends ChangeNotifier {
  String _appTitle = Strings.addContactPageTitle;

  ContactState _contact = ContactState.empty();

  ContactState get contact => _contact;

  set contact(ContactState value) {
    _contact = value;

    /// update the edit
    if (value.isInBox) {
      _appTitle = Strings.editContactPageTitle;
    } else {
      _appTitle = Strings.addContactPageTitle;
    }
  }

  String get title => _appTitle;

  void setContactPhoto(XFile? imageFile) {
    if (imageFile == null) return;
    _contact.avatar = imageFile.readAsBytes();
    notifyListeners();
  }

  /// Adds or updates the contact.
  /// returns the message to be shown to user.
  Future<String> submit() async {
    ServiceLocator.instance.logger.d("Submitting data to hive");
    ContactModel contactModel = await _contact.toModel();
    if (contactModel.isInBox) {
      await contactModel.save();
      return Strings.updateContactSuccessMessage;
    } else {
      await ServiceLocator.instance.contactsRepository.addContact(contactModel);
      return Strings.createdContactSuccessMessage;
    }
  }

  void setPhoneNumber(String value) {
    _contact.phoneNumber = value;
  }

  void setLastName(String value) {
    _contact.lastName = value;
  }

  void setFirstName(String value) {
    _contact.firstName = value;
  }
}
