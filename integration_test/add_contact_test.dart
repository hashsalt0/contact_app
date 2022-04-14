import 'dart:math';

import 'package:contact_app/src/values/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:contact_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  /// Test not working not able to resolve MissingPluginException
  group('end-to-end test', () {
    testWidgets('adding a contact', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));

      await tester.pumpAndSettle();

      expect(find.text('Last Name'), findsOneWidget);

      String firstName = getRandomString(5);
      String lastName = getRandomString(5);

      await tester.enterText(find.byKey(Keys.inputFirstNameKey), firstName);
      await tester.enterText(find.byKey(Keys.inputLastNameKey), lastName);
      await tester.enterText(find.byKey(Keys.inputPhoneNumberKey), '7022617211');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      var contacts = await FlutterContacts.getContacts();
      expect(contacts.map((e) => e.displayName).contains("$firstName $lastName"
          ""), true);
    });
  });
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));