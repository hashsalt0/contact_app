import 'dart:typed_data';

import 'package:contact_app/src/home/contacts/add_edit_contacts_page.dart';
import 'package:contact_app/src/repo/contact_model.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:contact_app/src/values/config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

/// Contact list widget
class ContactsListPage extends StatefulWidget {
  static String tag = 'contacts-list-page';

  const ContactsListPage({Key? key}) : super(key: key);

  @override
  _ContactsListPageState createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  @override
  void initState() {
    super.initState();

    /// Asking for permissions and loading contacts when permission is granted
    ServiceLocator.instance.permissionsManager.askPermissions(
        context: context,
        grantCallback: ServiceLocator.instance.contactsRepository.loadContacts);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<ContactModel>(Config.boxName).listenable(),
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
                      title: Text("${contact.firstName} ${contact.lastName}"),
                      subtitle: Text(contact.phoneNumber),
                      trailing: GestureDetector(
                        child: const Icon(Icons.delete),
                        onTap: () async {
                          contact.delete();
                        },
                      ),
                      leading: CircleAvatar(
                          foregroundImage: _getAvatar(contact),
                          child: Text(
                              "${contact.firstName.characters.first.toUpperCase()} ${contact.lastName.characters.first.toUpperCase()}")),
                      onTap: () async {
                        Navigator.pushNamed(context, AddEditContactsPage.tag,
                            arguments: contact);
                      });
                });
          }
        });
  }

  _getAvatar(ContactModel contactModel) {
    Uint8List? avatar = contactModel.avatar;
    if (avatar != null) {
      return Image.memory(avatar).image;
    } else {
      return null;
    }
  }
}
