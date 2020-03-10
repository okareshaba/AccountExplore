import 'package:flutter/material.dart';
import 'package:zxplore_app/apis/zenithbank_api.dart';
import 'package:zxplore_app/blocs/account_class_bloc.dart';
import 'package:zxplore_app/blocs/all_accounts_bloc.dart';
import 'package:zxplore_app/blocs/cities_bloc.dart';
import 'package:zxplore_app/blocs/countries_bloc.dart';
import 'package:zxplore_app/blocs/states_bloc.dart';
import 'package:zxplore_app/data/database.dart';
import 'package:zxplore_app/models/form_model.dart';
import 'package:zxplore_app/screens/category_screen.dart';
import 'package:zxplore_app/screens/offline_home.dart';
import 'package:zxplore_app/utils/flushbar_helper.dart';
import 'package:zxplore_app/utils/helper_functions.dart';

import 'blocs/occupations_bloc.dart';
import 'colors.dart';
import 'login.dart';
import 'models/accounts_response.dart';
import 'utils/zxplore_crypto_helper.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List accounts;
  AccountsBloc _accountsBloc;

  Future<List<String>> occupations;
  OccupationsBloc _occupationsBloc;
  CountriesBloc _countriesBloc;
  StatesBloc statesBloc;
  CitiesBloc _citiesBloc;
  AccountClassBloc _accountClassBloc;

  @override
  void initState() {

    _occupationsBloc = OccupationsBloc();
    _countriesBloc = CountriesBloc();
    statesBloc = StatesBloc();
    _citiesBloc = CitiesBloc();
    _accountClassBloc = AccountClassBloc();

    _fetchAccountClasses();
    _fetchStates();
    _fetchOccupations();
    _fetchCities();
    _fetchCountries();


    _accountsBloc = AccountsBloc();
    _accountsBloc.getAccounts();
    super.initState();
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Please wait while we get accounts you have created..."),
        SizedBox(height: 20),
        CircularProgressIndicator()
      ],
    ));
  }

  Widget _actionChipError(String error) {
    if (error.contains('expired')) {
//      new Future.delayed(const Duration(milliseconds: 200), ()
//      {
//
//        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//            builder: ( BuildContext context) => LoginPage()
//        ), ModalRoute.withName('/'));
//
//      });

      return ActionChip(
          backgroundColor: ZxploreGrey,
          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
          avatar: CircleAvatar(
            backgroundColor: ZxploreGrey,
            child: const Icon(
              Icons.call_missed_outgoing,
              color: ZxploreRedColor,
            ),
          ),
          label: Text('Sign out',
              style: TextStyle(
                  fontStyle: FontStyle.normal, color: ZxploreRedColor)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: ( BuildContext context) => LoginPage()
            ), ModalRoute.withName('/'));

          });
    } else {
      return ActionChip(
          backgroundColor: ZxploreGrey,
          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
          avatar: CircleAvatar(
            backgroundColor: ZxploreGrey,
            child: const Icon(
              Icons.refresh,
              color: ZxplorePrimaryColor,
            ),
          ),
          label: Text('Try again',
              style: TextStyle(
                  fontStyle: FontStyle.normal, color: ZxplorePrimaryColor)),
          onPressed: () {
            _fetchAccountClasses();
            _fetchStates();
            _fetchOccupations();
            _fetchCities();
            _fetchCountries();
            _accountsBloc.getAccounts();
          });
    }
  }

  Widget _buildErrorWidget(String error) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              color: Colors.black54,
              size: 60,
            ),
            SizedBox(height: 20),
            Text("$error",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14.0)),
            SizedBox(height: 20),
            Transform.scale(
              scale: 1.2,
              child: _actionChipError(error),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountsBloc.dispose();
    super.dispose();
  }

  void _showModal() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              SizedBox(height: 12.0),
              new ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.amber,
                    type: MaterialType.circle,
                    child: new Container(
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                  child: new Text(
                    'Saved',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                subtitle: new Text(
                    'This is for accounts that have been saved, but not completed.'),
                onTap: () {
//                _controller.animateTo(0);
//                Navigator.pop(context);
                },
              ),
              new ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.blueAccent,
                    type: MaterialType.circle,
                    child: new Container(
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                  child: new Text(
                    'Pending',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                subtitle:
                    new Text('This is for accounts that are still pending.'),
                onTap: () {
//                _controller.animateTo(0);
//                Navigator.pop(context);
                },
              ),
              new ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: ZxploreCompletedGreen,
                    type: MaterialType.circle,
                    child: new Container(
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                  child: new Text(
                    'Completed',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                subtitle: new Text(
                    'This is a status to show users that have completed their account creation.'),
                onTap: () {
//                _controller.animateTo(0);
//                Navigator.pop(context);
                },
              ),
              new ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: ZxploreRejectedPink,
                    type: MaterialType.circle,
                    child: new Container(
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                  child: new Text(
                    'Rejected',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                subtitle: new Text(
                    'These are accounts that have been rejected due to processing errors.'),
                onTap: () {
//                _controller.animateTo(0);
//                Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 4.0,
              )
            ],
          );
        });
  }

  Color getColor(String selector) {
    if (selector == 'Completed') {
      return ZxploreCompletedGreen;
    } else if (selector == 'Saved') {
      return Colors.amber;
    } else if (selector == 'Pending') {
      return Colors.blueAccent;
    } else {
      return ZxploreRejectedPink;
    }
  }

  ListTile makeListTile(Datum form, BuildContext _context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(left: 16.0),
          child: new Material(
            color: getColor(form.status),
            type: MaterialType.circle,
            child: new Container(
              width: 24,
              height: 24,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text.rich(
            TextSpan(
              text: CryptoHelper.decrypt(form.accountName),
              // default text style
              style: TextStyle(
                color: Colors.black,
                background: Paint()
                  ..color = Colors.transparent
                  ..strokeWidth = 16.5
                  ..style = PaintingStyle.stroke,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ' +234${CryptoHelper.decrypt(form.phoneNumber)} ',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Colors.black54,
                        fontSize: 14.0)),
              ],
            ),
          ),
        ),
        subtitle: Row(
          children: <Widget>[
            ActionChip(
                backgroundColor: ZxploreGrey,
                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                avatar: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                ),
                label: Text('Verify Account'),
                onPressed: () {
                  var loadingBar = FlushbarHelper.createLoading(
                      message:
                          "'Verifying account status for ${CryptoHelper.decrypt(form.accountName)}....",
                      linearProgressIndicator: null);
                  loadingBar..show(context);
                  _accountsBloc.verifyAccountByReferenceId(form.refId);
                  _accountsBloc.subjectVerifyAccountsResponse
                      .listen((response) {
                    loadingBar.dismiss();

                    if (response.status) {
                      if (response.data.accountNumber != null) {
                        FlushbarHelper.createSuccess(
                            message:
                                '${response?.message} . Account number is: ${response.data.accountNumber}')
                          ..show(context);
                      } else {
                        FlushbarHelper.createInformation(
                                message: '${response?.message}')
                            .show(context);
                        loadingBar.dismiss();
                      }
                    } else {
                      FlushbarHelper.createInformation(
                              message: '${response.message}')
                          .show(context);
                      loadingBar.dismiss();
                    }
                  }).onError((error) {
                    loadingBar.dismiss();
                    FlushbarHelper.createError(
                            message: "'${error.toString()}'.")
                        .show(context);
                    loadingBar.dismiss();
                  });
                }),
            Expanded(
                flex: 1,
                child: Container(
                  // tag: 'hero',
                  child: _statusWidget(form),
                )),
          ],
        ),
      );

  Widget _statusWidget(Datum form) {
    if (form?.status?.toLowerCase() == 'completed') {
      return Chip(
          backgroundColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
          avatar: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
          label: Text(
            '${CryptoHelper.decrypt(form.accountNumber)}',
          ));
//          onPressed: () {});
    } else {
      return ActionChip(
          backgroundColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
          avatar: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: const Icon(
              Icons.call_made,
              color: Colors.black,
            ),
          ),
          label: Text(
            'Edit Account',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CategoryPage(accountReferenceId: form?.refId)),
            );
          });
    }
  }

  Card makeCard(Datum form, BuildContext _context) => Card(
        elevation: 0.0,
        color: Colors.white,
        margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
        child: Container(
          child: makeListTile(form, _context),
        ),
      );

  Widget makeBody(AccountsResponse accountsResponse, BuildContext _context) =>
      Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: accountsResponse.data.length,
          itemBuilder: (BuildContext context, int index) {
            return makeCard(accountsResponse.data[index], _context);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false, // Don't show the leading button
        centerTitle: true,
          leading: Container(),
          title: const Text(
        'Zxplore',
        style: TextStyle(color: Colors.white),

      ),actions: <Widget>[
        IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
             var loading = FlushbarHelper.createLoading(message: 'Getting latest accounts...')..show(context);
              _accountsBloc.getAccounts();
              _accountsBloc.fetchAccountClasses();

              Future.delayed(new Duration(seconds: 10),

                  () => loading.dismiss(context)
              );

              setState(() {

              });
            }),
        IconButton(
            icon: Icon(Icons.cloud_off, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => OfflineHomePage()),
              );
            }),
            SizedBox(width: 16,)
      ],),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        backgroundColor: ZxploreRedColor,
        icon: const Icon(Icons.add),
        label: const Text('Create Account'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CategoryPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: StreamBuilder<AccountsResponse>(
        stream: _accountsBloc.subjectAccountsResponse.stream,
        builder: (context, AsyncSnapshot<AccountsResponse> snapshot) {
          if (snapshot.hasData) {
            if (!snapshot.data.status) {
              //todo: make use of error.
              return _buildErrorWidget(snapshot.data.message);
            }
            return makeBody(snapshot.data, context);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: ZxplorePrimaryColor,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.tune,
                  color: Colors.white,
                ),
                onPressed: () {
                  _showModal();
                }),

            IconButton(
                icon: Icon(Icons.power_settings_new, color: Colors.white),
                onPressed: () {
                  _showLogoutDialog();
                }),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logging Out"),
          content: new Text(
              "Are you sure you want to logout. You might lose offline data. Proceed?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OutlineButton(
              child: Text('Yes Logout'),
              textColor: Colors.red,
              color: Colors.transparent,
              onPressed: () async {
                await Helper.logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: ( BuildContext context) => LoginPage()
                ), ModalRoute.withName('/'));

//                Navigator.pushReplacement(
//                  context,
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => LoginPage()),
//                );
              },
            ),
          ],
        );
      },
    );
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
}
