import 'package:contact_app/src/home/contacts/contacts_list_page.dart';
import 'package:flutter/material.dart';
import '../values/strings.dart';
import 'contacts/add_edit_contacts_page.dart';

class HomePage extends StatelessWidget {
  static const tag = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed( context, AddEditContactsPage.tag);
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                ))
          ],
        ),
        body: const Center(child: ContactsListPage()),
        );
  }
}
