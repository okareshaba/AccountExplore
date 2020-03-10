import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zxplore_app/blocs/account_class_bloc.dart';
import 'package:zxplore_app/blocs/account_form_bloc.dart';
import 'package:zxplore_app/blocs/occupations_bloc.dart';
import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/data/entities/account_class_entity.dart';
import 'package:zxplore_app/models/account_type.dart';
import 'package:zxplore_app/utils/const.dart';

class AccountInformationStep extends StatefulWidget {
  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformationStep>
    with AutomaticKeepAliveClientMixin<AccountInformationStep> {
  AccountFormBloc accountFormBloc;
  AccountClassBloc _accountClassBloc;

  @override
  bool get wantKeepAlive => true;

  final _accountTypes = [
    SAVINGS_ACCOUNT,
    CURRENT_ACCOUNT,
  ];

  String _selectedAccountType;

  String _selectedAccFilter = "";
  final _accountHolderTypes = [
    'INDIVIDUAL',
  ];

  final _riskRanks = [
    'HIGH',
    'LOW',
    'MEDIUM',
  ];
  List<AccountClassEntity> accountClasses;

  @override
  void dispose() {
    _accountClassBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    accountFormBloc = BlocProvider.of<AccountFormBloc>(context);
    _accountClassBloc = AccountClassBloc();
    _accountClassBloc.getAccountClasses();
    _accountClassBloc.accountClasses.listen((data) {
      accountClasses = data;
    });
  }

  Widget accountTypeField() {
    return StreamBuilder(
      stream: accountFormBloc.accountType,
      builder: (context, snapshot) {
        return FormField<String>(
          autovalidate: true,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'Account Type',
                  helperText: "* Required",
                  errorText: snapshot.error),
//              isEmpty: snapshot.data == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: snapshot.data ?? _selectedAccountType,
                  isDense: true,
                  items: _accountTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountType = value;
                      if (value == SAVINGS_ACCOUNT) {
                        _selectedAccFilter = "SA";
                      } else if (value == CURRENT_ACCOUNT) {
                        _selectedAccFilter = "CA";
                      } else {
                        _selectedAccFilter = "";
                      }
                    });
//                    accountFormBloc.changeAccountType;
                    accountFormBloc.updateAccountType(value);
                    accountFormBloc.updateAccountCategoryType(null);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget accountHolderTypeField() {
    return StreamBuilder(
      stream: accountFormBloc.accountHolderType,
      builder: (context, snapshot) {
        return FormField<String>(
          autovalidate: true,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'Account Holder Type',
                  helperText: "* Required",
                  errorText: snapshot.error),
              isEmpty: snapshot.data == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: snapshot.data,
                  isDense: true,
                  onChanged: accountFormBloc.changeHolderType,
                  items: _accountHolderTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget riskRankField() {
    return StreamBuilder(
      stream: accountFormBloc.riskRankType,
      builder: (context, snapshot) {
        return FormField<String>(
          autovalidate: true,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'Risk Rank',
                  helperText: "* Required",
                  errorText: snapshot.error),
              isEmpty: snapshot.data == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: snapshot.data,
                  isDense: true,
                  onChanged: accountFormBloc.changeRiskRank,
                  items: _riskRanks.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _accountCategoryField() {
    return StreamBuilder<List<AccountClassEntity>>(
      stream: _accountClassBloc.accountClasses,
      builder: (context, listSnapshot) {
        return StreamBuilder(
            stream: accountFormBloc.accountCategoryType,
            builder: (context, itemSnapshot) {
              return FormField<String>(
                autovalidate: true,
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        labelText: 'Account Category',
                        helperText: "* Required",
                        errorText: itemSnapshot.error),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _getAccountTypeValue(itemSnapshot, listSnapshot),
                        isDense: true,
                        items: listSnapshot.hasData
                            ? listSnapshot.data
                                .where((x) =>
                                    x.type.startsWith(_selectedAccFilter))
                                .map((AccountClassEntity entity) {
                                return DropdownMenuItem<String>(
                                  value: entity.name.toString(),
                                  child: Text(entity.name.toString()),
                                );
                              }).toList()
                            : null,
                        onChanged: (value) {
                          accountFormBloc.updateAccountCategoryType(value);
                        },
                      ),
                    ),
                  );
                },
              );
            });
      },
    );
  }

  String _getAccountTypeValue(AsyncSnapshot itemSnapshot,
      AsyncSnapshot<List<AccountClassEntity>> listSnapshot) {
    var data = (listSnapshot.hasData &&
            listSnapshot.data.length > 0 &&
            listSnapshot.data.firstWhere(
                    (x) => x.name == itemSnapshot.data.toString(),
                    orElse: () => null) !=
                null)
        ? itemSnapshot.data.toString()
        : null;

    return data;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 16.0),
              Column(
                children: <Widget>[
                  SizedBox(height: 16.0),
                  accountTypeField(),
                  SizedBox(height: 30.0),
                  accountHolderTypeField(),
                  SizedBox(height: 30.0),
                  riskRankField(),
                  SizedBox(height: 30.0),
                  _accountCategoryField()
                ],
              ),
              SizedBox(height: 60.0),
            ],
          ),
        ),
      ),
    );
  }

  static List<AccountType> getAccountTypes() {
    return [
      AccountType(
        description: "SAVINGS ACCOUNT",
        classType: "SA",
      ),
      AccountType(
        description: "CURRENT ACCOUNT",
        classType: "CA",
      )
    ];
  }
}
