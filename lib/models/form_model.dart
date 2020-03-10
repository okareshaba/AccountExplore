// To parse this JSON data, do
//
//     final accountForm = accountFormFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

AccountForm accountFormFromJson(String str) =>
    AccountForm.fromJson(json.decode(str));

String accountFormToJson(AccountForm data) => json.encode(data.toJson());

class AccountForm {
  String accountType;
  String accountNumber;
  String accountHolderType;
  String classCode;
  String branchNumber;
  String phoneNumber;
  String rsmId;
  String accountName;
  String tin;
  String registrationNumber;
  String sex;
  String title;
  String dateOfBirth;
  String dateOfIncorporation;
  String businessNature;
  String sector;
  String industry;
  String riskRank;
  String addressLine1;
  String city;
  String state;
  String countryOfOrigin;
  List<SignatoryDetail> signatoryDetails;
  String refId;
  String alertZRequest;
  String masterCardRequest;
  String visaCardRequest;
  String verveCardRequest;
  String tokenRequest;
  String ibankRequest;

  AccountForm({
    @required this.accountType,
    @required this.accountNumber,
    @required this.accountHolderType,
    @required this.classCode,
    @required this.branchNumber,
    @required this.phoneNumber,
    @required this.rsmId,
    @required this.accountName,
    @required this.tin,
    @required this.registrationNumber,
    @required this.sex,
    @required this.title,
    @required this.dateOfBirth,
    @required this.dateOfIncorporation,
    @required this.businessNature,
    @required this.sector,
    @required this.industry,
    @required this.riskRank,
    @required this.addressLine1,
    @required this.city,
    @required this.state,
    @required this.countryOfOrigin,
    @required this.signatoryDetails,
    @required this.refId,
    @required this.alertZRequest,
    @required this.masterCardRequest,
    @required this.visaCardRequest,
    @required this.verveCardRequest,
    @required this.tokenRequest,
    @required this.ibankRequest,
  });

  factory AccountForm.fromJson(Map<String, dynamic> json) => new AccountForm(
        accountType: json["AccountType"],
        accountNumber: json["AccountNumber"],
        accountHolderType: json["AccountHolderType"],
        classCode: json["ClassCode"],
        branchNumber: json["BranchNumber"],
        phoneNumber: json["PhoneNumber"],
        rsmId: json["RSMId"],
        accountName: json["AccountName"],
        tin: json["TIN"],
        registrationNumber: json["RegistrationNumber"],
        sex: json["Sex"],
        title: json["Title"],
        dateOfBirth: json["DateOfBirth"],
        dateOfIncorporation: json["DateOfIncorporation"],
        businessNature: json["BusinessNature"],
        sector: json["Sector"],
        industry: json["Industry"],
        riskRank: json["RiskRank"],
        addressLine1: json["AddressLine1"],
        city: json["City"],
        state: json["State"],
        countryOfOrigin: json["CountryOfOrigin"],
        signatoryDetails: new List<SignatoryDetail>.from(
            json["SignatoryDetails"].map((x) => SignatoryDetail.fromJson(x))),
        refId: json["Ref_Id"],
        alertZRequest: json["AlertZRequest"],
        masterCardRequest: json["MasterCardRequest"],
        visaCardRequest: json["VisaCardRequest"],
        verveCardRequest: json["VerveCardRequest"],
        tokenRequest: json["TokenRequest"],
        ibankRequest: json["IbankRequest"],
      );

  Map<String, dynamic> toJson() => {
        "AccountType": accountType,
        "AccountNumber": accountNumber,
        "AccountHolderType": accountHolderType,
        "ClassCode": classCode,
        "BranchNumber": branchNumber,
        "PhoneNumber": phoneNumber,
        "RSMId": rsmId,
        "AccountName": accountName,
        "TIN": tin,
        "RegistrationNumber": registrationNumber,
        "Sex": sex,
        "Title": title,
        "DateOfBirth": dateOfBirth,
        "DateOfIncorporation": dateOfIncorporation,
        "BusinessNature": businessNature,
        "Sector": sector,
        "Industry": industry,
        "RiskRank": riskRank,
        "AddressLine1": addressLine1,
        "City": city,
        "State": state,
        "CountryOfOrigin": countryOfOrigin,
        "SignatoryDetails":
            new List<dynamic>.from(signatoryDetails.map((x) => x.toJson())),
        "Ref_Id": refId,
        "AlertZRequest": alertZRequest,
        "MasterCardRequest": masterCardRequest,
        "VisaCardRequest": visaCardRequest,
        "VerveCardRequest": verveCardRequest,
        "TokenRequest": tokenRequest,
        "IbankRequest": ibankRequest,
      };
}

class SignatoryDetail {
  @required
  String firstName;
  String middleName;
  String lastName;
  String sex;
  String dateOfBirth;
  String motherMaidenName;
  String title;
  String stateOfOrigin;
  String countryOfOrigin;
  String meansOfId;
  String idNumber;
  String idIssuer;
  String idPlaceOfIssue;
  String idIssueDate;
  String idExpiryDate;
  String occupation;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String emailAddress;
  String phoneNumber;
  String fax;
  String tin;
  String permitType;
  String cerpacRpIdNo;
  String cerpacRPplaceofIssue;
  String cerpacRpIssueAuth;
  String visaNo;
  String arrivalDate;
  String permitValidFrom;
  String permitValidTo;
  String foreignAddress1;
  String foreignAddress2;
  String studentLevel;
  String yearOfGraduation;
  String faculty;
  String department;
  String amlCustType;
  String amlCustNature;
  String amlCustNatureBusiness;
  String useEmailForStatement;
  String passportUrl;
  String signatureUrl;
  String utilityUrl;
  String bvn;
  String maritalStatus;
  String nextOfKin;
  List<Attachment> attachments;

  SignatoryDetail({
    this.firstName,
    this.middleName,
    this.lastName,
    this.sex,
    this.dateOfBirth,
    this.motherMaidenName,
    this.title,
    this.stateOfOrigin,
    this.countryOfOrigin,
    this.meansOfId,
    this.idNumber,
    this.idIssuer,
    this.idPlaceOfIssue,
    this.idIssueDate,
    this.idExpiryDate,
    this.occupation,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.emailAddress,
    this.phoneNumber,
    this.fax,
    this.tin,
    this.permitType,
    this.cerpacRpIdNo,
    this.cerpacRPplaceofIssue,
    this.cerpacRpIssueAuth,
    this.visaNo,
    this.arrivalDate,
    this.permitValidFrom,
    this.permitValidTo,
    this.foreignAddress1,
    this.foreignAddress2,
    this.studentLevel,
    this.yearOfGraduation,
    this.faculty,
    this.department,
    this.amlCustType,
    this.amlCustNature,
    this.amlCustNatureBusiness,
    this.useEmailForStatement,
    this.passportUrl,
    this.signatureUrl,
    this.utilityUrl,
    this.bvn,
    this.maritalStatus,
    this.nextOfKin,
    this.attachments,
  });

  factory SignatoryDetail.fromJson(Map<String, dynamic> json) =>
      new SignatoryDetail(
        firstName: json["FirstName"],
        middleName: json["MiddleName"],
        lastName: json["LastName"],
        sex: json["Sex"],
        dateOfBirth: json["DateOfBirth"],
        motherMaidenName: json["MotherMaidenName"],
        title: json["Title"],
        stateOfOrigin: json["StateOfOrigin"],
        countryOfOrigin: json["CountryOfOrigin"],
        meansOfId: json["MeansOfId"],
        idNumber: json["IdNumber"],
        idIssuer: json["IdIssuer"],
        idPlaceOfIssue: json["IdPlaceOfIssue"],
        idIssueDate: json["IdIssueDate"],
        idExpiryDate: json["IdExpiryDate"],
        occupation: json["Occupation"],
        addressLine1: json["AddressLine1"],
        addressLine2: json["AddressLine2"],
        city: json["City"],
        state: json["State"],
        emailAddress: json["EmailAddress"],
        phoneNumber: json["PhoneNumber"],
        fax: json["Fax"],
        tin: json["TIN"],
        permitType: json["PermitType"],
        cerpacRpIdNo: json["CerpacRPIdNo"],
        cerpacRPplaceofIssue: json["CerpacRPplaceofIssue"],
        cerpacRpIssueAuth: json["CerpacRPIssueAuth"],
        visaNo: json["VisaNo"],
        arrivalDate: json["ArrivalDate"],
        permitValidFrom: json["PermitValidFrom"],
        permitValidTo: json["PermitValidTo"],
        foreignAddress1: json["ForeignAddress1"],
        foreignAddress2: json["ForeignAddress2"],
        studentLevel: json["StudentLevel"],
        yearOfGraduation: json["YearOfGraduation"],
        faculty: json["Faculty"],
        department: json["Department"],
        amlCustType: json["AmlCustType"],
        amlCustNature: json["AmlCustNature"],
        amlCustNatureBusiness: json["AmlCustNatureBusiness"],
        useEmailForStatement: json["UseEmailForStatement"],
        passportUrl: json["PassportUrl"],
        signatureUrl: json["SignatureUrl"],
        utilityUrl: json["UtilityUrl"],
        bvn: json["Bvn"],
        maritalStatus: json["MaritalStatus"],
        nextOfKin: json["NextOfKin"],
        attachments: new List<Attachment>.from(
            json["Attachments"].map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "MiddleName": middleName,
        "LastName": lastName,
        "Sex": sex,
        "DateOfBirth": dateOfBirth,
        "MotherMaidenName": motherMaidenName,
        "Title": title,
        "StateOfOrigin": stateOfOrigin,
        "CountryOfOrigin": countryOfOrigin,
        "MeansOfId": meansOfId,
        "IdNumber": idNumber,
        "IdIssuer": idIssuer,
        "IdPlaceOfIssue": idPlaceOfIssue,
        "IdIssueDate": idIssueDate,
        "IdExpiryDate": idExpiryDate,
        "Occupation": occupation,
        "AddressLine1": addressLine1,
        "AddressLine2": addressLine2,
        "City": city,
        "State": state,
        "EmailAddress": emailAddress,
        "PhoneNumber": phoneNumber,
        "Fax": fax,
        "TIN": tin,
        "PermitType": permitType,
        "CerpacRPIdNo": cerpacRpIdNo,
        "CerpacRPplaceofIssue": cerpacRPplaceofIssue,
        "CerpacRPIssueAuth": cerpacRpIssueAuth,
        "VisaNo": visaNo,
        "ArrivalDate": arrivalDate,
        "PermitValidFrom": permitValidFrom,
        "PermitValidTo": permitValidTo,
        "ForeignAddress1": foreignAddress1,
        "ForeignAddress2": foreignAddress2,
        "StudentLevel": studentLevel,
        "YearOfGraduation": yearOfGraduation,
        "Faculty": faculty,
        "Department": department,
        "AmlCustType": amlCustType,
        "AmlCustNature": amlCustNature,
        "AmlCustNatureBusiness": amlCustNatureBusiness,
        "UseEmailForStatement": useEmailForStatement,
        "PassportUrl": passportUrl,
        "SignatureUrl": signatureUrl,
        "UtilityUrl": utilityUrl,
        "Bvn": bvn,
        "MaritalStatus": maritalStatus,
        "NextOfKin": nextOfKin,
        "Attachments":
            new List<dynamic>.from(attachments.map((x) => x.toJson())),
      };
}

class Attachment {
  String encodedImage;
  String type;

  Attachment({
    this.encodedImage,
    this.type,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => new Attachment(
        encodedImage: json["EncodedImage"],
        type: json["Type"],
      );

  Map<String, dynamic> toJson() => {
        "EncodedImage": encodedImage,
        "Type": type,
      };
}
