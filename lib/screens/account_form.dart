import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zxplore_app/blocs/account_form_bloc.dart';
import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/utils/flushbar_helper.dart';

import '../category.dart';
import '../colors.dart';
import 'forms/account_information_form.dart';
import 'forms/contact_details_form.dart';
import 'forms/means_of_identification_form.dart';
import 'forms/personal_information_form.dart';
import 'forms/signatory_fom.dart';
import 'forms/upload_id_form.dart';
import 'forms/upload_passport_form.dart';
import 'forms/upload_utility_bill.form.dart';

class AccountFormPage extends StatefulWidget {
  final Category category;

  final String accountReferenceId;
  final AccountFormBloc accountFormBloc;
  final bool isEditAccount;

  const AccountFormPage({@required this.category,@required this.accountFormBloc , this.accountReferenceId, this.isEditAccount = false})
      : assert(category != null);

  @override
  _AccountFormPageState createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage>
    with AutomaticKeepAliveClientMixin<AccountFormPage> {
  PageController _controller = PageController();

  Category category;
  String accountReferenceId;
  AccountFormBloc accountFormBloc;
  bool _isEditAccount;
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  final List<Widget> _pages = <Widget>[
    Container(
      child: AccountInformationStep(),
    ),
    Container(
      child: PersonalInformationStep(),
    ),
    Container(
      child: ContactDetailsStep(),
    ),
    Container(
      child: MeansOfIdentificationStep(),
    ),
    Container(
      child: UploadIdStep(),
    ),
    Container(child: UploadPassportStep()),
    Container(
      child: UploadUtilityBillStep(),
    ),
    Container(
      child: SignatoryStep(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _setDefaults();

    if(_isEditAccount && accountReferenceId != null){
      _getAccountDetailsFromDatabase(accountReferenceId);
    }
    else {
      if (accountReferenceId != null) {
        _getAccountDetailsByReferenceId(accountReferenceId);
      }
    }

  }

  void _setDefaults() {
    setState(() {
      accountFormBloc = widget.accountFormBloc;
      category = widget.category;
      accountReferenceId = widget.accountReferenceId;
      _isEditAccount = widget.isEditAccount;
    });
  }

  _getAccountDetailsFromDatabase(String referenceId){
    var backButton = FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "GO BACK",
        style: TextStyle(color: Colors.red),
      ),
    );

    accountFormBloc.getOfflineAccountDetailsByRefId(referenceId);
    accountFormBloc.subjectOfflineDetailsResponse.listen((message){

    }).onError((error){
      var errorSnackBar = FlushbarHelper.createErrorAction(
          message: error.toString(), button: backButton);

      errorSnackBar..show(context);
    });
  }

  _getAccountDetailsByReferenceId(String referenceId) {
    Future.delayed(const Duration(milliseconds: 500), () {
      var backButton = FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "GO BACK",
          style: TextStyle(color: Colors.red),
        ),
      );

      var loadingBar = FlushbarHelper.createLoading(
          message: "Retrieving Account. Please wait...",
          linearProgressIndicator: null,
         );

      accountFormBloc.getAccountsDetailsByReferenceId(referenceId);

      loadingBar..show(context);

      accountFormBloc.subjectAccountsDetailsResponse.listen((response) {
        if (response.status) {
          loadingBar.dismiss();
          FlushbarHelper.createSuccess(
              message: 'Account retreived successfully.')
            ..show(context);
        } else {
          loadingBar..dismiss(context);

          var errorButton = FlushbarHelper.createErrorAction(
              message: 'Retreival of account details failed, try again later.',
              button: backButton);

          errorButton..show(context);
        }
      }).onError((error) {
        loadingBar..dismiss(context);

        var errorSnackBar = FlushbarHelper.createErrorAction(
            message: error.toString(), button: backButton);

        errorSnackBar..show(context);
      });
    });
  }

  @override
  void didUpdateWidget(AccountFormPage old) {
    super.didUpdateWidget(old);
    // We update our [DropdownMenuItem] units when we switch [Categories].
    if (old.category != widget.category) {
      _setDefaults();

      _controller.animateToPage(widget.category.id,
          duration: _kDuration, curve: _kCurve);

//      _createDropdownMenuItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider<AccountFormBloc>(
      child: Form(
        key: this._formKey,
        child: Scaffold(
          body: IconTheme(
            data: IconThemeData(color: _kArrowColor),
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  itemCount: _pages.length,
                  //remove if you want infinite scrolling.
//                  physics: NeverScrollableScrollPhysics(),
                  physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    return _pages[index % _pages.length];
                  },
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
//                    color: Colors.grey[800].withOpacity(0.5),
                    color: ZxplorePrimaryColor,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.navigate_before,
                                color: Colors.white),
                            onPressed: () {
                              _controller.previousPage(duration: _kDuration, curve: _kCurve);

                            }),
                        Center(
                          child: DotsIndicator(
                            controller: _controller,
                            itemCount: _pages.length,
                            onPageSelected: (int page) {
                              _controller.animateToPage(
                                page,
                                duration: _kDuration,
                                curve: _kCurve,
                              );
                            },
                          ),
                        ),
                        IconButton(
                            icon:
                                Icon(Icons.navigate_next, color: Colors.white),
                            onPressed: () {
                                _controller.nextPage(duration: _kDuration, curve: _kCurve);

                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bloc: accountFormBloc,
    );
  }

  @override
  void dispose() {
    accountFormBloc?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 4.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return Container(
      width: _kDotSpacing,
      child: Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
