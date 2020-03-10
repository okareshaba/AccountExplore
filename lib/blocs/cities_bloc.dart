
import 'dart:async';

import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/data/database.dart';
import 'package:zxplore_app/data/entities/city_entity.dart';

class CitiesBloc extends BlocBase {

  final _citiesController = StreamController<List<CityEntity>>.broadcast();

  StreamSink<List<CityEntity>> get _inCities =>
      _citiesController.sink;

  Stream<List<CityEntity>> get cities => _citiesController.stream;


  final _addCityController = StreamController<List<String>>.broadcast();
  StreamSink<List<String>> get inAddCities => _addCityController.sink;


  CitiesBloc() {
    getCities();

    _addCityController.stream.listen(_handleAddCities);
  }

  @override
  void dispose() {
    _citiesController.close();
    _addCityController.close();

  }

  void getCities() async {
    // Retrieve all the notes from the database
    List<CityEntity> notes = await DBProvider.db.getCities();

    _inCities.add(notes);
  }


  void _handleAddCities(List<String> values) async {
    DBProvider.db.insertCities(values);

    getCities();
  }

}
