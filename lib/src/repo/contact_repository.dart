import 'dart:typed_data';

import 'package:contact_app/src/repo/contact_model.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:contact_app/src/values/config.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

/// Defines Operations related to contact
class ContactsRepository {
  late final Box<ContactModel> _contacts;

  /// adds contact to Device
  /// see [Contact]
  void addContact(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required XFile? avatar}) async {
    addContactRaw(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        avatar: await avatar?.readAsBytes());
  }

  Future<ContactModel> addContactRaw(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required Uint8List? avatar}) async {
    ContactModel createdContact = ContactModel()
      ..firstName = firstName
      ..lastName = lastName
      ..phoneNumber = phoneNumber
      ..avatar = avatar;
    try {
      await _contacts.add(createdContact);
      ServiceLocator.instance.logger.i("created a new contact");
      ServiceLocator.instance.logger.v(createdContact.toString());
    } catch (e, stackTrace) {
      ServiceLocator.instance.logger
          .e("failed to create contact", e, stackTrace);
    }
    return createdContact;
  }

  void loadContacts() async {
    try {
      /// Returns when there is data is already present in hive
      /// but have side effect when hive data gets cleared it will again
      /// fetch all the data from contacts when the app starts again
      if(_contacts.values.isNotEmpty) return;
      /// Retrieving the contacts using FlutterContacts
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      ServiceLocator.instance.logger
          .i("Retrieved the contacts from device contacts list");

      /// Transforming Contact to ContactModel and saving them to hive.
      await _contacts.putAll(Map.fromEntries(contacts.map((e) => MapEntry(
          e.id,
          ContactModel()
            ..firstName = e.displayName.split(" ").first
            ..lastName = e.displayName.split(" ").last
            ..phoneNumber = e.phones.first.number
            ..avatar = e.photo))));
    } catch (e, stackTrace) {
      ServiceLocator.instance.logger
          .e("failed to update contact", e, stackTrace);
    }
  }

  Future<void> initialize() async {
    /// Initializes Hive
    await Hive.initFlutter();
    Hive.registerAdapter(ContactModelAdapter());
    _contacts = await Hive.openBox(Config.boxName);
  }

  List<ContactModel> getContactsList() {
    return _contacts.values.toList();
  }
}
