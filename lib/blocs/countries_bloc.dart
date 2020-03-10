import 'dart:async';

import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/data/database.dart';
import 'package:zxplore_app/data/entities/country_entity.dart';

class CountriesBloc extends BlocBase {
  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream you'll be using.
  final _countriesController = StreamController<List<CountryEntity>>.broadcast();

  // Input stream. We add our notes to the stream using this variable.
  StreamSink<List<CountryEntity>> get _inCountries =>
      _countriesController.sink;

  // Output stream. This one will be used within our pages to display the notes.
  Stream<List<CountryEntity>> get countries => _countriesController.stream;


  // Input stream for adding new notes. We'll call this from our pages.
  final _addCountryController = StreamController<List<String>>.broadcast();
  StreamSink<List<String>> get inAddCountries => _addCountryController.sink;


  CountriesBloc() {
    // Retrieve all the notes on initialization
    getCountries();

    // Listens for changes to the addNoteController and calls _handleAddNote on change
    _addCountryController.stream.listen(_handleAddCountries);
  }

  // All stream controllers you create should be closed within this function
  @override
  void dispose() {
    _countriesController.close();
    _addCountryController.close();

  }

  void getCountries() async {
    // Retrieve all the notes from the database
    List<CountryEntity> notes = await DBProvider.db.getCountries();

    // Add all of the notes to the stream so we can grab them later from our pages
    _inCountries.add(notes);
  }


  void _handleAddCountries(List<String> values) async {
    // Create the note in the database
     DBProvider.db.insertCountries(values);

    // Retrieve all the notes again after one is added.
    // This allows our pages to update properly and display the
    // newly added note.
     getCountries();
  }

}
