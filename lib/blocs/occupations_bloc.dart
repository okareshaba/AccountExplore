import 'dart:async';

import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/data/database.dart';
import 'package:zxplore_app/data/entities/occupation_entity.dart';
import 'package:zxplore_app/models/occupation_model.dart';

class OccupationsBloc extends BlocBase {
  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream you'll be using.
  final _occupationsController = StreamController<List<OccupationEntity>>.broadcast();

  // Input stream. We add our notes to the stream using this variable.
  StreamSink<List<OccupationEntity>> get _inOccupations =>
      _occupationsController.sink;

  // Output stream. This one will be used within our pages to display the notes.
  Stream<List<OccupationEntity>> get occupations => _occupationsController.stream;


  // Input stream for adding new notes. We'll call this from our pages.
  final _addOccupationController = StreamController<List<String>>.broadcast();
  StreamSink<List<String>> get inAddOccupations => _addOccupationController.sink;


  OccupationsBloc() {
    // Retrieve all the notes on initialization
    getOccupations();

    // Listens for changes to the addNoteController and calls _handleAddNote on change
    _addOccupationController.stream.listen(_handleAddOccupations);
  }

  // All stream controllers you create should be closed within this function
  @override
  void dispose() {
    _occupationsController.close();
    _addOccupationController.close();

  }

  void getOccupations() async {
    // Retrieve all the notes from the database
    List<OccupationEntity> notes = await DBProvider.db.getOccupations();

    // Add all of the notes to the stream so we can grab them later from our pages
    _inOccupations.add(notes);
  }


  void _handleAddOccupations(List<String> values) async {
    // Create the note in the database
     DBProvider.db.insertOccupations(values);

    // Retrieve all the notes again after one is added.
    // This allows our pages to update properly and display the
    // newly added note.
    getOccupations();
  }

}
