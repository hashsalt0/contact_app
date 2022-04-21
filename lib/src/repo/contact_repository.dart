import 'package:contact_app/src/repo/contact_model.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:contact_app/src/values/config.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/adapters.dart';

/// Defines Operations related to contact
class ContactsRepository {
  Box<ContactModel>? _contacts;

  /// adds contact to Hive Box
  Future<int?> addContact(ContactModel toCreate) async {
    try {
      ServiceLocator.instance.logger.i("created a new contact");
      ServiceLocator.instance.logger.v(toCreate.toString());
      return await _contacts?.add(toCreate);
    } catch (e, stackTrace) {
      ServiceLocator.instance.logger
          .e("failed to create contact", e, stackTrace);
    }
    return null;
  }

  /// Retrieves native contact and pushes it to hive
  Future<void> loadContacts() async {
    try {
      /// Returns when there is data is already present in hive
      /// but have side effect when hive data gets cleared it will again
      /// fetch all the data from contacts when the app starts again
      if (_contacts?.values.isNotEmpty == true) return;

      /// Retrieving the contacts using FlutterContacts
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      ServiceLocator.instance.logger
          .i("Retrieved the contacts from device contacts list");

      /// Transforming Contact to ContactModel and saving them to hive.

      await _contacts?.putAll(Map.fromEntries(
          contacts.map((e) => MapEntry(e.id, _toContactModel(e)))));
    } catch (e, stackTrace) {
      ServiceLocator.instance.logger
          .e("failed to update contact", e, stackTrace);
    }
  }

  /// Must be call before any other [Hive] operation
  Future<bool> initialize() async {
    /// Initializes Hive
    if (_contacts != null) return true;
    await Hive.initFlutter();
    Hive.registerAdapter(ContactModelAdapter());
    _contacts = await Hive.openBox(Config.boxName);
    return true;
  }

  /// returns the list of contacts stored in hive
  List<ContactModel> getContactsList() =>
      _contacts?.values.toList() ?? List.empty();

  /// Converts [Contact] to [ContactModel]
  ContactModel _toContactModel(Contact contact) {
    try {
      List<String> name = contact.displayName.split(" ");
      String firstName = "", lastName = "";
      if (name.length == 1) {
        firstName = name.first;
      } else if (name.length > 1) {
        firstName = name.first;
        lastName = name.last;
      }
      String phoneNumber = "";
      if (contact.phones.isNotEmpty) {
        phoneNumber = contact.phones.elementAt(0).number;
      }
      return ContactModel()
        ..firstName = firstName
        ..lastName = lastName
        ..phoneNumber = phoneNumber
        ..avatar = contact.photo;
    } catch (e, stackTrace) {
      ServiceLocator.instance.logger
          .e("failed to convert Contact $e to ContactModel ", e, stackTrace);
    }
    return ContactModel();
  }
}
