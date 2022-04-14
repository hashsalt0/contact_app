import 'package:contact_app/src/home/home_page.dart';
import 'package:flutter/material.dart';

import 'home/contacts/add_contacts_page.dart';

class AppRoutes {
  /// Application routes
  static final Map<String, WidgetBuilder> contactsAppRoutes = {
    HomePage.tag: (context) => const HomePage(),
    AddContactsPage.tag: (context) => const AddContactsPage(),
  };
}
