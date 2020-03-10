
import 'package:zxplore_app/utils/secure_storage.dart';

class Helper {

  static logout() async {
    await SecureStorage.clearSecureInformation();
  }

  static String returnValidStateSelectedItem(String sourceValue, List<String> matchingList) {
    sourceValue = sourceValue.toUpperCase();
    if (sourceValue.contains('STATE')) {
      sourceValue = sourceValue.replaceAll('STATE', '');
      sourceValue = sourceValue.trim();
    }
    String validData;

    matchingList.forEach((value) {
      if (value.contains(sourceValue)) {
        validData = value;
      }
    });

    return validData;
  }

  static String returnValidMaritalStatusSelectedItem(String sourceValue, List<String> matchingList) {
    sourceValue = sourceValue.toUpperCase();
    String validData;

    matchingList.forEach((value) {
      if (value.contains(sourceValue)) {
        validData = value;
      }
    });

    return validData;
  }

  static String returnValidGenderSelectedItem(String sourceValue, List<String> matchingList) {
    sourceValue = sourceValue.toUpperCase();
    String validData;


    matchingList.forEach((value) {
      if (value == sourceValue) {
        validData = value;
        return;
      }
    });

    return validData;
  }


}