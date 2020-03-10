import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String TOKEN_KEY = "TOKEN";

  static const String EMPLOYEE_ID_KEY = "EMPLOYEEID";

  static const String BRANCH_NUMBER_KEY = "BRANCHNUMBER";

  static const String DATA_INITIALIZER_KEY = "DATAINITIALIZED";

  static Future saveAgentInformation(
      String token, String employeeId, String branchNumber) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: TOKEN_KEY, value: token);
    await storage.write(key: EMPLOYEE_ID_KEY, value: employeeId);
    await storage.write(key: BRANCH_NUMBER_KEY, value: branchNumber);
  }

 static Future setInitialDataLoaded() async {
    final storage = new FlutterSecureStorage();

    await storage.write(key: DATA_INITIALIZER_KEY, value: 'Y');
  }


  static Future<String> getInitialDataLoaded() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: DATA_INITIALIZER_KEY);
  }

  static Future<String> getEmployeeToken() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: TOKEN_KEY);
  }

  static Future<String> getEmployeeId() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: EMPLOYEE_ID_KEY);
  }

  static Future<String> getBranchNumber() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: BRANCH_NUMBER_KEY);
  }

  static Future clearSecureInformation() async {
    final storage = new FlutterSecureStorage();

    await storage.deleteAll();
  }
}
