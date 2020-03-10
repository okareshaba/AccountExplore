final String tableOccupation = 'Occupation';
final String columnOccupationId = 'id';
final String columnOccupationName = 'name';

class OccupationEntity {
  //database fields
  String name;

  OccupationEntity({
    this.name,
  });


  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map[columnOccupationName] = name;
    return map;
  }


  factory OccupationEntity.fromMap(Map<String, dynamic> json) => new OccupationEntity(
    name: json[columnOccupationName],
  );


}
