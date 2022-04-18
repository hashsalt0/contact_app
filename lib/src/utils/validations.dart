import '../values/strings.dart';

class Validations {

  static String? nameValidation(String? value){
      if (value == null || value.isEmpty == true) {
        return Strings.nameValidationError;
      }
      return null;
  }

  static String? phoneNumberValidation(String? value){
    if (value == null || value.isEmpty == true) {
      return Strings.phoneNumberEmptyError;
    }
    if(!RegExp(Strings.phoneNumberRegex).hasMatch(value)){
      return Strings.invalidPhoneNumberError;
    }
    return null;
  }
}