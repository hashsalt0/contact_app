import 'dart:typed_data';

import 'package:contact_app/src/repo/contact_model.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:contact_app/src/values/config.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/adapters.dart';

/// Defines Operations related to contact
class ContactsRepository {
  late final Box<ContactModel> _contacts;

  /// adds contact to Hive Box
  Future<ContactModel> addContact(
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
      if (_contacts.values.isNotEmpty) return;

      /// Retrieving the contacts using FlutterContacts
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      ServiceLocator.instance.logger
          .i("Retrieved the contacts from device contacts list");

      /// Transforming Contact to ContactModel and saving them to hive.
      await _contacts.putAll(Map.fromEntries(
          contacts.map((e) => MapEntry(e.id, _toContactModel(e)))));
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

  List<ContactModel> getContactsList() => _contacts.values.toList();

  ContactModel _toContactModel(Contact e) {
    try {
      List<String> name = e.displayName.split(" ");
      String firstName = "", lastName = "";
      if(name.length == 1) {
        firstName = name.first;
      }else if(name.length > 1) {
        firstName = name.first;
        lastName = name.last;
      }
      String phoneNumber = "";
      if(e.phones.isNotEmpty){
        phoneNumber = e.phones.elementAt(0).number;
      }
      return ContactModel()
        ..firstName = firstName
        ..lastName = lastName
        ..phoneNumber = phoneNumber
        ..avatar = e.photo;
    } catch (e, stackTrace) {
      ServiceLocator.instance.logger
          .e("failed to convert Contact $e to ContactModel ", e, stackTrace);
    }
    return ContactModel();
  }
}
