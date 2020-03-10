import 'package:flutter/material.dart';
import 'package:zxplore_app/screens/account_form.dart';
import 'package:zxplore_app/screens/page_1_onboarding_screen.dart';
import 'package:zxplore_app/screens/page_2_onboarding_screen.dart';
import 'package:zxplore_app/screens/page_3_onboarding_screen.dart';

class OnboardingMainPage extends StatefulWidget {
  OnboardingMainPage({Key key}) : super(key: key);

  @override
  _OnboardingMainPageState createState() => new _OnboardingMainPageState();
}

class _OnboardingMainPageState extends State<OnboardingMainPage> {
  final _controller = new PageController();
  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
  ];
  int page = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDone = page == _pages.length - 1;
    return new Scaffold(
        backgroundColor: Colors.transparent,
        body: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new PageView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
                onPageChanged: (int p) {
                  setState(() {
                    page = p;
                  });
                },
              ),
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: new SafeArea(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  primary: false,
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        isDone ? 'DONE' : 'NEXT',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: isDone
                          ? () {
                              Navigator.pop(context);
                            }
                          : () {
                              _controller.animateToPage(page + 1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            },
                    )
                  ],
                ),
              ),
            ),
            new Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: new SafeArea(
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new DotsIndicator(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageSelected: (int page) {
                          _controller.animateToPage(
                            page,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//
//                        new Container(
//                          width: 150.0,
//                          height: 50.0,
//                          decoration: BoxDecoration(
//                            borderRadius: new BorderRadius.circular(30.0),
//                            border: Border.all(color: Colors.white, width: 1.0),
//                            color: Colors.transparent,
//                          ),
//                          child: new Material(
//                            child: MaterialButton(
//                              child: Text('LOG IN',
//                                style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
//                              ),
//                              onPressed: (){},
//                              highlightColor: Colors.white30,
//                              splashColor: Colors.white30,
//                            ),
//                            color: Colors.transparent,
//                            borderRadius: new BorderRadius.circular(30.0),
//                          ),
//                        ),
//                      ],
//                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
