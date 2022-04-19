import 'package:contact_app/src/repo/contact_model.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../values/strings.dart';

class AddEditContactViewModel extends ChangeNotifier {

  ContactModel _contact = ContactModel();

  String _appTitle = Strings.addContactPageTitle;

  ContactModel get contact => _contact;

  set contact(ContactModel value) {
    _contact = value;
    if(value.isInBox) {
      _appTitle = Strings.editContactPageTitle;
    } else {
      _appTitle = Strings.addContactPageTitle;
    }
  }

  String get title => _appTitle;

  void setContactPhoto(XFile? imageFile) async {
    if (imageFile == null) return;
    // POSSIBLE BUG
    _contact.avatar = await imageFile.readAsBytes();
    notifyListeners();
  }

  /// returns true if contact is already present in hive or updating value
  bool submit() {
    ServiceLocator.instance.logger.d("Submitting data to hive");
    if(_contact.isInBox){
      _contact.save();
      return true;
    }else{
      ServiceLocator.instance.contactsRepository.addContact(_contact);
      return false;
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
