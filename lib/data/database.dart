import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zxplore_app/data/entities/state_entity.dart';
import 'package:zxplore_app/models/account_class_model.dart';
import 'entities/account_class_entity.dart';
import 'entities/city_entity.dart';
import 'entities/country_entity.dart';
import 'entities/occupation_entity.dart';
import 'entities/offline_form_entity.dart';

class DBProvider {
  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    // Get the location of our app directory. This is where files for our app,
    // and only our app, are stored. Files in this directory are deleted
    // when the app is deleted.
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'zxplore_data.db');

    return await openDatabase(path, version: 1, onOpen: (db) async {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $tableOccupation ($columnOccupationId INTEGER IDENTITY , $columnOccupationName TEXT PRIMARY KEY)');

      await db.execute(
          'CREATE TABLE $tableState ($columnStateId INTEGER IDENTITY , $columnStateName TEXT PRIMARY KEY)');

      await db.execute(
          'CREATE TABLE $tableCountry (id INTEGER $columnCountryId , $columnCountryName TEXT PRIMARY KEY)');

      await db.execute(
          'CREATE TABLE Title (id INTEGER IDENTITY , name TEXT PRIMARY KEY)');

      await db.execute(
          'CREATE TABLE $tableCity ($columnCityId INTEGER IDENTITY , $columnCityName TEXT PRIMARY KEY)');

      await db.execute(
          'CREATE TABLE $tableAccountClass ($columnAccountClassCode INTEGER PRIMARY KEY, $columnAccountClassDescription TEXT, $columnAccountClassType TEXT)');

      await db.execute(
          'CREATE TABLE $tableOfflineAccount (id INTEGER PRIMARY KEY , $columnOfflineReferenceId TEXT, accountType TEXT, accountHolderType TEXT, riskRank TEXT,accountCategory TEXT,bvn TEXT, $columnOfflineTitle TEXT, surname TEXT, firstName TEXT,otherName TEXT,mothersMaidenName TEXT,dateOfBirth TEXT,stateOfOrigin TEXT, countryOfOrigin TEXT, email TEXT, phone TEXT, nextOfKin TEXT, address1 TEXT,address2 TEXT, countryOfResidence TEXT, stateOfResidence TEXT, cityOfResidence TEXT, gender TEXT,occupation TEXT,maritalStatus TEXT, idType TEXT,idIssuer TEXT, idNumber TEXT,idPlaceOfIssue TEXT, idIssueDate TEXT,idExpiryDate TEXT, isSendEmail BOOLEAN NOT NULL,isReceiveAlert BOOLEAN NOT NULL,isRequestHardwareToken BOOLEAN NOT NULL,isRequestInternetBanking BOOLEAN NOT NULL,idCard TEXT, passport TEXT,utility TEXT, signature TEXT)');
    });
  }

  Future<OfflineAccountEntity> insertOfflineAccount(
      OfflineAccountEntity account) async {
    final db = await database;
    account.id = await db.insert(tableOfflineAccount, account.toMap());
    return account;
  }

  Future<List<OfflineAccountEntity>> getOfflineAccounts() async {
    final db = await database;
    var res = await db.query(tableOfflineAccount);
    List<OfflineAccountEntity> list = res.isNotEmpty
        ? res.map((c) => OfflineAccountEntity.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<OfflineAccountEntity> getOfflineAccount(String refId) async {
    final db = await database;
    List<Map> maps = await db.query(tableOfflineAccount,
//        columns: [columnOfflineTitle, columnOfflineSurname, columnOfflineBVN],
        where: '$columnOfflineReferenceId = ?',
        whereArgs: [refId]);
    if (maps.length > 0) {
      return OfflineAccountEntity.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateOfflineAccount(OfflineAccountEntity account) async {
    final db = await database;
    var result = await db.update(tableOfflineAccount, account.toMap(),
        where: '$columnOfflineId = ?',
        whereArgs: [account.id]);

    return result;
  }

  Future<int> deleteOfflineAccount(int id) async {
    var db = await database;
    return await db.delete(tableOfflineAccount, where: '$columnOfflineId = ?', whereArgs: [id]);
  }

  void insertOccupations(List<String> occupations) async {
    final db = await database;

    occupations.forEach((element) async =>
        await db.insert(tableOccupation, {columnOccupationName: element}));
  }

  Future<List<OccupationEntity>> getOccupations() async {
    final db = await database;
    var res = await db.query(tableOccupation);
    List<OccupationEntity> list = res.isNotEmpty
        ? res.map((c) => OccupationEntity.fromMap(c)).toList()
        : [];
    return list;
  }

  void insertCountries(List<String> countries) async {
    final db = await database;

    countries.forEach((element) async =>
        await db.insert(tableCountry, {columnCountryName: element}));
  }

  Future<List<CountryEntity>> getCountries() async {
    final db = await database;
    var res = await db.query(tableCountry);
    List<CountryEntity> list =
        res.isNotEmpty ? res.map((c) => CountryEntity.fromMap(c)).toList() : [];
    return list;
  }

  void insertStates(List<String> states) async {
    final db = await database;

    states.forEach((element) async =>
        await db.insert(tableState, {columnStateName: element}));
  }

  Future<List<StateEntity>> getStates() async {
    final db = await database;
    var res = await db.query(tableState);
    List<StateEntity> list =
        res.isNotEmpty ? res.map((c) => StateEntity.fromMap(c)).toList() : [];
    return list;
  }

  void insertCities(List<String> cities) async {
    final db = await database;

    cities.forEach((element) async =>
        await db.insert(tableCity, {columnStateName: element}));
  }

  Future<List<CityEntity>> getCities() async {
    final db = await database;
    var res = await db.query(tableCity);
    List<CityEntity> list =
        res.isNotEmpty ? res.map((c) => CityEntity.fromMap(c)).toList() : [];
    return list;
  }

  void insertAccountClasses(List<AccountClassCode> accountClasses) async {
    final db = await database;

    accountClasses
        .forEach((element) async => await db.insert(tableAccountClass, {
              columnAccountClassCode: element.classCode,
              columnAccountClassType: element.classType.toString(),
              columnAccountClassDescription: element.description
            }));
  }

  Future<List<AccountClassEntity>> getAccountClasses() async {
    final db = await database;
    var res = await db.query(tableAccountClass);
    List<AccountClassEntity> list = res.isNotEmpty
        ? res.map((c) => AccountClassEntity.fromMap(c)).toList()
        : [];
    return list;
  }
}
