import 'package:flutter/material.dart';

import 'blocs/account_form_bloc.dart';
import 'colors.dart';
import 'home.dart';
import 'login.dart';
import 'screens/splash_screen.dart';

class ZxploreApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ZxploreAppState();
}

class _ZxploreAppState extends State<ZxploreApp> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Z-XPLORE',
      home: MyHomePage(title: 'Z-XPLORE Home Page'),
      initialRoute: '/splash',
      onGenerateRoute: _getRoute,
      theme: _zXploreTheme,
    );
  }
}

Route<dynamic> _getRoute(RouteSettings settings) {
  if (settings.name != '/splash') {
    return null;
  }

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (BuildContext context) => SplashScreen(),
    fullscreenDialog: true,
  );
}

final ThemeData _zXploreTheme = _buildZxploreTheme();

ThemeData _buildZxploreTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: Colors.red,
    primaryColor: ZxplorePrimaryColor,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: ZxplorePrimaryColor,
    errorColor: kShrineErrorRed,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: ZxplorePrimaryColor,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: base.iconTheme.copyWith(color: ZxplorePrimaryColor),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    textTheme: _buildZxploreTextTheme(base.textTheme),
    primaryTextTheme: _buildZxploreTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildZxploreTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildZxploreTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline
            .copyWith(fontWeight: FontWeight.w500, color: ZxplorePrimaryColor),
        title: base.title.copyWith(fontSize: 18.0),
        caption:
            base.caption.copyWith(fontSize: 11.0, color: ZxplorePrimaryColor),
        body2: base.body2.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            ),
      )
      .apply(
        displayColor: Colors.black87,
        bodyColor: Colors.black87,
      );
}
