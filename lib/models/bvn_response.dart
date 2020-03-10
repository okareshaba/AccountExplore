// To parse this JSON data, do
//
//     final bvnResponse = bvnResponseFromJson(jsonString);

import 'dart:convert';

BvnResponse bvnResponseFromJson(String str) => BvnResponse.fromJson(json.decode(str));

String bvnResponseToJson(BvnResponse data) => json.encode(data.toJson());

class BvnResponse {
  String responseCode;
  String responseMessage;
  String firstName;
  String lastName;
  String middleName;
  String nationality;
  String email;
  dynamic title;
  String bvn;
  String dateOfBirth;
  String gender;
  String phoneNumber;
  String base64Image;
  String stateOfOrigin;
  String maritalStatus;
  String residentialAddress;
  String stateOfResidence;

  BvnResponse({
    this.responseCode,
    this.responseMessage,
    this.firstName,
    this.lastName,
    this.middleName,
    this.nationality,
    this.email,
    this.title,
    this.bvn,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.base64Image,
    this.stateOfOrigin,
    this.maritalStatus,
    this.residentialAddress,
    this.stateOfResidence,
  });

  factory BvnResponse.fromJson(Map<String, dynamic> json) => new BvnResponse(
    responseCode: json["ResponseCode"],
    responseMessage: json["ResponseMessage"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    middleName: json["MiddleName"],
    nationality: json["Nationality"],
    email: json["Email"],
    title: json["Title"],
    bvn: json["Bvn"],
    dateOfBirth: json["DateOfBirth"],
    gender: json["Gender"],
    phoneNumber: json["PhoneNumber"],
    base64Image: json["Base64Image"],
    stateOfOrigin: json["StateOfOrigin"],
    maritalStatus: json["MaritalStatus"],
    residentialAddress: json["ResidentialAddress"],
    stateOfResidence: json["StateOfResidence"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "ResponseMessage": responseMessage,
    "FirstName": firstName,
    "LastName": lastName,
    "MiddleName": middleName,
    "Nationality": nationality,
    "Email": email,
    "Title": title,
    "Bvn": bvn,
    "DateOfBirth": dateOfBirth,
    "Gender": gender,
    "PhoneNumber": phoneNumber,
    "Base64Image": base64Image,
    "StateOfOrigin": stateOfOrigin,
    "MaritalStatus": maritalStatus,
    "ResidentialAddress": residentialAddress,
    "StateOfResidence": stateOfResidence,
  };
}
