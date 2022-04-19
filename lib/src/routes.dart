import 'package:contact_app/src/home/home_page.dart';
import 'package:flutter/material.dart';

import 'home/contacts/add_edit_contacts/add_edit_contacts_page.dart';

class AppRoutes {
  /// Application routes
  static MaterialPageRoute? contactsAppRoutes(RouteSettings settings) {
    Map<String, WidgetBuilder> routes = {
      HomePage.tag: (context) => const HomePage(),
      AddEditContactsPage.tag: (context) => const AddEditContactsPage()
    };
    WidgetBuilder? builder = routes[settings.name];
    if (builder == null) return null;
    return MaterialPageRoute(builder: (ctx) => builder.call(ctx));
  }
}
