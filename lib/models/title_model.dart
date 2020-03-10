import 'dart:convert';

Title titleFromJson(String str) => Title.fromJson(json.decode(str));

String titleToJson(Title data) => json.encode(data.toJson());

class Title {
  String responseCode;
  String responseMessage;
  List<String> menu;

  Title({
    this.responseCode,
    this.responseMessage,
    this.menu,
  });

  factory Title.fromJson(Map<String, dynamic> json) => new Title(
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
