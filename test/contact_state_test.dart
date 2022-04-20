import 'dart:typed_data';

import 'package:contact_app/src/repo/contact_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<Uint8List> delayedException() async {
    await Future.delayed(const Duration(milliseconds: 10));
    throw Exception();
  }

  test("test toModel", () async {
    ContactState contactState = ContactState.empty();
    contactState.avatar = delayedException();
    try {
      await contactState.toModel();
    } catch (e) {}
    expect(contactState.getMutex(), false);
  });
}
