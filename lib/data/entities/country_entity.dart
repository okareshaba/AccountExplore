final String tableCountry = 'Country';
final String columnCountryId = 'id';
final String columnCountryName = 'name';

class CountryEntity {
  //database fields
  String name;

  CountryEntity({
    this.name,
  });


  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map[columnCountryName] = name;
    return map;
  }


  factory CountryEntity.fromMap(Map<String, dynamic> json) => new CountryEntity(
    name: json[columnCountryName],
  );


}
