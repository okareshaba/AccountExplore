import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:zxplore_app/blocs/account_form_bloc.dart';
import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/libs/Signature.dart';
import 'package:zxplore_app/utils/flushbar_helper.dart';

import '../../colors.dart';
import '../../login.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:zxplore_app/home.dart';

class SignatoryStep extends StatefulWidget {
  @override
  _SignatoryStepState createState() => _SignatoryStepState();
}

class _SignatoryStepState extends State<SignatoryStep>
    with AutomaticKeepAliveClientMixin<SignatoryStep> {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  AccountFormBloc accountFormBloc;
  var loadingBar;

  @override
  void initState() {
    super.initState();
    accountFormBloc = BlocProvider.of<AccountFormBloc>(context);

    accountFormBloc.uploadSignatureController.listen((base64Signature) {
      var imageData = base64Decode(base64Signature);
      setState(() {
        _img = imageData.buffer.asByteData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LimitedBox(
                maxHeight: 300,
                maxWidth: 350,
                child: Container(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Signature(
                      color: color,
                      key: _sign,
                      onSign: () {
                        final sign = _sign.currentState;
                        // debugPrint(
                        //     '${sign.points.length} points in the signature');
                      },
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ),
              ),
            ),
            _img.buffer.lengthInBytes == 0
                ? Container()
                : LimitedBox(
                    maxHeight: 200.0,
                    child: Image.memory(_img.buffer.asUint8List())),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      child: Text('Accept Signature.'),
                      onPressed: () async {
                        final sign = _sign.currentState;
                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        final image = await sign.getData();
                        var data = await image.toByteData(
                            format: ui.ImageByteFormat.png);
                        sign.clear();
                        final encoded = base64
                            .encode(data.buffer.asUint8ClampedList())
                            .toString();

                        accountFormBloc.setSignature(encoded);

                        setState(() {
                          _img = data;
                        });
//                        debugPrint("onPressed " + encoded);
                      },
                    ),
                    FlatButton(
                        child: Text(
                          'Clear Signature',
                        ),
                        textColor: ZxploreRedColor,
                        onPressed: () {
                          final sign = _sign.currentState;
                          sign.clear();
                          accountFormBloc.setSignature(null);
                          setState(() {
                            _img = ByteData(0);
                          });
                        }),
                  ],
                ),
                SizedBox(height: 16.0),
                submitButton(),
                SizedBox(height: 60.0),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget submitButton() {
    return StreamBuilder(
      stream: accountFormBloc.submitValid,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: new RaisedButton(
              child: Text('Submit Account'),
              textColor: Color.fromRGBO(255, 255, 255, 1),
              color: ZxplorePrimaryColor,
              elevation: 8.0,
              onPressed: snapshot.hasData
                  ? () async {
                      var loadingBar = FlushbarHelper.createLoading(
                          message: "Attempting to submit account form....")
                        ..show(context);
                      accountFormBloc.submit();

                      accountFormBloc.subjectSaveAccountResponse
                          .listen((response) {
                        loadingBar.dismiss(context);

                        _showSuccessDialog(
                            'The created account was sent successfully, an account number will be generated shortly.');
                      }).onError((error) {
                        loadingBar.dismiss(context);

                            FlushbarHelper.createError(message: error.toString())..show(context);
                      });
                    }
                  : null,
//              onPressed: accountFormBloc.submit,
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Account Creation Status"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            OutlineButton(
              child: Text('Done'),
              textColor: Colors.green,
              color: Colors.transparent,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
