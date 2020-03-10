
import 'dart:async';

import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/data/database.dart';
import 'package:zxplore_app/data/entities/account_class_entity.dart';
import 'package:zxplore_app/models/account_class_model.dart';

class AccountClassBloc extends BlocBase {

  final _accountClassController = StreamController<List<AccountClassEntity>>.broadcast();

  StreamSink<List<AccountClassEntity>> get _inAccountClasses =>
      _accountClassController.sink;

  Stream<List<AccountClassEntity>> get accountClasses => _accountClassController.stream;


  final _addAccountClassesController = StreamController<List<AccountClassCode>>.broadcast();
  StreamSink<List<AccountClassCode>> get inAddAccountClasses => _addAccountClassesController.sink;


  AccountClassBloc() {
    getAccountClasses();

    _addAccountClassesController.stream.listen(_handleAddCities);
  }

  @override
  void dispose() {
    _accountClassController.close();
    _addAccountClassesController.close();

  }

  void getAccountClasses() async {
    // Retrieve all the notes from the database
    List<AccountClassEntity> accountClasses = await DBProvider.db.getAccountClasses();

    _inAccountClasses.add(accountClasses);
  }


  void _handleAddCities(List<AccountClassCode> values) async {
    DBProvider.db.insertAccountClasses(values);

    getAccountClasses();
  }

}