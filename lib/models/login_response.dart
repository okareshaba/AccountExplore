// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool status;
  String message;
  Data data;

  String error;
  LoginResponse({
    this.status,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      new LoginResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String responseCode;
  String responseMessage;
  User user;

  Data({
    this.responseCode,
    this.responseMessage,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        responseCode: json["ResponseCode"],
        responseMessage: json["ResponseMessage"],
        user: User.fromJson(json["User"]),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "ResponseMessage": responseMessage,
        "User": user.toJson(),
      };
}

class User {
  String userName;
  String adUsername;
  int employeeId;
  String branch;
  int branchNumber;
  bool isActive;
  String role;
  bool hasError;
  String errorMessage;
  String token;

  User({
    this.userName,
    this.adUsername,
    this.employeeId,
    this.branch,
    this.branchNumber,
    this.isActive,
    this.role,
    this.hasError,
    this.errorMessage,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        userName: json["UserName"],
        adUsername: json["AdUsername"],
        employeeId: json["EmployeeId"],
        branch: json["Branch"],
        branchNumber: json["BranchNumber"],
        isActive: json["IsActive"],
        role: json["Role"],
        hasError: json["HasError"],
        errorMessage: json["ErrorMessage"],
        token: json["Token"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "AdUsername": adUsername,
        "EmployeeId": employeeId,
        "Branch": branch,
        "BranchNumber": branchNumber,
        "IsActive": isActive,
        "Role": role,
        "HasError": hasError,
        "ErrorMessage": errorMessage,
        "Token": token,
      };
}
