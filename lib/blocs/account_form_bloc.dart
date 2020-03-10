import 'dart:async';
import 'dart:convert';
import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/data/database.dart';
import 'package:zxplore_app/data/entities/account_class_entity.dart';
import 'package:zxplore_app/data/entities/offline_form_entity.dart';
import 'package:zxplore_app/models/account_class_model.dart';
import 'package:zxplore_app/models/account_details_response.dart';
import 'package:zxplore_app/models/bvn_response.dart';
import 'package:zxplore_app/models/form_model.dart';
import 'package:zxplore_app/models/save_account_response.dart';
import 'package:zxplore_app/repositories/accounts_repository.dart';
import 'package:zxplore_app/utils/secure_storage.dart';
import 'package:zxplore_app/utils/zxplore_crypto_helper.dart';

import 'validators.dart';
import 'package:rxdart/rxdart.dart';

class AccountFormBloc extends BlocBase with Validators {

  Pattern pattern = r'[!₦$/@#<>?":_`~;[\]\\|=+)(*&^%0-9]';
  //Account Information
  final AccountsRepository _accountsRepository = AccountsRepository();

  final _referenceIdController =
      BehaviorSubject<String>(); // used in the case of updating accounts.

  final _isDateOfBirthChangeController = BehaviorSubject<bool>();
  final _isStateOfOriginChangeController = BehaviorSubject<bool>();
  final _isStateOfResidenceChangeController = BehaviorSubject<bool>();
  final _isGenderChangeController = BehaviorSubject<bool>();
  final _isMaritalStatusChangeController = BehaviorSubject<bool>();

  final _idController = BehaviorSubject<int>();
  final _isEditModeController = BehaviorSubject<bool>();

  final _accountTypeController = BehaviorSubject<String>();

  final _accountHolderTypeController = BehaviorSubject<String>();

  final _riskRankController = BehaviorSubject<String>();

  final _accountCategoryController = BehaviorSubject<String>();

  //Personal Information

  final _bvnController = BehaviorSubject<String>();

  final _titleController = BehaviorSubject<String>();

  final _surnameController = BehaviorSubject<String>();

  final _firstNameController = BehaviorSubject<String>();

  final _otherNameController = BehaviorSubject<String>();

  final _mothersMaidenNameController = BehaviorSubject<String>();

  final _dateOfBirthController = BehaviorSubject<String>();

  final _stateOfOriginController = BehaviorSubject<String>();

  final _countryOfOriginController = BehaviorSubject<String>();

  //Contact Details

  final _emailController = BehaviorSubject<String>();

  final _phoneNumberController = BehaviorSubject<String>();

  final _nextOfKinController = BehaviorSubject<String>();

  final _address1Controller = BehaviorSubject<String>();

  final _address2Controller = BehaviorSubject<String>();

  final _countryOfResidenceController = BehaviorSubject<String>();

  final _stateOfResidenceController = BehaviorSubject<String>();

  final _cityOfResidenceController = BehaviorSubject<String>();

  final _genderController = BehaviorSubject<String>();

  final occupationController = BehaviorSubject<String>();

  final _maritalStatusController = BehaviorSubject<String>();

  //Means of Identification
  final _idTypeController = BehaviorSubject<String>();

  final _idIssuerController = BehaviorSubject<String>();

  final _idNumberController = BehaviorSubject<String>();

  final _idPlaceOfIssueController = BehaviorSubject<String>();

  final _idIssueDateController = BehaviorSubject<String>();

  final _idExpiryDateController = BehaviorSubject<String>();

  final _isSendEmailController = BehaviorSubject<bool>();

  final _isReceiveSmsController = BehaviorSubject<bool>();

  final _isRequestHardwareTokenController = BehaviorSubject<bool>();

  final _isRequestInternetBankingController = BehaviorSubject<bool>();

  final _uploadIdImageController = BehaviorSubject<String>();

  final _uploadPassportController = BehaviorSubject<String>();

  final _uploadUtilityBillController = BehaviorSubject<String>();

  final _uploadSignatureController = BehaviorSubject<String>();

  final BehaviorSubject<SaveAccountResponse> _subjectSaveAccountResponse =
      BehaviorSubject<SaveAccountResponse>();

  final PublishSubject<AccountDetailsResponse> _subjectAccountsDetailsResponse =
      PublishSubject<AccountDetailsResponse>();

  final PublishSubject<String> _subjectSaveOfflineAccountResponse =
      PublishSubject<String>();

  final PublishSubject<String> _subjectDeleteOfflineAccountResponse =
      PublishSubject<String>();

  // Add data to stream

  final PublishSubject<BvnResponse> bvnVerificationResponse =
      PublishSubject<BvnResponse>();
  Stream<bool> get bvnStateOfOrigin => _isStateOfOriginChangeController.stream;
  Stream<bool> get bvnDateOfBirth => _isDateOfBirthChangeController.stream;
  Stream<bool> get bvnStateOfResidences => _isStateOfResidenceChangeController.stream;
  Stream<bool> get bvnGenders => _isGenderChangeController.stream;
  Stream<bool> get bvnMaritalStatuses => _isMaritalStatusChangeController.stream;

  String easy_classic = "344";
  bool bvnlastNameValue = true;
  bool bvnFirstName = true;
  bool bvnStateOfResidence = true;

  bool bvnResidentialAddress = true;
  bool bvnMaritalStatus = true;
  bool bvnPhone = true;
  bool bvnGender = true;
  bool bvnState = true;

  bool bvnDateOfBirths = true;

  bool bvnTitle = true;
  bool bvnEmail = true;
  bool bvnOtherName = true;

  Stream<String> get accountType =>
      _accountTypeController.stream.transform(validateAccountType);

  Stream<String> get accountHolderType =>
      _accountHolderTypeController.stream.transform(validateAccountHolderType);

  Stream<String> get riskRankType =>
      _riskRankController.stream.transform(validateRiskRank);

  Stream<String> get accountCategoryType =>
      _accountCategoryController.stream.transform(validateAccountCategory);

  Stream<String> get bvn => _bvnController.stream;

  Stream<String> get title => _titleController.stream.transform(validateTitle);

  Stream<String> get surname =>
      _surnameController.stream.transform(validateSurname);

  Stream<String> get firstName =>
      _firstNameController.stream.transform(validateFirstName);

  Stream<String> get otherName =>
      _otherNameController.stream.transform(validateOtherName);

  Stream<String> get mothersMaidenName =>
      _mothersMaidenNameController.stream.transform(validateMothersMaidenName);

  Stream<String> get dateOfBirth =>
      _dateOfBirthController.stream.transform(validateDateOfBirth);

  Stream<String> get stateOfOrigin =>
      _stateOfOriginController.stream.transform(validateStateOfOrigin);

  Stream<String> get countryOfOrigin =>
      _countryOfOriginController.stream.transform(validateCountryOfOrigin);

  Stream<String> get phoneNumber =>
      _phoneNumberController.stream.transform(validatePhoneNumber);

  Stream<String> get nextOfKin =>
      _nextOfKinController.stream.transform(validateNextOfKin);

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  Stream<String> get address1 =>
      _address1Controller.stream.transform(validateAddress1);

  Stream<String> get address2 => _address2Controller.stream;

  Stream<String> get countryOfResidence => _countryOfResidenceController.stream
      .transform(validateCountryOfResidence);

  Stream<String> get stateOfResidence =>
      _stateOfResidenceController.stream.transform(validateStateOfResidence);

  Stream<String> get cityOfResidence =>
      _cityOfResidenceController.stream.transform(validateCityOfResidence);

  Stream<String> get gender =>
      _genderController.stream.transform(validateGender);

  Stream<String> get occupation =>
      occupationController.stream.transform(validateOccupation);

  Stream<String> get maritalStatus =>
      _maritalStatusController.stream.transform(validateMaritalStatus);

  Stream<String> get idType => _accountCategoryController.value == easy_classic
      ? _idTypeController.stream
      : _idTypeController.stream.transform(validateIdType);

  Stream<String> get idIssuer =>
      _accountCategoryController.value == easy_classic
          ? _idIssuerController.stream
          : _idIssuerController.stream.transform(validateIdIssuer);

  Stream<String> get idNumber =>
      _accountCategoryController.value == easy_classic
          ? _idNumberController.stream
          : _idNumberController.stream.transform(validateIdNumber);

  Stream<String> get idPlaceOfIssue =>
      _accountCategoryController.value == easy_classic
          ? _idPlaceOfIssueController.stream
          : _idPlaceOfIssueController.stream.transform(validateIdPlaceOfIssue);

  Stream<String> get idIssueDate =>
      _accountCategoryController.value == easy_classic
          ? _idIssueDateController.stream
          : _idIssueDateController.stream.transform(validateIdIssueDate);

  Stream<String> get idExpiryDate =>
      _accountCategoryController.value == easy_classic
          ? _idExpiryDateController.stream
          : _idExpiryDateController.stream.transform(validateIdExpiryDate);

  Stream<bool> get isSendEmail => _isSendEmailController.stream;

  Stream<bool> get isReceiveSmsAlert => _isReceiveSmsController.stream;

  Stream<bool> get isRequestHardwareToken =>
      _isRequestHardwareTokenController.stream;

  Stream<bool> get isRequestInternetBanking =>
      _isRequestInternetBankingController.stream;

  Stream<String> get idCard => _uploadIdImageController.stream;

  Stream<String> get passport => _uploadPassportController.stream;

  Stream<String> get signature => _uploadSignatureController.stream;

//  Stream<bool> get submitValid => Observable.combineLatest4(
//      accountType,
//      accountHolderType,
//      riskRankType,
//      accountCategoryType,
//      (a, ac, r, act) => true);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(phoneNumber, signature, (e, p) => true);

  // change data

  Function(String) get changeAccountType => _accountTypeController.sink.add;

  Function(String) get changeHolderType =>
      _accountHolderTypeController.sink.add;

  Function(String) get changeRiskRank => _riskRankController.sink.add;

  Function(String) get changeAccountCategory =>
      _accountCategoryController.sink.add;

  Function(String) get changeBvn => _bvnController.sink.add;

  Function(String) get changeTitle => _titleController.sink.add;

  Function(String) get changeSurname => _surnameController.sink.add;

  Function(String) get changeFirstName => _firstNameController.sink.add;

  Function(String) get changeOtherName => _otherNameController.sink.add;

  Function(String) get changeMothersMaidenName =>
      _mothersMaidenNameController.sink.add;

  Function(String) get changeDateOfBirth => _dateOfBirthController.sink.add;

  Function(String) get changeStateOfOrigin => _stateOfOriginController.sink.add;

  Function(String) get changeCountryOfOrigin =>
      _countryOfOriginController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePhone => _phoneNumberController.sink.add;

  Function(String) get changeNextOfKin => _nextOfKinController.sink.add;

  Function(String) get changeAddress1 => _address1Controller.sink.add;

  Function(String) get changeAddress2 => _address2Controller.sink.add;

  Function(String) get changeCountryOfResidence =>
      _countryOfResidenceController.sink.add;

  Function(String) get changeStateOfResidence =>
      _stateOfResidenceController.sink.add;

  Function(String) get changeCityOfResidence =>
      _cityOfResidenceController.sink.add;

  Function(String) get changeGender => _genderController.sink.add;

  Function(String) get changeOccupation => occupationController.sink.add;

  Function(String) get changeMaritalStatus => _maritalStatusController.sink.add;

  Function(String) get changeIdType => _idTypeController.sink.add;

  Function(String) get changeIdIssuer => _idIssuerController.sink.add;

  Function(String) get changeIdNumber => _idNumberController.sink.add;

  Function(String) get changePlaceOfIssue => _idPlaceOfIssueController.sink.add;

  Function(String) get changeIssueDate => _idIssueDateController.sink.add;

  Function(String) get changeExpiryDate => _idExpiryDateController.sink.add;

  Function(bool) get changeIsSendEmail => _isSendEmailController.sink.add;

  Function(bool) get changeIsReceiveSms => _isReceiveSmsController.sink.add;

  Function(bool) get changeMaritalStatusValue => _isMaritalStatusChangeController.sink.add;


  Function(bool) get changeIsRequestHardwareToken =>
      _isRequestHardwareTokenController.sink.add;

  Function(bool) get changeIsRequestInternetBanking =>
      _isRequestInternetBankingController.sink.add;

  Function(String) get changeSignature => _uploadSignatureController.sink.add;

  setAccountType(String value) {
    _accountTypeController.sink.add(value);
  }

  setAccountHolderType(String value) {
    _accountHolderTypeController.sink.add(value);
  }

  setRiskRankType(String value) {
    _riskRankController.sink.add(value);
  }

  setAccountCategory(String value) {
    _accountCategoryController.sink.add(value);
  }

  setDateOfBirth(String value) {
    _dateOfBirthController.sink.add(value);
  }

  setUploadIdForm(String value) {
    _uploadIdImageController.sink.add(value);
  }

  setUploadPassportForm(String value) {
    _uploadPassportController.sink.add(value);
  }

  setUploadUtilityBillForm(String value) {
    _uploadUtilityBillController.sink.add(value);
  }

  setSignature(String value) {
    _uploadSignatureController.sink.add(value);
    changeSignature(value);
  }

  setOccupation(String value) {
    occupationController.sink.add(value);
    changeOccupation;
  }

  saveOffline() async {
    var validId = _idController.value;
    var validRefenceId = _referenceIdController.value;

    var validAccountType = _accountTypeController.value;
    final validAccountHolderType = _accountHolderTypeController.value;
    final validAccountRiskRank = _riskRankController.value;
    final validAccountCategory = _accountCategoryController.value;

    var validBvn = _bvnController.value;
    final validTitle = _titleController.value;
    final validSurname = _surnameController.value;
    final validFirstName = _firstNameController.value;
    var validOtherName = _otherNameController.value;
    final validMothersMaidenName = _mothersMaidenNameController.value;
    final validDateOfBirth = _dateOfBirthController.value;
    final validStateOfOrigin = _stateOfOriginController.value;
    final validCountryOfOrigin = _countryOfOriginController.value == null
        ? 'NIGERIA'
        : _countryOfOriginController.value; //workaround for bug

    var validEmail = _emailController.value;
    final validPhone = _phoneNumberController.value;
    final validNextOfKin = _nextOfKinController.value;
    final validAddress1 = _address1Controller.value;
    var validAddress2 = _address2Controller.value;
    final validCountryOfResidence = _countryOfResidenceController.value == null
        ? 'NIGERIA'
        : _countryOfResidenceController.value; //workaround for bug

    final validStateOfResidence = _stateOfResidenceController.value;
    final validCityOfResidence = _cityOfResidenceController.value;
    final validGender = _genderController.value;
    final validOccupation = occupationController.value;
    final validMaritalStatus = _maritalStatusController.value;

    final validIdType = _idTypeController.value;
    final validIdIssuer = _idIssuerController.value;
    final validIdNumber = _idNumberController.value;
    final validIdPlaceOfIssue = _idPlaceOfIssueController.value;
    final validIdIssueDate = _idIssueDateController.value;
    final validIdExpiryDate = _idExpiryDateController.value;
    final validIsSendEmail =
        _isSendEmailController.value == null ? false : true;
    final validIsReceiveSms =
        _isReceiveSmsController.value == null ? false : true;
    final validIsRequestHardwareToken =
        _isRequestHardwareTokenController.value == null ? false : true;
    final validIsRequestInternetBanking =
        _isRequestInternetBankingController.value == null ? false : true;

    final validUploadIdImageInBase64 = _uploadIdImageController.value;
    final validUploadPassportInBase64 = _uploadPassportController.value;
    final validUploadUtilityBillInBase64 = _uploadUtilityBillController.value;

    final validUploadSignatureInBase64 = _uploadSignatureController.value;

    var currentTimeStamp = new DateTime.now().millisecondsSinceEpoch;

    var employeeId = await SecureStorage.getEmployeeId();

    var referenceId;

    if (validRefenceId != null) {
      referenceId = validRefenceId; //for updating accounts.
    } else {
      referenceId = '$employeeId${currentTimeStamp.toString().substring(7)}';
    }

    OfflineAccountEntity _offlineAccount = OfflineAccountEntity(
        id: validId,
        referenceId: referenceId,
        accountType: validAccountType,
        accountHolderType: validAccountHolderType,
        riskRank: validAccountRiskRank,
        accountCategory: validAccountCategory,
        bvn: validBvn,
        title: validTitle,
        surname: validSurname,
        firstName: validFirstName,
        otherName: validOtherName,
        mothersMaidenName: validMothersMaidenName,
        dateOfBirth: validDateOfBirth,
        stateOfOrigin: validStateOfOrigin,
        countryOfOrigin: validCountryOfOrigin,
        email: validEmail,
        phone: validPhone,
        nextOfKin: validNextOfKin,
        address1: validAddress1,
        address2: validAddress2,
        countryOfResidence: validCountryOfResidence,
        stateOfResidence: validStateOfResidence,
        cityOfResidence: validCityOfResidence,
        gender: validGender,
        occupation: validOccupation,
        maritalStatus: validMaritalStatus,
        idType: validIdType,
        idIssuer: validIdIssuer,
        idNumber: validIdNumber,
        idPlaceOfIssue: validIdPlaceOfIssue,
        idIssueDate: validIdIssueDate,
        idExpiryDate: validIdExpiryDate,
        isSendEmail: validIsSendEmail,
        isReceiveAlert: validIsReceiveSms,
        isRequestHardwareToken: validIsRequestHardwareToken,
        isRequestInternetBanking: validIsRequestInternetBanking,
        idCard: validUploadIdImageInBase64,
        passport: validUploadPassportInBase64,
        utility: validUploadUtilityBillInBase64,
        signature: validUploadSignatureInBase64);

    insertFormOffline(_offlineAccount);
  }

  updateAccountCategoryType(String value) {
    _accountCategoryController.sink.add(value);
    if (value == null) {
      _accountCategoryController.sink.addError("Field is required");
    }
  }

  updateAccountType(String value) {
    _accountTypeController.sink.add(value);
  }

  insertFormOffline(OfflineAccountEntity offlineForm) async {
    var isEditMode = _isEditModeController.value == null
        ? false
        : _isEditModeController.value;
    try {
      if (isEditMode) {
        await _accountsRepository.updateAccountOffline(offlineForm);
      } else {
        await _accountsRepository.saveAccountOffline(offlineForm);
      }

      _subjectSaveOfflineAccountResponse.sink
          .add('Account has been saved offline successfully');
    } catch (error) {
      _subjectSaveOfflineAccountResponse.sink.addError(error);
    }
  }

  deleteFormOffline(int id) async {
    try {
      await _accountsRepository.deleteOfflineAccount(id);

      _subjectDeleteOfflineAccountResponse.sink.add('Account has been deleted');
    } catch (error) {
      _subjectDeleteOfflineAccountResponse.sink.addError(error);
    }
  }

  submit() async {
    var validRefenceId = _referenceIdController.value;

    var validAccountType = _accountTypeController.value;
    final validAccountHolderType = _accountHolderTypeController.value;
    final validAccountRiskRank = _riskRankController.value;
    var validAccountCategory = _accountCategoryController.value;

    List<AccountClassEntity> accountClasses =
        await DBProvider.db.getAccountClasses();

    validAccountCategory = accountClasses
        .firstWhere((x) => x.name == validAccountCategory)
        .id
        .toString(); //hotfix: to solve issue of account category filter from account type
    var validBvn = _bvnController.value;
    final validTitle = _titleController.value;
    final validSurname = _surnameController.value;
    final validFirstName = _firstNameController.value;
    var validOtherName = _otherNameController.value;
    final validMothersMaidenName = _mothersMaidenNameController.value;
    final validDateOfBirth = _dateOfBirthController.value;
    final validStateOfOrigin = _stateOfOriginController.value;
    final validCountryOfOrigin = _countryOfOriginController.value == null
        ? 'NIGERIA'
        : _countryOfOriginController.value; //workaround for bug

    var validEmail = _emailController.value;
    final validPhone = _phoneNumberController.value;
    final validNextOfKin = _nextOfKinController.value;
    final validAddress1 = _address1Controller.value;
    var validAddress2 = _address2Controller.value;
    final validCountryOfResidence = _countryOfResidenceController.value == null
        ? 'NIGERIA'
        : _countryOfResidenceController.value; //workaround for bug

    final validStateOfResidence = _stateOfResidenceController.value;
    final validCityOfResidence = _cityOfResidenceController.value;
    final validGender = _genderController.value;
    final validOccupation = occupationController.value;
    final validMaritalStatus = _maritalStatusController.value;

    var validIdType = _idTypeController.value;
    var validIdIssuer = _idIssuerController.value;
    var validIdNumber = _idNumberController.value;
    var validIdPlaceOfIssue = _idPlaceOfIssueController.value;
    var validIdIssueDate = _idIssueDateController.value;
    var validIdExpiryDate = _idExpiryDateController.value;
    final validIsSendEmail = _isSendEmailController.value;
    final validIsReceiveSms = _isReceiveSmsController.value;
    final validIsRequestHardwareToken = _isRequestHardwareTokenController.value;
    final validIsRequestInternetBanking =
        _isRequestInternetBankingController.value;

    final validUploadIdImageInBase64 = _uploadIdImageController.value;
    final validUploadPassportInBase64 = _uploadPassportController.value;
    final validUploadUtilityBillInBase64 = _uploadUtilityBillController.value;

    final validUploadSignatureInBase64 = _uploadSignatureController.value;

    if (validAccountType == null) {
      _accountTypeController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected an account type.");
      return;
    }

    if (validAccountHolderType == null) {
      _accountHolderTypeController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid account holder type.");
      return;
    }

    if (validAccountRiskRank == null) {
      _riskRankController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a risk rank.");
      return;
    }

    if (validAccountCategory == null) {
      _accountCategoryController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected an account category.");
      return;
    }

    if (validTitle == null) {
      _titleController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid title");

      return;
    }

    if (validSurname == null) {
      _surnameController.addError("Field is required");
      _subjectSaveAccountResponse.addError("You have not filled in a surname");

      return;
    }
    RegExp regex = new RegExp(pattern);

    if(validSurname != null &&  regex.hasMatch(validSurname)){
      _surnameController.addError("Enter a valid surname");
      _subjectSaveAccountResponse.addError("You have not entered a valid surname");
      return;
    }

    if (validFirstName == null) {
      _firstNameController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not filled in a valid firstname");

      return;
    }

    if(validFirstName != null && regex.hasMatch(validFirstName)){
      _firstNameController.addError("Enter a valid first name");
      _subjectSaveAccountResponse.addError("You have not entered in a valid firstname");

      return;
    }

    if (validMothersMaidenName == null) {
      _mothersMaidenNameController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not filled in a valid the mother\'s maiden name");

      return;
    }

    if(validMothersMaidenName != null && regex.hasMatch(validMothersMaidenName)){
      _mothersMaidenNameController.addError("Enter a valid mother\'s maiden name");
      _subjectSaveAccountResponse
          .addError("You have not entered in a valid the mother\'s maiden name");

      return;
    }

    if (validDateOfBirth == null) {
      _dateOfBirthController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid date of birth");

      return;
    }

    if (validStateOfOrigin == null) {
      _stateOfOriginController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid state of origin");

      return;
    }

    if (validCountryOfOrigin == null) {
      _countryOfOriginController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid country of origin");

      return;
    }

    if (validPhone == null) {
      _phoneNumberController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid phone number");

      return;
    }

    if (validNextOfKin == null) {
      _nextOfKinController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not filled in a next of kin");

      return;
    }

    if(validNextOfKin != null && regex.hasMatch(validNextOfKin)){
      _nextOfKinController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not filled in a valid next of kin");

      return;
    }

    if (validAddress1 == null) {
      _address1Controller.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not filled a valid main address");

      return;
    }

    if (validCountryOfResidence == null) {
      _countryOfResidenceController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid country of residence");

      return;
    }
    if (validStateOfResidence == null) {
      _stateOfResidenceController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a state of residence");
      return;
    }

    if (validCityOfResidence == null) {
      _cityOfResidenceController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid city of residence");
      return;
    }

    if (validGender == null) {
      _genderController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not chosen a valid gender");
      return;
    }

    if (validOccupation == null) {
      occupationController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid occupation");
      return;
    }

    if (validMaritalStatus == null) {
      _maritalStatusController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a marital status");

      return;
    }
    if (validIdType == null && validAccountCategory != easy_classic) {
      _idTypeController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid ID type");
      return;
    } else if (validIdType == null && validAccountCategory == easy_classic) {
      validIdType = "";
    }

    if (validIdIssuer == null && validAccountCategory != easy_classic) {
      _idIssuerController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not filled a valid ID Issuer");
      return;
    } else if (validIdIssuer == null && validAccountCategory == easy_classic) {
      validIdIssuer = "";
    }

    if (validIdNumber == null && validAccountCategory != easy_classic) {
      _idNumberController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid ID number");

      return;
    } else if (validIdNumber == null && validAccountCategory == easy_classic) {
      validIdNumber = "";
    }

    if (validIdPlaceOfIssue == null && validAccountCategory != easy_classic) {
      _idPlaceOfIssueController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid id place of issue");
      return;
    } else if (validIdPlaceOfIssue == null &&
        validAccountCategory == easy_classic) {
      validIdPlaceOfIssue = "";
    }

    if (validIdIssueDate == null && validAccountCategory != easy_classic) {
      _idIssueDateController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid issue date");

      return;
    } else if (validIdIssueDate == null &&
        validAccountCategory == easy_classic) {
      validIdIssueDate = "";
    }

    if (validIdExpiryDate == null && validAccountCategory != easy_classic) {
      _idExpiryDateController.addError("Field is required");
      _subjectSaveAccountResponse
          .addError("You have not selected a valid expiry date");

      return;
    } else if (validIdExpiryDate == null &&
        validAccountCategory == easy_classic) {
      validIdExpiryDate = "";
    }

    validAccountType = validAccountType.startsWith('S') ? "SA" : "CA";

    validOtherName = validOtherName != null ? validOtherName : "";

    validAddress2 = validAddress2 != null ? validAddress2 : "";

    validEmail = validEmail != null ? validEmail : "";

    validBvn = validBvn != null ? validBvn : "";

    var validSexAcronym = validGender.startsWith('M') ? "M" : "F";

    var validBranchNumber = await SecureStorage.getBranchNumber();
    var employeeId = await SecureStorage.getEmployeeId();

    var encryptedAccountName =
        CryptoHelper.encrypt('$validFirstName $validOtherName $validSurname');

    var currentTimeStamp = new DateTime.now().millisecondsSinceEpoch;

    var referenceId;

    if (validRefenceId != null) {
      referenceId = validRefenceId; //for updating accounts.
    } else {
      referenceId = '$employeeId${currentTimeStamp.toString().substring(7)}';
    }

    var isAlertRequest = validIsReceiveSms == true ? "Y" : "N";
    var isTokenRequest = validIsRequestHardwareToken == true ? "Y" : "N";
    var isIBankRequest = validIsRequestInternetBanking == true ? "Y" : "N";
    var isEmailStatement = validIsSendEmail == true ? "Y" : "N";

    List<Attachment> _attachments = new List();

    Attachment _idCardAttachment;
    Attachment _passportAttachment;
    Attachment _utilityBillAttachment;
    Attachment _signatoryAttachment;

    if (validUploadIdImageInBase64 != null) {
      _idCardAttachment = new Attachment(
          encodedImage: validUploadIdImageInBase64, type: 'IdentityCard');
      _attachments.add(_idCardAttachment);
    }

    if (validUploadPassportInBase64 != null) {
      _passportAttachment = new Attachment(
          encodedImage: validUploadPassportInBase64, type: 'PassportPhoto');
      _attachments.add(_passportAttachment);
    }

    if (validUploadUtilityBillInBase64 != null) {
      _utilityBillAttachment = new Attachment(
          encodedImage: validUploadUtilityBillInBase64, type: 'UtilityBill');
      _attachments.add(_utilityBillAttachment);
    }

    if (validUploadSignatureInBase64 != null) {
      _signatoryAttachment = new Attachment(
          encodedImage: validUploadSignatureInBase64, type: 'Signatory');
      _attachments.add(_signatoryAttachment);
    }

    SignatoryDetail _signatoryDetail = SignatoryDetail(
        firstName: CryptoHelper.encrypt(validFirstName),
        middleName: (validOtherName.isNotEmpty)
            ? CryptoHelper.encrypt(validOtherName)
            : '',
        lastName: CryptoHelper.encrypt(validSurname),
        sex: validSexAcronym,
        dateOfBirth: CryptoHelper.encrypt(validDateOfBirth),
        motherMaidenName: CryptoHelper.encrypt(validMothersMaidenName),
        title: validTitle,
        stateOfOrigin: validStateOfOrigin,
        countryOfOrigin: validCountryOfOrigin,
        meansOfId: validIdType,
        idNumber: validIdNumber,
        idIssuer: validIdIssuer,
        idPlaceOfIssue: validIdPlaceOfIssue,
        idIssueDate: validIdIssueDate,
        idExpiryDate: validIdExpiryDate,
        occupation: validOccupation,
        addressLine1: CryptoHelper.encrypt(validAddress1),
        addressLine2: (validAddress2.isNotEmpty)
            ? CryptoHelper.encrypt(validAddress2)
            : '',
        city: validCityOfResidence,
        state: validStateOfResidence,
        emailAddress:
            (validEmail.isNotEmpty) ? CryptoHelper.encrypt(validEmail) : '',
        phoneNumber: CryptoHelper.encrypt(validPhone),
        amlCustType: '10',
        amlCustNatureBusiness: '4',
        amlCustNature: '14',
        useEmailForStatement: isEmailStatement,
        bvn: (validBvn.isNotEmpty) ? CryptoHelper.encrypt(validBvn) : '',
        maritalStatus: validMaritalStatus,
        nextOfKin: CryptoHelper.encrypt(validNextOfKin),
        attachments: _attachments);

    List<SignatoryDetail> _signatoryDetails = new List();
    _signatoryDetails.add(_signatoryDetail);

    AccountForm _accountForm = AccountForm(
        accountType: validAccountType,
        accountHolderType: validAccountHolderType,
        classCode: validAccountCategory,
        branchNumber: validBranchNumber,
        phoneNumber: CryptoHelper.encrypt(validPhone),
        rsmId: employeeId,
        accountName: encryptedAccountName,
        sex: validSexAcronym,
        title: validTitle,
        dateOfBirth: CryptoHelper.encrypt(validDateOfBirth),
        dateOfIncorporation: '',
        businessNature: '',
        sector: '',
        industry: '',
        riskRank: validAccountRiskRank,
        addressLine1: CryptoHelper.encrypt(validAddress1),
        city: validCityOfResidence,
        state: validStateOfResidence,
        countryOfOrigin: validCountryOfOrigin,
        signatoryDetails: _signatoryDetails,
        refId: referenceId,
        alertZRequest: isAlertRequest,
        masterCardRequest: 'N',
        visaCardRequest: 'N',
        verveCardRequest: 'N',
        tokenRequest: isTokenRequest,
        ibankRequest: isIBankRequest);

    String json = jsonEncode(_accountForm);

    sendAccountsToApi(json);
//    print('Final Object: $json');

//    print(
//        'Account type is $validAccountType, and Account Holder is $validAccountHolderType, '
//        'valid Risk rank $validAccountRiskRank, valid category  = $validAccountCategory, upload id (base 64) - $validUploadIdImageInBase64');
  }

  BehaviorSubject<SaveAccountResponse> get subjectSaveAccountResponse =>
      _subjectSaveAccountResponse;

  PublishSubject<String> get subjectSaveOfflineAccountResponse =>
      _subjectSaveOfflineAccountResponse;

  PublishSubject<String> get subjectDeleteOfflineAccountResponse =>
      _subjectDeleteOfflineAccountResponse;

  PublishSubject<AccountDetailsResponse> get subjectAccountsDetailsResponse =>
      _subjectAccountsDetailsResponse;

  BehaviorSubject<String> get uploadIdImageController =>
      _uploadIdImageController;

  BehaviorSubject<String> get uploadUtilityBillController =>
      _uploadUtilityBillController;

  BehaviorSubject<String> get uploadPassportController =>
      _uploadPassportController;

  BehaviorSubject<String> get uploadSignatureController =>
      _uploadSignatureController;

  sendAccountsToApi(String encodedAccount) async {
    try {
      SaveAccountResponse response =
          await _accountsRepository.attemptSubmitAccountToApi(encodedAccount);

      var offlineId = _idController.value;
      if (offlineId != null) {
        await _accountsRepository.deleteOfflineAccount(offlineId);
      }
      _subjectSaveAccountResponse.sink.add(response);
    } catch (error) {
      _subjectSaveAccountResponse.sink.addError(error);
    }
  }

  verifyBvn() async {
    var encodedBVN = CryptoHelper.encrypt(_bvnController.value);

    await _accountsRepository.verifyBvn(encodedBVN).then((bvnResponse) {
      bvnVerificationResponse.add(bvnResponse);

      if (bvnResponse?.responseCode == '00') {
        if (bvnResponse.lastName != null && bvnResponse.lastName.isNotEmpty) {
          _surnameController.add(CryptoHelper.decrypt(bvnResponse.lastName));
          bvnlastNameValue = bvnResponse.lastName != null ? false : true;
        }
        if (bvnResponse.firstName != null && bvnResponse.firstName.isNotEmpty) {
          _firstNameController.add(CryptoHelper.decrypt(bvnResponse.firstName));
          bvnFirstName = bvnResponse.firstName.isNotEmpty ? false : true;
        }
        if (bvnResponse.middleName != null &&
            bvnResponse.middleName.isNotEmpty) {
          _otherNameController
              .add(CryptoHelper.decrypt(bvnResponse.middleName));
          bvnOtherName = bvnResponse.email.isNotEmpty ? false : true;
        }
        if (bvnResponse.email != null && bvnResponse.email.isNotEmpty) {
          _emailController.add(CryptoHelper.decrypt(bvnResponse.email));
          bvnEmail = bvnResponse.email.isNotEmpty ? false : true;
        }
        if (bvnResponse.title != null && bvnResponse.title.isNotEmpty) {
          _titleController.add(bvnResponse.title);
          bvnTitle = bvnResponse.title.isNotEmpty ? false : true;
        }
        if (bvnResponse.dateOfBirth != null &&
            bvnResponse.dateOfBirth.isNotEmpty) {
          _dateOfBirthController
              .add(CryptoHelper.decrypt(bvnResponse.dateOfBirth));

          bvnDateOfBirths = bvnResponse.dateOfBirth.isNotEmpty ? false : true;
          _isDateOfBirthChangeController.add(bvnDateOfBirths);
        }
        if (bvnResponse.gender != null && bvnResponse.gender.isNotEmpty) {
          _genderController.add(bvnResponse.gender);
          bvnGender = bvnResponse.gender.isNotEmpty ? false : true;
          _isGenderChangeController.add(bvnGender);
        }
        if (bvnResponse.phoneNumber != null &&
            bvnResponse.phoneNumber.isNotEmpty) {
          var decryptedPhone = CryptoHelper.decrypt(bvnResponse.phoneNumber);
          if (decryptedPhone != null && decryptedPhone.startsWith('0')) {
            decryptedPhone = decryptedPhone.replaceFirst('0', '');
            _phoneNumberController.add(decryptedPhone);
            bvnPhone = bvnResponse.phoneNumber.isNotEmpty ? false : true;
          }
        }
        if (bvnResponse.stateOfOrigin != null &&
            bvnResponse.stateOfOrigin.isNotEmpty) {
          _stateOfOriginController.add(bvnResponse.stateOfOrigin.toUpperCase());
          bvnState = bvnResponse.phoneNumber.isNotEmpty ? false : true;
          _isStateOfOriginChangeController.add(bvnState);
        }
        if (bvnResponse.maritalStatus != null &&
            bvnResponse.maritalStatus.isNotEmpty) {
          _maritalStatusController.add(bvnResponse.maritalStatus);
          bvnMaritalStatus =
              bvnResponse.maritalStatus.isNotEmpty ? false : true;
          _isMaritalStatusChangeController.add(bvnMaritalStatus);
        }
        if (bvnResponse.residentialAddress != null &&
            bvnResponse.residentialAddress.isNotEmpty) {
          _address1Controller
              .add(CryptoHelper.decrypt(bvnResponse.residentialAddress));
          bvnResidentialAddress =
              bvnResponse.residentialAddress.isNotEmpty ? false : true;
        }
        if (bvnResponse.stateOfResidence != null &&
            bvnResponse.stateOfResidence.isNotEmpty) {
          _stateOfResidenceController.add(bvnResponse.stateOfResidence);
          bvnStateOfResidence =
              bvnResponse.stateOfResidence.isNotEmpty ? false : true;
          _isStateOfResidenceChangeController.add(bvnStateOfResidence);
        }
      } else {
        bvnVerificationResponse.addError('Could not verify the BVN provided. ');
      }
    }).catchError((error) {
      bvnVerificationResponse.addError(error);
    });
  }

  @override
  dispose() {
    _subjectSaveOfflineAccountResponse.close();
    _subjectSaveAccountResponse.close();
    _accountTypeController.close();
    _accountHolderTypeController.close();
    _riskRankController.close();
    _accountCategoryController.close();
    _bvnController.close();
    _titleController.close();
    _surnameController.close();
    _firstNameController.close();
    _otherNameController.close();
    _mothersMaidenNameController.close();
    _dateOfBirthController.close();
    _stateOfOriginController.close();
    _countryOfOriginController.close();
    _emailController.close();
    _phoneNumberController.close();
    _nextOfKinController.close();
    _address1Controller.close();
    _address2Controller.close();
    _countryOfResidenceController.close();
    _stateOfResidenceController.close();
    _cityOfResidenceController.close();
    _genderController.close();
    occupationController.close();
    _maritalStatusController.close();
    _idTypeController.close();
    _idIssuerController.close();
    _idNumberController.close();
    _idPlaceOfIssueController.close();
    _idIssueDateController.close();
    _idExpiryDateController.close();
    _isSendEmailController.close();
    _isReceiveSmsController.close();
    _isRequestHardwareTokenController.close();
    _isRequestInternetBankingController.close();
    _uploadIdImageController.close();
    _uploadPassportController.close();
    _uploadUtilityBillController.close();
    _uploadSignatureController.close();
    bvnVerificationResponse.close();
    _subjectAccountsDetailsResponse.close();
    _referenceIdController.close();
    uploadSignatureController.close();
    _subjectOfflineDetailsResponse.close();
    _isEditModeController.close();
    _idController.close();
    _subjectDeleteOfflineAccountResponse.close();
  }

  final PublishSubject<String> _subjectOfflineDetailsResponse =
      PublishSubject<String>();

  PublishSubject<String> get subjectOfflineDetailsResponse =>
      _subjectOfflineDetailsResponse;

  getOfflineAccountDetailsByRefId(String referenceId) async {
    _isEditModeController.add(true);

    await _accountsRepository
        .getOfflineAccountByRefId(referenceId)
        .then((offlineAccount) {
      if (offlineAccount != null) {
        _idController.add(offlineAccount.id);
        _subjectOfflineDetailsResponse.add("Account retrieved successfully.");
        if (offlineAccount.accountType == 'SA') {
          _accountTypeController.add('SAVINGS ACCOUNT');
        } else {
          _accountTypeController.add('CURRENT ACCOUNT');
        }

        _accountHolderTypeController.add('INDIVIDUAL');

        if (offlineAccount.riskRank != null &&
            offlineAccount.riskRank.isNotEmpty) {
          _riskRankController.add(offlineAccount.riskRank);
        }

        if (offlineAccount.accountCategory != null &&
            offlineAccount.accountCategory.isNotEmpty) {
          _accountCategoryController.add(offlineAccount.accountCategory);
        }

        if (offlineAccount.bvn != null && offlineAccount.bvn.isNotEmpty) {
          _bvnController.add(offlineAccount.bvn);
        }

        if (offlineAccount.title != null && offlineAccount.title.isNotEmpty) {
          _titleController.add(offlineAccount.title);
        }

        if (offlineAccount.surname != null &&
            offlineAccount.surname.isNotEmpty) {
          _surnameController.add(offlineAccount.surname);
        }
        if (offlineAccount.firstName != null &&
            offlineAccount.firstName.isNotEmpty) {
          _firstNameController.add(offlineAccount.firstName);
        }

        if (offlineAccount.otherName != null &&
            offlineAccount.otherName.isNotEmpty) {
          _otherNameController.add(offlineAccount.otherName);
        }

        if (offlineAccount.mothersMaidenName != null &&
            offlineAccount.mothersMaidenName.isNotEmpty) {
          _mothersMaidenNameController.add(offlineAccount.mothersMaidenName);
        }

        if (offlineAccount.dateOfBirth != null &&
            offlineAccount.dateOfBirth.isNotEmpty) {
          _dateOfBirthController.add(offlineAccount.dateOfBirth);
        }

        if (offlineAccount.stateOfOrigin != null &&
            offlineAccount.stateOfOrigin.isNotEmpty) {
          _stateOfOriginController.add(offlineAccount.stateOfOrigin);
        }
        _countryOfOriginController.add('NIGERIA');

        if (offlineAccount.email != null && offlineAccount.email.isNotEmpty) {
          _emailController.add(offlineAccount.email);
        }

        if (offlineAccount.phone != null && offlineAccount.phone.isNotEmpty) {
          _phoneNumberController.add(offlineAccount.phone);
        }

        if (offlineAccount.nextOfKin != null &&
            offlineAccount.nextOfKin.isNotEmpty) {
          _nextOfKinController.add(offlineAccount.nextOfKin);
        }

        if (offlineAccount.address1 != null &&
            offlineAccount.address1.isNotEmpty) {
          _address1Controller.add(offlineAccount.address1);
        }

        if (offlineAccount.address2 != null &&
            offlineAccount.address2.isNotEmpty) {
          _address2Controller.add(offlineAccount.address2);
        }

        if (offlineAccount.stateOfResidence != null &&
            offlineAccount.stateOfResidence.isNotEmpty) {
          _stateOfResidenceController.add(offlineAccount.stateOfResidence);
        }
        if (offlineAccount.cityOfResidence != null &&
            offlineAccount.cityOfResidence.isNotEmpty) {
          _cityOfResidenceController.add(offlineAccount.cityOfResidence);
        }

        if (offlineAccount.gender != null && offlineAccount.gender.isNotEmpty) {
          if (offlineAccount.gender == 'M') {
            _genderController.add('MALE');
          } else {
            _genderController.add('FEMALE');
          }
        }

        if (offlineAccount.occupation != null &&
            offlineAccount.occupation.isNotEmpty) {
          occupationController.add(offlineAccount.occupation);
        }

        if (offlineAccount.maritalStatus != null &&
            offlineAccount.maritalStatus.isNotEmpty) {
          _maritalStatusController.add(offlineAccount.maritalStatus);
        }

        if (offlineAccount.idType != null && offlineAccount.idType.isNotEmpty) {
          _idTypeController.add(offlineAccount.idType);
        }

        if (offlineAccount.idIssuer != null &&
            offlineAccount.idIssuer.isNotEmpty) {
          _idIssuerController.add(offlineAccount.idIssuer);
        }

        if (offlineAccount.idNumber != null &&
            offlineAccount.idNumber.isNotEmpty) {
          _idNumberController.add(offlineAccount.idNumber);
        }
        if (offlineAccount.idPlaceOfIssue != null &&
            offlineAccount.idPlaceOfIssue.isNotEmpty) {
          _idPlaceOfIssueController.add(offlineAccount.idPlaceOfIssue);
        }

        if (offlineAccount.idIssueDate != null &&
            offlineAccount.idIssueDate.isNotEmpty) {
          _idIssueDateController.add(offlineAccount.idIssueDate);
        }
        if (offlineAccount.idExpiryDate != null &&
            offlineAccount.idExpiryDate.isNotEmpty) {
          _idExpiryDateController.add(offlineAccount.idExpiryDate);
        }

        _isSendEmailController.add(offlineAccount.isSendEmail);
        _isReceiveSmsController.add(offlineAccount.isReceiveAlert);
        _isRequestHardwareTokenController
            .add(offlineAccount.isRequestHardwareToken);
        _isRequestInternetBankingController
            .add(offlineAccount.isRequestInternetBanking);

        if (offlineAccount.idCard != null && offlineAccount.idCard.isNotEmpty) {
          _uploadIdImageController.add(offlineAccount.idCard);
        }

        if (offlineAccount.passport != null &&
            offlineAccount.passport.isNotEmpty) {
          _uploadPassportController.add(offlineAccount.passport);
        }
        if (offlineAccount.utility != null &&
            offlineAccount.utility.isNotEmpty) {
          _uploadUtilityBillController.add(offlineAccount.utility);
        }
        if (offlineAccount.signature != null &&
            offlineAccount.signature.isNotEmpty) {
          _uploadSignatureController.add(offlineAccount.signature);
        }
      } else {
        _subjectOfflineDetailsResponse
            .addError('Unable to retrieve account, try again later');
      }
    }).catchError((error) {
      _subjectOfflineDetailsResponse.addError('$error');
    });
  }

  getAccountsDetailsByReferenceId(String referenceId) async {
    _referenceIdController.add(referenceId);

    await _accountsRepository
        .getAccountsDetailsByReference(referenceId)
        .then((accountResponse) async {
      subjectAccountsDetailsResponse.add(accountResponse);
      if (accountResponse.status) {
//        if (accountResponse.data.refId != null &&
//            accountResponse.data.refId.isNotEmpty) {
//          _referenceIdController.add(accountResponse.data.refId);
//        }

        if (accountResponse.data.accountType != null &&
            accountResponse.data.accountType.isNotEmpty) {
          if (accountResponse.data.accountType == 'SA') {
            _accountTypeController.add('SAVINGS ACCOUNT');
          } else {
            _accountTypeController.add('CURRENT ACCOUNT');
          }
        }
        _accountHolderTypeController.add('INDIVIDUAL');
        if (accountResponse.data.riskRank != null &&
            accountResponse.data.riskRank.isNotEmpty) {
          _riskRankController.add(accountResponse.data.riskRank);
        }

        if (accountResponse.data.classCode != null &&
            accountResponse.data.classCode.isNotEmpty) {
          print('log class code ${accountResponse.data.classCode}');

          try {
            List<AccountClassEntity> accountClasses =
                await DBProvider.db.getAccountClasses();

            var accountCategory = accountClasses
                .firstWhere(
                    (x) => x.id.toString() == accountResponse.data.classCode)
                .name
                .toString(); //hotfix: to solve issue of account category filter from account type on edit

            if (accountCategory != null)
              _accountCategoryController.add(accountCategory);
          } catch (err) {
            _accountCategoryController.add(accountResponse.data.classCode);
          }
        }
        if (accountResponse.data.signatoryDetails?.first?.bvn != null &&
            accountResponse.data.signatoryDetails.first.bvn.isNotEmpty) {
          _bvnController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.bvn));
        }

        if (accountResponse.data.title != null &&
            accountResponse.data.title.isNotEmpty) {
          _titleController.add(accountResponse.data.title);
        }
        if (accountResponse.data.signatoryDetails?.first?.lastName != null &&
            accountResponse.data.signatoryDetails.first.lastName.isNotEmpty) {
          _surnameController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.lastName));
        }
        if (accountResponse.data.signatoryDetails?.first?.firstName != null &&
            accountResponse.data.signatoryDetails.first.firstName.isNotEmpty) {
          _firstNameController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.firstName));
        }

        if (accountResponse.data.signatoryDetails?.first?.middleName != null &&
            accountResponse.data.signatoryDetails.first.middleName.isNotEmpty) {
          _otherNameController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.middleName));
        }

//        if (accountResponse.data.signatoryDetails?.first?.middleName != null &&
//            accountResponse.data.signatoryDetails.first.middleName.isNotEmpty) {
//          _otherNameController.add(CryptoHelper.decrypt(
//              accountResponse.data.signatoryDetails.first.middleName));
//        }

        if (accountResponse.data.signatoryDetails?.first?.motherMaidenName !=
                null &&
            accountResponse
                .data.signatoryDetails.first.motherMaidenName.isNotEmpty) {
          _mothersMaidenNameController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.motherMaidenName));
        }

        if (accountResponse.data.signatoryDetails?.first?.dateOfBirth != null &&
            accountResponse
                .data.signatoryDetails.first.dateOfBirth.isNotEmpty) {
          _dateOfBirthController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.dateOfBirth));
        }

//        if (accountResponse.data.signatoryDetails?.first?.dateOfBirth != null &&
//            accountResponse
//                .data.signatoryDetails.first.dateOfBirth.isNotEmpty) {
//          _dateOfBirthController.add(CryptoHelper.decrypt(
//              accountResponse.data.signatoryDetails.first.dateOfBirth));
//        }

        if (accountResponse.data.signatoryDetails?.first?.stateOfOrigin !=
                null &&
            accountResponse
                .data.signatoryDetails.first.stateOfOrigin.isNotEmpty) {
          _stateOfOriginController
              .add(accountResponse.data.signatoryDetails.first.stateOfOrigin);
        }
        _countryOfOriginController.add('NIGERIA');

        if (accountResponse.data.signatoryDetails?.first?.emailAddress !=
                null &&
            accountResponse
                .data.signatoryDetails.first.emailAddress.isNotEmpty) {
          _emailController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.emailAddress));
        }

        if (accountResponse.data.signatoryDetails?.first?.phoneNumber != null &&
            accountResponse
                .data.signatoryDetails.first.phoneNumber.isNotEmpty) {
          _phoneNumberController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.phoneNumber));
        }

        if (accountResponse.data.signatoryDetails?.first?.nextOfKin != null &&
            accountResponse.data.signatoryDetails.first.nextOfKin.isNotEmpty) {
          _nextOfKinController.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.nextOfKin));
        }

        if (accountResponse.data.signatoryDetails?.first?.addressLine1 !=
                null &&
            accountResponse
                .data.signatoryDetails.first.addressLine1.isNotEmpty) {
          _address1Controller.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.addressLine1));
        }

        if (accountResponse.data.signatoryDetails?.first?.addressLine2 !=
                null &&
            accountResponse
                .data.signatoryDetails.first.addressLine2.isNotEmpty) {
          _address2Controller.add(CryptoHelper.decrypt(
              accountResponse.data.signatoryDetails.first.addressLine2));
        }
        _countryOfResidenceController.add('NIGERIA');

        if (accountResponse.data.signatoryDetails?.first?.state != null &&
            accountResponse.data.signatoryDetails.first.state.isNotEmpty) {
          _stateOfResidenceController
              .add(accountResponse.data.signatoryDetails.first.state);
        }

        if (accountResponse.data.signatoryDetails?.first?.city != null &&
            accountResponse.data.signatoryDetails.first.city.isNotEmpty) {
          _cityOfResidenceController
              .add(accountResponse.data.signatoryDetails.first.city);
        }
        if (accountResponse.data.signatoryDetails?.first?.sex != null &&
            accountResponse.data.signatoryDetails.first.sex.isNotEmpty) {
          if (accountResponse.data.signatoryDetails.first.sex == 'M') {
            _genderController.add('MALE');
          } else {
            _genderController.add('FEMALE');
          }
        }
        if (accountResponse.data.signatoryDetails?.first?.occupation != null &&
            accountResponse.data.signatoryDetails.first.occupation.isNotEmpty) {
          occupationController
              .add(accountResponse.data.signatoryDetails.first.occupation);
        }
        if (accountResponse.data.signatoryDetails?.first?.maritalStatus !=
                null &&
            accountResponse
                .data.signatoryDetails.first.maritalStatus.isNotEmpty) {
          _maritalStatusController
              .add(accountResponse.data.signatoryDetails.first.maritalStatus);
        }

        if (accountResponse.data.signatoryDetails?.first?.meansOfId != null &&
            accountResponse.data.signatoryDetails.first.meansOfId.isNotEmpty) {
          _idTypeController
              .add(accountResponse.data.signatoryDetails.first.meansOfId);
        }
        if (accountResponse.data.signatoryDetails?.first?.idIssuer != null &&
            accountResponse.data.signatoryDetails.first.idIssuer.isNotEmpty) {
          _idIssuerController
              .add(accountResponse.data.signatoryDetails.first.idIssuer);
        }
        if (accountResponse.data.signatoryDetails?.first?.idNumber != null &&
            accountResponse.data.signatoryDetails.first.idNumber.isNotEmpty) {
          _idNumberController
              .add(accountResponse.data.signatoryDetails.first.idNumber);
        }
        if (accountResponse.data.signatoryDetails?.first?.idPlaceOfIssue !=
                null &&
            accountResponse
                .data.signatoryDetails.first.idPlaceOfIssue.isNotEmpty) {
          _idPlaceOfIssueController
              .add(accountResponse.data.signatoryDetails.first.idPlaceOfIssue);
        }
        if (accountResponse.data.signatoryDetails?.first?.idIssueDate != null &&
            accountResponse
                .data.signatoryDetails.first.idIssueDate.isNotEmpty) {
          _idIssueDateController
              .add(accountResponse.data.signatoryDetails.first.idIssueDate);
        }
        if (accountResponse.data.signatoryDetails?.first?.idExpiryDate !=
                null &&
            accountResponse
                .data.signatoryDetails.first.idExpiryDate.isNotEmpty) {
          _idExpiryDateController
              .add(accountResponse.data.signatoryDetails.first.idExpiryDate);
        }
        if (accountResponse
                    .data.signatoryDetails?.first?.useEmailForStatement !=
                null &&
            accountResponse
                .data.signatoryDetails.first.useEmailForStatement.isNotEmpty) {
          if (accountResponse
                  .data.signatoryDetails.first.useEmailForStatement ==
              "Y") {
            _isSendEmailController.add(true);
          }
        }

        if (accountResponse.data?.alertZRequest != null &&
            accountResponse.data.alertZRequest.isNotEmpty) {
          if (accountResponse.data.alertZRequest == "Y") {
            _isReceiveSmsController.add(true);
          }
        }
        if (accountResponse.data?.tokenRequest != null &&
            accountResponse.data.tokenRequest.isNotEmpty) {
          if (accountResponse.data.tokenRequest == "Y") {
            _isRequestHardwareTokenController.add(true);
          }
        }
        if (accountResponse.data?.ibankRequest != null &&
            accountResponse.data.ibankRequest.isNotEmpty) {
          if (accountResponse.data.ibankRequest == "Y") {
            _isRequestInternetBankingController.add(true);
          }
        }

        if (accountResponse.data.signatoryDetails?.first?.attachments != null) {
          var _idCardAttachment = accountResponse
              .data.signatoryDetails.first.attachments
              .where((i) => i.type == 'IdentityCard')
              .toList();

          var _passportAttachment = accountResponse
              .data.signatoryDetails.first.attachments
              .where((i) => i.type == 'PassportPhoto')
              .toList();

          var _utilityBillAttachment = accountResponse
              .data.signatoryDetails.first.attachments
              .where((i) => i.type == 'UtilityBill')
              .toList();

          var _signatoryAttachment = accountResponse
              .data.signatoryDetails.first.attachments
              .where((i) => i.type == 'Signatory')
              .toList();

          if (_idCardAttachment.length != 0 &&
              _idCardAttachment.first != null) {
            _uploadIdImageController.add(_idCardAttachment.first.encodedImage);
          }

          if (_passportAttachment.length != 0 &&
              _passportAttachment.first != null) {
            _uploadPassportController
                .add(_passportAttachment.first.encodedImage);
          }

          if (_utilityBillAttachment.length != 0 &&
              _utilityBillAttachment.first != null) {
            _uploadUtilityBillController
                .add(_utilityBillAttachment.first.encodedImage);
          }

          if (_signatoryAttachment.length != 0 &&
              _signatoryAttachment.first != null) {
            _uploadSignatureController
                .add(_signatoryAttachment.first.encodedImage);
          }
        }
      } else {
        _subjectAccountsDetailsResponse.addError(accountResponse?.message);
      }
    }).catchError((error) {
      _subjectAccountsDetailsResponse.addError(error);
    });
  }
}

//Note: This creates a global instance of Bloc that's automatically exported and can be accessed anywhere in the app
//final bloc = Bloc();
