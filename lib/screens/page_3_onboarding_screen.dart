import 'package:flutter/material.dart';
import 'package:zxplore_app/libs/circles_with_image.dart';
import 'package:zxplore_app/utils/assets.dart';

import '../colors.dart';

const double IMAGE_SIZE = 600.0;

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: double.infinity,
      width: double.infinity,
      decoration: new BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.white,
            ZxplorePrimaryColor,
            ZxplorePrimaryColor,
          ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0))),
      child: Stack(
        children: <Widget>[
          new Positioned(
            child: new CircleWithImage(Assets.viewOfflineImage),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          new Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                SizedBox(
                  child: Image(
                    image: AssetImage(Assets.acceptSignature),

                    fit: BoxFit.fitHeight,
                  ),
                  height: IMAGE_SIZE,
                  width: IMAGE_SIZE,
                ),
                Text(
                  'View accounts that have been created offline.',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
        alignment: FractionalOffset.center,
      ),
    );
  }
}
