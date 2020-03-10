// To parse this JSON data, do
//
//     final cities = citiesFromJson(jsonString);

import 'dart:convert';

Cities citiesFromJson(String str) => Cities.fromJson(json.decode(str));

String citiesToJson(Cities data) => json.encode(data.toJson());

class Cities {
  String responseCode;
  String responseMessage;
  List<String> menu;

  Cities({
    this.responseCode,
    this.responseMessage,
    this.menu,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => new Cities(
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
