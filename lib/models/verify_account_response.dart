import 'dart:convert';

VerifyAccountResponse verifyAccountResponseFromJson(String str) =>
    VerifyAccountResponse.fromJson(json.decode(str));

String verifyAccountResponseToJson(VerifyAccountResponse data) =>
    json.encode(data.toJson());

class VerifyAccountResponse {
  bool status;
  String message;
  Data data;

  VerifyAccountResponse({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyAccountResponse.fromJson(Map<String, dynamic> json) =>
      new VerifyAccountResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  fromErrorJson(Map<String, dynamic> json) => new VerifyAccountResponse(
        status: json["status"],
        message: json["message"],
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
  String accountNumber;
  String status;
  int wkfId;

  Data({
    this.responseCode,
    this.responseMessage,
    this.accountNumber,
    this.status,
    this.wkfId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        responseCode: json["ResponseCode"],
        responseMessage: json["ResponseMessage"],
        accountNumber: json["AccountNumber"],
        status: json["Status"],
        wkfId: json["WkfId"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "ResponseMessage": responseMessage,
        "AccountNumber": accountNumber,
        "Status": status,
        "WkfId": wkfId,
      };
}
