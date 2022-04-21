import 'dart:typed_data';

import 'package:contact_app/src/home/contacts/add_edit_contacts/add_edit_contacts_page.dart';
import 'package:contact_app/src/repo/contact_model.dart';
import 'package:contact_app/src/repo/contact_state.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:contact_app/src/values/config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../values/strings.dart';
import 'add_edit_contacts/add_edit_contact_view_model.dart';

/// Contact list widget
class ContactsListPage extends StatelessWidget {
  static String tag = 'contacts-list-page';

  const ContactsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        /// asking permissions for contacts, if granted then adding contacts to
        /// hive.
        future: ServiceLocator.instance.permissionsManager.askPermissions(
            context: context,
            grantCallback: ServiceLocator.instance.contactsRepository
                .loadContacts), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            return const Text(Strings.loadingContactsErrorMessage);
          } else if (snapshot.hasData == false) {
            return const CircularProgressIndicator.adaptive();
          } else {
            return ValueListenableBuilder(
            valueListenable:
            Hive.box<ContactModel>(Config.boxName).listenable(),
            builder: (context, Box<ContactModel> box, widget) {
              if (box.values.isEmpty) {
                return const Text('No contacts');
              } else {
                List<ContactModel> _contacts = box.values.toList();
                return ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (context, i) {
                      var contact = _contacts[i];
                      return ListTile(
                          key: Key(contact.key.toString()),
                              title: Text(
                                  "${contact.firstName} ${contact.lastName}"),
                              subtitle: Text(contact.phoneNumber),
                              trailing: GestureDetector(
                                child: const Icon(Icons.delete),
                                onTap: () async {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text(
                                            Strings.confirmDelete),
                                        content: const Text(Strings
                                            .confirmDeleteDescription),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, Strings.cancel),
                                            child:
                                            const Text(Strings.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              contact.delete();
                                                  Navigator.pop(
                                                      context, Strings.ok);
                                                },
                                                child: const Text(Strings.ok),
                                              ),
                                            ],
                                          ));
                                },
                              ),
                              leading: CircleAvatar(
                                  foregroundImage: _getAvatar(contact),
                                  child: Text(_getNameInitials(contact))),
                              onTap: () async {
                                Provider.of<AddEditContactViewModel>(context,
                                        listen: false)
                                    .contact = ContactState.fromModel(contact);
                                Navigator.pushNamed(
                                    context, AddEditContactsPage.tag);
                              });
                    });
              }
            });
      }
    },
  );

  /// returns name initials eg, jane doe as JD or jane as J or doe as D
  String _getNameInitials(ContactModel contact) {
    StringBuffer toReturn = StringBuffer();
    if (contact.firstName.characters.isNotEmpty) {
      toReturn.write(contact.firstName.characters.first.toUpperCase());
    }
    if (contact.lastName.characters.isNotEmpty) {
      toReturn.write(contact.lastName.characters.first.toUpperCase());
    }
    return toReturn.toString();
  }

  /// returns the avatar of the contact
  ImageProvider? _getAvatar(ContactModel contactModel) {
    Uint8List? avatar = contactModel.avatar;
    if (avatar != null) {
      return Image.memory(avatar).image;
    } else {
      return null;
    }
  }
}
