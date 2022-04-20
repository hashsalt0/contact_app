import 'dart:convert';
import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';


@HiveType(typeId: 0)
class ContactModel extends HiveObject {
  @HiveField(0)
  String firstName = "";

  @HiveField(1)
  String lastName = "";

  @HiveField(2)
  String phoneNumber = "";

  @HiveField(3)
  Uint8List? avatar;

  @override
  String toString() =>
      "first name=$firstName, last name=$lastName, phone Number=$phoneNumber";
}

class ContactModelAdapter extends TypeAdapter<ContactModel> {
  /// represents no value is present for the avatar field
  static const _nullValue = "null";

  @override
  ContactModel read(BinaryReader reader) => ContactModel()
      ..firstName = reader.readString()
      ..lastName = reader.readString()
      ..phoneNumber = reader.readString()
      ..avatar = _decodeImage(reader.readString());

  @override
  final typeId = 0;

  @override
  void write(BinaryWriter writer, ContactModel obj)  {
    writer.writeString(obj.firstName);
    writer.writeString(obj.lastName);
    writer.writeString(obj.phoneNumber);
    Uint8List? avatar = obj.avatar;
    if (avatar != null) {
      writer.writeString(base64Encode(avatar));
    } else {
      writer.writeString(_nullValue);
    }
  }

  Uint8List? _decodeImage(String readString) {
    if (readString == _nullValue) return null;
    return base64Decode(readString);
  }
}
