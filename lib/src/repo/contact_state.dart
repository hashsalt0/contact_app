import 'dart:typed_data';

import 'package:contact_app/src/repo/contact_model.dart';

import '../widget/lazy_image_widget.dart';

class ContactState {
  late ContactModel _model;

  String firstName = "";

  String lastName = "";

  String phoneNumber = "";

  Future<Uint8List>? _avatar;

  Future<Uint8List>? get avatar => _avatar;

  bool get isInBox => _model.isInBox;

  set avatar(Future<Uint8List>? value) {
    if (_mutex) {
      throw Exception("Cannot read while writing");
    } else {
      _mutex = true;
    }
    _avatar = value;
    _mutex = false;
  }

  ContactState._();

  static bool _mutex = false;

  static ContactState fromModel(ContactModel contactModel) => ContactState._()
    .._model = contactModel
    ..firstName = contactModel.firstName
    ..lastName = contactModel.lastName
    ..phoneNumber = contactModel.phoneNumber
    .._avatar =
        Future.value(contactModel.avatar ?? LazyImageWidget.showFallbackWidget);

  Future<ContactModel> toModel() async {
    if (_mutex) {
      throw Exception("Cannot read while writing");
    } else {
      _mutex = true;
    }
    try {
      Uint8List? readAvatar = await _avatar;
      _model.avatar = readAvatar;
    } catch (e) {
      _mutex = false;
      rethrow;
    }
    return _model
      ..firstName = firstName
      ..lastName = lastName;
  }

  static ContactState empty() => fromModel(ContactModel());

  bool getMutex() => _mutex;
}
