
import 'package:contact_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './values/strings.dart';

class AppWidget extends StatelessWidget{
  const AppWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: Strings.appName,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), // English, no country code
        ],
        onGenerateRoute: AppRoutes.contactsAppRoutes
    );
  }
}
