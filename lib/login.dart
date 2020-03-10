import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zxplore_app/utils/flushbar_helper.dart';
import 'package:zxplore_app/utils/secure_storage.dart';

import 'blocs/login_bloc.dart';
import 'colors.dart';
import 'home.dart';
import 'libs/top_wave.dart';
import 'libs/wavy_header_image.dart';
import 'models/login_response.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  Offset _offset = Offset.zero;
  final _perspective = 0.003;
  final _zeroAngle = 0.0001;
  @override
  void initState() {
    _loginBloc = LoginBloc();
    super.initState();
  }

  Widget userNameField() {
    return StreamBuilder(
      stream: _loginBloc.username,
      builder: (context, snapshot) {
        return AccentColorOverride(
          color: ZxplorePrimaryColor,
          child: TextField(
            onChanged: _loginBloc.changeUserName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Username',
              errorText: snapshot.error,
            ),
          ),
        );
      },
    );
  }

  Widget passwordField() {
    return StreamBuilder(
        stream: _loginBloc.password,
        builder: (context, snapshot) {
          return AccentColorOverride(
            color: ZxplorePrimaryColor,
            child: TextField(
              onChanged: _loginBloc.changePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: snapshot.error,
              ),
              obscureText: true,
            ),
          );
        });
  }

  Widget submitButton() {
    return StreamBuilder(
      stream: _loginBloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Login'),
          textColor: Color.fromRGBO(255, 255, 255, 1),
          color: ZxplorePrimaryColor,
          elevation: 8.0,
          onPressed: snapshot.hasData
              ? () async {
                  var loadingBar = FlushbarHelper.createLoading(
                      message: "Attempting to login....",
                      linearProgressIndicator: null);
                  loadingBar..show(context);

                  _loginBloc.submit();

                  _loginBloc.subjectLoginResponse.listen((loginResponse) async {
                    loadingBar.dismiss();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyHomePage()),
                    );
                  }).onError((error) {
                    loadingBar.dismiss();

                    loadingBar.dismiss();
                    FlushbarHelper.createError(
                            message: "${error.toString()}.")
                        .show(context);
                    loadingBar.dismiss();
                  });
                }
              : null,
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Loading data from API..."), CircularProgressIndicator()],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return SnackBar(
      content: Text(error),
      action: SnackBarAction(
        label: 'retry',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(

        body: SafeArea(
          child: ListView(children: <Widget>[

//          Card( child:Image.asset('assets/images/zenithheader.jpg') ,),
            SizedBox(height: 120.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40.0, child:Image.asset('assets/images/logo.png') ,),

                Text(
                  'XPLORE',
                  style: Theme.of(context).textTheme.display1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Enter your Zenith bank active directory credentials below. This helps identify the employee that wants to access the application.',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: userNameField(),
            ),
            SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: passwordField(),
            ),
            ButtonBar(
              children: <Widget>[
//              FlatButton(
//                  child: Text('Clear'),
//                  shape: BeveledRectangleBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                  ),
//                  onPressed: () {
//
//                  }),
                submitButton(),
              ],
            ),
//          Expanded(child: WavyFooter())
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc?.dispose();
    super.dispose();
  }
}

Future<bool> _exitApp(BuildContext context) {
  return showDialog(
    context: context,
    child: new AlertDialog(
      title: new Text('Do you want to exit this application?'),
      content: new Text('We hate to see you leave...'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text('No'),
        ),
        new FlatButton(
          onPressed: () => exit(0),
          child: new Text('Yes'),
        ),
      ],
    ),
  ) ??
      false;
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}
