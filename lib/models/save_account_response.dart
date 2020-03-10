import 'dart:convert';

SaveAccountResponse saveAccountResponseFromJson(String str) =>
    SaveAccountResponse.fromJson(json.decode(str));

String occupationToJson(SaveAccountResponse data) => json.encode(data.toJson());

class SaveAccountResponse {
  bool status;
  String message;



  SaveAccountResponse({
    this.status,
    this.message,
  });

  factory SaveAccountResponse.fromJson(Map<String, dynamic> json) => new SaveAccountResponse(
    status: json["Status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "message": message,
  };

}