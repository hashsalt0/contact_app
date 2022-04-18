import 'dart:convert';
import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';

@HiveType(typeId: 0)
class ContactModel extends HiveObject {

  @HiveField(0)
  late String firstName;

  @HiveField(1)
  late String lastName;

  @HiveField(2)
  late String phoneNumber;

  @HiveField(3)
  late Uint8List? avatar;

  @override
  String toString() {
    return "first name = $firstName\nlast name =$lastName\nphone Number=$phoneNumber";
  }
}

class ContactModelAdapter extends TypeAdapter<ContactModel>{
  static const _nullValue = "null";

  @override
  ContactModel read(BinaryReader reader) {
    return ContactModel()
        ..firstName = reader.readString()
        ..lastName  = reader.readString()
        ..phoneNumber = reader.readString()
        ..avatar = _decodeImage(reader.readString());
  }

  @override
  final typeId = 0;

  @override
  void write(BinaryWriter writer, ContactModel obj) {
    writer.writeString(obj.firstName);
    writer.writeString(obj.lastName);
    writer.writeString(obj.phoneNumber);
    if(obj.avatar != null) {
      writer.writeString(base64Encode(obj.avatar!.toList()));
    }else{
      writer.writeString(_nullValue);
    }
  }

  Uint8List? _decodeImage(String readString) {
    if(readString == _nullValue)  return null;
    return base64Decode(readString);
  }
}