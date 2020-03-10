import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/data/database.dart';
import 'package:zxplore_app/data/entities/offline_form_entity.dart';
import 'package:zxplore_app/models/accounts_response.dart';
import 'package:zxplore_app/models/verify_account_response.dart';
import 'package:zxplore_app/repositories/accounts_repository.dart';
import 'package:zxplore_app/utils/secure_storage.dart';

class AccountsBloc extends BlocBase {
  final AccountsRepository _accountsRepository = AccountsRepository();
  final BehaviorSubject<AccountsResponse> _subjectAccountsResponse =
      BehaviorSubject<AccountsResponse>();

  final PublishSubject<VerifyAccountResponse> _subjectVerifyAccountsResponse =
      PublishSubject<VerifyAccountResponse>();

  final _offlineAccountsController =
      StreamController<List<OfflineAccountEntity>>.broadcast();

  Stream<List<OfflineAccountEntity>> get offlineAccounts =>
      _offlineAccountsController.stream;

  StreamSink<List<OfflineAccountEntity>> get _OfflineAccounts =>
      _offlineAccountsController.sink;

  getAccounts() async {
    try {
      String rsmId = await SecureStorage.getEmployeeId();

      AccountsResponse response =
          await _accountsRepository.getAccountsByRsmId(rsmId);
      _subjectAccountsResponse.sink.add(response);
    } catch (error) {
      _subjectAccountsResponse.sink.addError('$error');
    }
  }

  getOfflineAccounts() async {
    List<OfflineAccountEntity> offlineAcccounts =
        await DBProvider.db.getOfflineAccounts();
    _OfflineAccounts.add(offlineAcccounts);
  }

  deleteOfflineAccount(int id) async {
    await _accountsRepository.deleteOfflineAccount(id);
  }

  verifyAccountByReferenceId(String referenceId) async {
    try {
      VerifyAccountResponse response =
          await _accountsRepository.verifyAccountsByRefId(referenceId);
      _subjectVerifyAccountsResponse.sink.add(response);
    } catch (error) {
      _subjectVerifyAccountsResponse.sink.addError(error);
    }
  }

  fetchAccountClasses() {
    _accountsRepository
        .getAccountClasses()
        .then((result) {})
        .catchError((error) {
      //todo: fetch account classes
    });
  }

  @override
  dispose() {
    _subjectAccountsResponse.close();
    _subjectVerifyAccountsResponse.close();
    _offlineAccountsController.close();
  }

  BehaviorSubject<AccountsResponse> get subjectAccountsResponse =>
      _subjectAccountsResponse;

  PublishSubject<VerifyAccountResponse> get subjectVerifyAccountsResponse =>
      _subjectVerifyAccountsResponse;
}
