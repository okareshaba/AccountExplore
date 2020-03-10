final String tableOfflineAccount = 'OfflineAccount';
final String columnOfflineId = "id";
final String columnOfflineReferenceId = "referenceId";
final String columnOfflineAccountType = "accountType";
final String columnOfflineAccountHolderType = "accountHolderType";
final String columnOfflineRiskRank = "riskRank";
final String columnOfflineAccountCategory = "accountCategory";
final String columnOfflineBVN = "bvn";
final String columnOfflineTitle = "title";
final String columnOfflineSurname = "surname";
final String columnOfflineFirstName = "firstName";
final String columnOfflineOtherName = "otherName";
final String columnOfflineMothersMaidenName = "mothersMaidenName";
final String columnOfflineDateOfBirth = "dateOfBirth";
final String columnOfflineStateOfOrigin = "stateOfOrigin";
final String columnOfflineCountryOfOrigin = "countryOfOrigin";
final String columnOfflineEmail = "email";
final String columnOfflinePhone = "phone";
final String columnOfflineNextOfKin = "nextOfKin";
final String columnOfflineAddress1 = "address1";
final String columnOfflineAddress2 = "address2";
final String columnOfflineCountryOfResidence = "countryOfResidence";
final String columnOfflineStateOfResidence = "stateOfResidence";
final String columnOfflineCityOfResidence = "cityOfResidence";
final String columnOfflineGender = "gender";
final String columnOfflineOccupation = "occupation";
final String columnOfflineMaritalStatus = "maritalStatus";
final String columnOfflineIdType = "idType";
final String columnOfflineIdIssuer = "idIssuer";
final String columnOfflineIdNumber = "idNumber";
final String columnOfflineIdPlaceOfIssue = "idPlaceOfIssue";
final String columnOfflineIdIssueDate = "idIssueDate";
final String columnOfflineIdExpiryDate = "idExpiryDate";
final String columnOfflineIsSendEmail = "isSendEmail";
final String columnOfflineIsReceiveAlert = "isReceiveAlert";
final String columnOfflineIsRequestHardwareToken = "isRequestHardwareToken";
final String columnOfflineIsRequestInternetBanking = "isRequestInternetBanking";
final String columnOfflineIdCard = "idCard";
final String columnOfflinePassport = "passport";
final String columnOfflineUtility = "utility";
final String columnOfflineSignature = "signature";

class OfflineAccountEntity {
  //database fields
  int id;
  String referenceId;
  String accountType;
  String accountHolderType;
  String riskRank;
  String accountCategory;
  String bvn;
  String title;
  String surname;
  String firstName;
  String otherName;
  String mothersMaidenName;
  String dateOfBirth;
  String stateOfOrigin;
  String countryOfOrigin;
  String email;
  String phone;
  String nextOfKin;
  String address1;
  String address2;
  String countryOfResidence;
  String stateOfResidence;
  String cityOfResidence;
  String gender;
  String occupation;
  String maritalStatus;
  String idType;
  String idIssuer;
  String idNumber;
  String idPlaceOfIssue;
  String idIssueDate;
  String idExpiryDate;
  bool isSendEmail;
  bool isReceiveAlert;
  bool isRequestHardwareToken;
  bool isRequestInternetBanking;
  String idCard;
  String passport;
  String utility;
  String signature;

  OfflineAccountEntity(
      {this.id,
      this.referenceId,
      this.accountType,
      this.accountHolderType,
      this.riskRank,
      this.accountCategory,
      this.bvn,
      this.title,
      this.surname,
      this.firstName,
      this.otherName,
      this.mothersMaidenName,
      this.dateOfBirth,
      this.stateOfOrigin,
      this.countryOfOrigin,
      this.email,
      this.phone,
      this.nextOfKin,
      this.address1,
      this.address2,
      this.countryOfResidence,
      this.stateOfResidence,
      this.cityOfResidence,
      this.gender,
      this.occupation,
      this.maritalStatus,
      this.idType,
      this.idIssuer,
      this.idNumber,
      this.idPlaceOfIssue,
      this.idIssueDate,
      this.idExpiryDate,
      this.isSendEmail,
      this.isReceiveAlert,
      this.isRequestHardwareToken,
      this.isRequestInternetBanking,
      this.idCard,
      this.passport,
      this.utility,
      this.signature});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[columnOfflineId] = id;
    map[columnOfflineReferenceId] = referenceId;
    map[columnOfflineAccountType] = accountType;
    map[columnOfflineAccountHolderType] = accountHolderType;
    map[columnOfflineRiskRank] = riskRank;
    map[columnOfflineAccountCategory] = accountCategory;
    map[columnOfflineBVN] = bvn;
    map[columnOfflineTitle] = title;
    map[columnOfflineSurname] = surname;
    map[columnOfflineFirstName] = firstName;
    map[columnOfflineMothersMaidenName] = mothersMaidenName;
    map[columnOfflineMothersMaidenName] = dateOfBirth;
    map[columnOfflineStateOfOrigin] = stateOfOrigin;
    map[columnOfflineCountryOfOrigin] = countryOfOrigin;
    map[columnOfflineEmail] = email;
    map[columnOfflinePhone] = phone;
    map[columnOfflineNextOfKin] = nextOfKin;
    map[columnOfflineAddress1] = address1;
    map[columnOfflineAddress2] = address2;
    map[columnOfflineCityOfResidence] = countryOfResidence;
    map[columnOfflineStateOfResidence] = stateOfResidence;
    map[columnOfflineCityOfResidence] = cityOfResidence;
    map[columnOfflineGender] = gender;
    map[columnOfflineOccupation] = occupation;
    map[columnOfflineMaritalStatus] = maritalStatus;
    map[columnOfflineIdType] = idType;
    map[columnOfflineIdNumber] = idNumber;
    map[columnOfflineIdPlaceOfIssue] = idPlaceOfIssue;
    map[columnOfflineIdIssueDate] = idIssueDate;
    map[columnOfflineIdExpiryDate] = idExpiryDate;
    map[columnOfflineIsSendEmail] = isSendEmail;
    map[columnOfflineIsReceiveAlert] = isReceiveAlert;
    map[columnOfflineIsRequestHardwareToken] = isRequestHardwareToken;
    map[columnOfflineIsRequestInternetBanking] = isRequestInternetBanking;
    map[columnOfflineIdCard] = idCard;
    map[columnOfflinePassport] = passport;
    map[columnOfflineUtility] = utility;
    map[columnOfflineSignature] = signature;

    return map;
  }

  factory OfflineAccountEntity.fromMap(Map<String, dynamic> json) =>
      new OfflineAccountEntity(
          id: json[columnOfflineId],
          referenceId: json[columnOfflineReferenceId],
          accountType: json[columnOfflineAccountType],
          accountHolderType: json[columnOfflineAccountHolderType],
          riskRank: json[columnOfflineRiskRank],
          accountCategory: json[columnOfflineAccountCategory],
          bvn: json[columnOfflineBVN],
          title: json[columnOfflineTitle],
          surname: json[columnOfflineSurname],
          firstName: json[columnOfflineFirstName],
          mothersMaidenName: json[columnOfflineMothersMaidenName],
          dateOfBirth: json[columnOfflineMothersMaidenName],
          stateOfOrigin: json[columnOfflineStateOfOrigin],
          countryOfOrigin: json[columnOfflineCountryOfOrigin],
          email: json[columnOfflineEmail],
          phone: json[columnOfflinePhone],
          nextOfKin: json[columnOfflineNextOfKin],
          address1: json[columnOfflineAddress1],
          address2: json[columnOfflineAddress2],
          countryOfResidence: json[columnOfflineCityOfResidence],
          stateOfResidence: json[columnOfflineStateOfResidence],
          cityOfResidence: json[columnOfflineCityOfResidence],
          gender: json[columnOfflineGender],
          occupation: json[columnOfflineOccupation],
          maritalStatus: json[columnOfflineMaritalStatus],
          idType: json[columnOfflineIdType],
          idNumber: json[columnOfflineIdNumber],
          idPlaceOfIssue: json[columnOfflineIdPlaceOfIssue],
          idIssueDate: json[columnOfflineIdIssueDate],
          idExpiryDate: json[columnOfflineIdExpiryDate],
          isSendEmail: json[columnOfflineIsSendEmail] == 0 ? false : true,
          isReceiveAlert: json[columnOfflineIsReceiveAlert] == 0 ? false : true,
          isRequestHardwareToken: json[columnOfflineIsRequestHardwareToken] == 0 ? false : true,
          isRequestInternetBanking: json[columnOfflineIsRequestInternetBanking] == 0 ? false : true,
          idCard: json[columnOfflineIdCard],
          passport: json[columnOfflinePassport],
          utility: json[columnOfflineUtility],
          signature: json[columnOfflineSignature]);


}
