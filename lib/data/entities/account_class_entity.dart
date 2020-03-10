import 'package:equatable/equatable.dart';

final String tableAccountClass = 'AccountClass';
final String columnAccountClassCode = 'id';
final String columnAccountClassType = 'type';
final String columnAccountClassDescription = 'name';

class AccountClassEntity extends Equatable{
  //database fields
  int id;
  String name;
  String type;

  AccountClassEntity({this.id, this.name, this.type});

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map[columnAccountClassCode] = id;
    map[columnAccountClassDescription] = name;
    map[columnAccountClassType] = type;
    return map;
  }

  factory AccountClassEntity.fromMap(Map<String, dynamic> json) =>
      new AccountClassEntity(
          id: json[columnAccountClassCode],
          name: json[columnAccountClassDescription],
          type: json[columnAccountClassType]);


}
