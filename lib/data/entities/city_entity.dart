final String tableCity = 'City';
final String columnCityId = 'id';
final String columnCityName = 'name';

class CityEntity {
  //database fields
  String name;

  CityEntity({
    this.name,
  });


  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map[columnCityName] = name;
    return map;
  }


  factory CityEntity.fromMap(Map<String, dynamic> json) => new CityEntity(
    name: json[columnCityName],
  );


}
