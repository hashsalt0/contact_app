class Validations {

  static String? nameValidation(String? value){
      if (value == null || value.isEmpty == true) {
        return 'Name cannot be empty';
      }
      return null;
  }

  static String? phoneNumberValidation(String? value){
    if (value == null || value.isEmpty == true) {
      return 'Phone Number cannot be empty';
    }
    if(!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)){
      return "Invalid Phone Number";
    }
    return null;
  }
}