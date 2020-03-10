final String tableState = 'State';
final String columnStateId = 'id';
final String columnStateName = 'name';

class StateEntity {
  //database fields
  String name;

  StateEntity({
    this.name,
  });


  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map[columnStateName] = name;
    return map;
  }


  factory StateEntity.fromMap(Map<String, dynamic> json) => new StateEntity(
    name: json[columnStateName],
  );


}
