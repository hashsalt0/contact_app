
import 'package:contact_app/src/app_widget.dart';
import 'package:contact_app/src/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  await ServiceLocator.instance.contactsRepository.initialize();
  runApp(const AppWidget());
}
