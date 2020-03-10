// To parse this JSON data, do
//
//     final accountsResponse = accountsResponseFromJson(jsonString);

import 'dart:convert';

AccountsResponse accountsResponseFromJson(String str) => AccountsResponse.fromJson(json.decode(str));

String accountsResponseToJson(AccountsResponse data) => json.encode(data.toJson());

class AccountsResponse {
  bool status;
  String message;
  List<Datum> data;

  AccountsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AccountsResponse.fromJson(Map<String, dynamic> json) => new AccountsResponse(
    status: json["status"],
    message: json["message"],
    data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String accountType;
  String refId;
  String batchId;
  String accountNumber;
  String accountHolderType;
  int classCode;
  int branchNumber;
  int rsmId;
  String accountName;
  String title;
  String addressLine1;
  String city;
  String state;
  String status;
  String phoneNumber;
  String dateCreated;

  Datum({
    this.accountType,
    this.refId,
    this.batchId,
    this.accountNumber,
    this.accountHolderType,
    this.classCode,
    this.branchNumber,
    this.rsmId,
    this.accountName,
    this.title,
    this.addressLine1,
    this.city,
    this.state,
    this.status,
    this.phoneNumber,
    this.dateCreated,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
    accountType: json["AccountType"],
    refId: json["Ref_Id"],
    batchId: json["BatchID"] == null ? null : json["BatchID"],
    accountNumber: json["AccountNumber"],
    accountHolderType: json["AccountHolderType"],
    classCode: json["ClassCode"],
    branchNumber: json["BranchNumber"],
    rsmId: json["RSMId"],
    accountName: json["AccountName"],
    title: json["Title"],
    addressLine1: json["AddressLine1"],
    city: json["City"],
    state: json["State"],
    status: json["Status"],
    phoneNumber: json["PhoneNumber"],
    dateCreated: json["DateCreated"],
  );

  Map<String, dynamic> toJson() => {
    "AccountType": accountType,
    "Ref_Id": refId,
    "BatchID": batchId == null ? null : batchId,
    "AccountNumber": accountNumber,
    "AccountHolderType": accountHolderType,
    "ClassCode": classCode,
    "BranchNumber": branchNumber,
    "RSMId": rsmId,
    "AccountName": accountName,
    "Title": title,
    "AddressLine1": addressLine1,
    "City": city,
    "State": state,
    "Status": status,
    "PhoneNumber": phoneNumber,
    "DateCreated": dateCreated,
  };
}
