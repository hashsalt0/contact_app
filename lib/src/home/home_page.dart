import 'package:contact_app/src/home/contacts/contacts_list_page.dart';
import 'package:contact_app/src/repo/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service_locator.dart';
import '../values/strings.dart';
import 'contacts/add_edit_contacts/add_edit_contact_view_model.dart';
import 'contacts/add_edit_contacts/add_edit_contacts_page.dart';

class HomePage extends StatelessWidget {
  static const tag = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Provider.of<AddEditContactViewModel>(context, listen: false)
                        .contact = ContactState.empty();
                    Navigator.pushNamed(context, AddEditContactsPage.tag);
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                ))
          ],
        ),
        body: Center(
            child: FutureBuilder<bool>(

                /// waiting for hive to be initialized
                future: ServiceLocator.instance.contactsRepository.initialize(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    return const ContactsListPage();
                  } else if (snapshot.hasError) {
                    return Column(children: const [
                      Icon(Icons.error_outline, color: Colors.red, size: 200),
                      Text(Strings.loadingContactsErrorMessage)
                    ]);
                  } else {
                    return const CircularProgressIndicator.adaptive();
                  }
                })),
      );
}
