class Strings {
  static const appName = "Contacts App";
  static const labelCamera = "camera";

  static const labelGallery = "gallery";
  static const phoneNumberLabel = "Phone Number";
  static const lastNameLabel = 'Last Name';
  static const firstNameLabel = 'First Nome';

  static const addContactPageTitle = "Add a new Contact";

  static const defaultPhoneMask = '0000-0000';

  static const phoneNumberRegex = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  static const nameValidationError = 'Name cannot be empty';

  static const phoneNumberEmptyError = 'Phone Number cannot be empty';

  static const invalidPhoneNumberError = "Invalid Phone Number";

  static const digitsRegex = r'[^0-9\+]';

  static const phoneNumberMasks = {
    8  : '0000-0000',
    9  : '00000-0000',
    10 : '(00) 0000-0000',
    11 : '(000) 00000-0000',
    12 : '(000) 00000-00000'
  };

  static const save = 'Save';

  static const editContactPageTitle = "Edit Contact";

  static const createdContactSuccessMessage = "Successfully created contact";

  static const updateContactSuccessMessage = "Successfully updated contact";

}
