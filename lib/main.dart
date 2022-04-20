import 'package:contact_app/src/app_widget.dart';
import 'package:contact_app/src/home/contacts/add_edit_contacts/add_edit_contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(

      /// Providers are above [AppWidget] instead of inside it, so that tests
      /// can use [AppWidget] while mocking the providers
      MultiProvider(
    providers: [
      ChangeNotifierProvider<AddEditContactViewModel>(
          create: (_) => AddEditContactViewModel()),
    ],
    child: const AppWidget(),
  ));
}
