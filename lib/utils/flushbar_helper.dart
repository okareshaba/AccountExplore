import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarHelper {
  /// Get a success notification flushbar.
  static Flushbar createSuccess(
      {@required String message,
        String title,
        Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      messageText: Text(
        message,
        style: TextStyle( color: Colors.black),
      ),
      backgroundColor: Colors.white,
      leftBarIndicatorColor: Colors.green[300],
      duration: duration,
    );
  }

  /// Get an information notification flushbar
  static Flushbar createInformation(
      {@required String message,
        String title,
        Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      messageText: Text(
        message,
        style: TextStyle( color: Colors.black),
      ),
      backgroundColor: Colors.white,
      leftBarIndicatorColor: Colors.blue[300],
      duration: duration,
    );
  }

  /// Get a error notification flushbar
  static Flushbar createError(
      {@required String message,
        String title,
        Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      messageText: Text(
        message,
        style: TextStyle( color: Colors.black),
      ),
      backgroundColor: Colors.white,
      leftBarIndicatorColor: Colors.red[300],
      duration: duration,
    );
  }

  /// Get a flushbar that can receive a user action through a button.
  static Flushbar createAction(
      {@required String message,
        @required FlatButton button,
        String title,
        Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      title: title,
      message: message,
      duration: duration,
      mainButton: button,

    );
  }

  static Flushbar createErrorAction(
      {@required String message,
        @required FlatButton button,
        String title,Duration duration = const Duration(seconds: 25)}) {
    return Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      messageText: Text(
        message,
        style: TextStyle( color: Colors.black),
      ),
      mainButton: button,
      backgroundColor: Colors.white,
      leftBarIndicatorColor: Colors.red[300],
      duration: duration,
    );
  }


  // Get a flushbar that shows the progress of a async computation.
  static Flushbar createLoading(
      {@required String message,
        LinearProgressIndicator linearProgressIndicator,
        String title,
//        Duration duration = const Duration(seconds: 25),
        AnimationController progressIndicatorController,
        Color progressIndicatorBackgroundColor}) {
    return Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      messageText: Text(
        message,
        style: TextStyle( color: Colors.black),
      ),
      backgroundColor: Colors.white,
      leftBarIndicatorColor: Colors.amber,
      showProgressIndicator: false,
      progressIndicatorController: progressIndicatorController,
//      duration: duration,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
    );
  }

  /// Get a flushbar that shows an user input form.
  static Flushbar createInputFlushbar({@required Form textForm}) {
    return Flushbar(
      duration: null,
      userInputForm: textForm,
    );
  }
}