import 'package:contact_app/src/utils/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("Validation Test", () {
    expect(Validations.phoneNumberValidation("7022617211") == null, true);
    expect(Validations.phoneNumberValidation("+917022617211") == null, true);
    expect(Validations.phoneNumberValidation("07022617211") == null, true);
  });
}