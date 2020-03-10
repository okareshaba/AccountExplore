import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:zxplore_app/apis/zenithbank_api.dart';
import 'package:zxplore_app/blocs/validators.dart';
import 'package:zxplore_app/models/login_response.dart';
import 'package:zxplore_app/repositories/login_repository.dart';
import 'package:zxplore_app/utils/secure_storage.dart';
import 'package:zxplore_app/utils/zxplore_crypto_helper.dart';

class LoginBloc extends Object with Validators {
  final _userNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final LoginRepository _loginRepository = LoginRepository();

  // Add data to stream
  Stream<String> get username =>
      _userNameController.stream.transform(validateUsername);

  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(username, password, (e, p) => true);

  // change data
  Function(String) get changeUserName => _userNameController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  final PublishSubject<LoginResponse> _subjectLoginResponse =
      PublishSubject<LoginResponse>();

  PublishSubject<LoginResponse> get subjectLoginResponse =>
      _subjectLoginResponse;

  submit() {
    final validUserName = _userNameController.value;
    final validPassword = _passwordController.value;

    final encryptedUserName = CryptoHelper.encrypt(validUserName);
    final encryptedPassword = CryptoHelper.encrypt(validPassword);

    attemptLogin(encryptedUserName, encryptedPassword);
  }

  attemptLogin(String userName, String password) async {
    await _loginRepository
        .attemptLogin(userName, password)
        .then((response) async {
      if (response.status) {
        await SecureStorage.saveAgentInformation(
            response?.data?.user?.token,
            response?.data?.user?.employeeId?.toString(),
            response?.data?.user?.branchNumber.toString());

        _subjectLoginResponse.sink.add(response);
      } else {
        _subjectLoginResponse.sink.addError(response?.data?.responseMessage);
      }
    }).catchError((error) {
      _subjectLoginResponse.sink.addError(error);
    });
  }

  dispose() {
    _subjectLoginResponse.close();
    _userNameController.close();
    _passwordController.close();
  }
}
