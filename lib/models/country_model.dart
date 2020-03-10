// To parse this JSON data, do
//
//     final country = countryFromJson(jsonString);

import 'dart:convert';

Country countryFromJson(String str) => Country.fromJson(json.decode(str));

String countryToJson(Country data) => json.encode(data.toJson());

class Country {
  String responseCode;
  String responseMessage;
  List<String> menu;

  Country({
    this.responseCode,
    this.responseMessage,
    this.menu,
  });

  factory Country.fromJson(Map<String, dynamic> json) => new Country(
    responseCode: json["ResponseCode"],
    responseMessage: json["ResponseMessage"],
    menu: new List<String>.from(json["Menu"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "ResponseMessage": responseMessage,
    "Menu": new List<dynamic>.from(menu.map((x) => x)),
  };
}
