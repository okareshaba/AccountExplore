
import 'package:zxplore_app/apis/zenithbank_api.dart';
import 'package:zxplore_app/models/login_response.dart';

class LoginRepository{

  ZenithBankApi _api = ZenithBankApi();

  Future<LoginResponse> attemptLogin(String username, String password){
    try {
      return _api.attemptLogin(username, password);
    } catch (error) {
      rethrow;
    }
  }
}