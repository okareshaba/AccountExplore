import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zxplore_app/apis/zenithbank_api.dart';
import 'package:zxplore_app/blocs/account_class_bloc.dart';
import 'package:zxplore_app/blocs/cities_bloc.dart';
import 'package:zxplore_app/blocs/countries_bloc.dart';
import 'package:zxplore_app/blocs/occupations_bloc.dart';
import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/blocs/states_bloc.dart';
import 'package:zxplore_app/colors.dart';
import 'package:zxplore_app/data/database.dart';
import 'package:zxplore_app/home.dart';
import 'package:zxplore_app/models/occupation_model.dart';
import 'package:zxplore_app/navigation/zexplore_navigator.dart';
import 'package:zxplore_app/utils/flushbar_helper.dart';
import 'package:zxplore_app/utils/secure_storage.dart';

import '../login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<List<String>> occupations;
  OccupationsBloc _occupationsBloc;
  CountriesBloc _countriesBloc;
  StatesBloc statesBloc;
  CitiesBloc _citiesBloc;
  AccountClassBloc _accountClassBloc;

  void _loadInitialData() {
    _occupationsBloc = OccupationsBloc();
    _countriesBloc = CountriesBloc();
    statesBloc = StatesBloc();
    _citiesBloc = CitiesBloc();
    _accountClassBloc = AccountClassBloc();

    Future.wait([
      _fetchAccountClasses(),
      _fetchStates(),
      _fetchOccupations(),
      _fetchCountries(),
      _fetchCities(),
    ]).whenComplete(() {
      SecureStorage.getEmployeeToken().then((token) {
        if (token == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
          );
        }
      }).catchError((error) {
//        print('employee token error: $error');
      });
    }).catchError((error) {
      FlushbarHelper.createLoading(message: error)..show(context);
    });
  }

  @override
  void initState() {
    super.initState();

    SecureStorage.getInitialDataLoaded().then((data) {
      if (data == null) {
        _loadInitialData();
      }
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }

  Future _fetchStates() async {
    await DBProvider.db.getStates().then((result) async {
      if (result.isEmpty) {
        await ZenithBankApi().fetchStates().then((result) {
          statesBloc.inAddStates.add(result.menu);
        }).catchError((error) {
          throw Exception(error.toString());
        });
      } else {
        //data exists continue
        return;
      }
    });
  }

  Future _fetchOccupations() async {
    await DBProvider.db.getOccupations().then((result) async {
      if (result.isEmpty) {
        await ZenithBankApi().fetchOccupations().then((result) async {
          _occupationsBloc.inAddOccupations.add(result.menu);
        }).catchError((error) {
          throw Exception(error.toString());
        });
      } else {
        //data exists continue
        return;
      }
    });
  }

  Future _fetchCountries() async {
    await DBProvider.db.getCountries().then((result) async {
      if (result.isEmpty) {
        await ZenithBankApi().fetchCountries().then((result) {
          _countriesBloc.inAddCountries.add(result.menu);
        }).catchError((error) {
          throw Exception(error.toString());
        });
      } else {
        return;
      }
    });
  }

  Future _fetchCities() async {
    await DBProvider.db.getCities().then((result) async {
      if (result.isEmpty) {
        await ZenithBankApi().fetchCities().then((result) {
          _citiesBloc.inAddCities.add(result.menu);
        }).catchError((error) {
          throw Exception(error.toString());
        });
      } else {
        return;
      }
    });
  }

  Future _fetchAccountClasses() async {
    DBProvider.db.getAccountClasses().then((result) async {
      if (result.isEmpty) {
        await ZenithBankApi().fetchAccountClasses().then((result) {
          _accountClassBloc.inAddAccountClasses.add(result.accountClassCodes);
        }).catchError((error) {
          throw Exception(error.toString());
        });
      } else {
        //data exists continue
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/logo.png'),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        'A product of Zenith Bank PLC.',
                        style: TextStyle(),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'Please wait while we populate your device initially...',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ZxplorePrimaryColor),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _occupationsBloc?.dispose();
    _countriesBloc?.dispose();
    statesBloc?.dispose();
    _citiesBloc?.dispose();
    _accountClassBloc?.dispose();
    super.dispose();
  }
}
