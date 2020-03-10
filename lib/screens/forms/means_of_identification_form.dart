import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zxplore_app/blocs/account_form_bloc.dart';
import 'package:zxplore_app/blocs/provider.dart';
import 'package:zxplore_app/blocs/states_bloc.dart';
import 'package:zxplore_app/data/entities/state_entity.dart';

import '../../colors.dart';
import '../../login.dart';

class MeansOfIdentificationStep extends StatefulWidget {
  @override
  _MeansOfIdentificationStepStepState createState() =>
      _MeansOfIdentificationStepStepState();
}

class _MeansOfIdentificationStepStepState
    extends State<MeansOfIdentificationStep>
    with AutomaticKeepAliveClientMixin<MeansOfIdentificationStep> {
  final TextEditingController _idTypeController = TextEditingController();
  final TextEditingController _idPlaceOfIssueController =
      TextEditingController();
  final TextEditingController _idIssueDateController = TextEditingController();
  final TextEditingController _idExpiryDateController = TextEditingController();

  final TextEditingController _idIssuerController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  final _idTypes = [
    'DRIVER\'S LICENSE',
    'INT\'L PASSPORT',
    'NATIONAL ID',
    'OTHERS',
    'VOTER\'S ID CARD',
    'STUDENT ID'
  ];

  AccountFormBloc accountFormBloc;

  StatesBloc statesBloc;

  @override
  void initState() {
    super.initState();
    statesBloc = StatesBloc();
    accountFormBloc = BlocProvider.of<AccountFormBloc>(context);
  }

  Widget _idTypeTextField() {
    return StreamBuilder(
      stream: accountFormBloc.idType,
      builder: (context, snapshot) {
        return FormField<String>(
          autovalidate: true,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'ID Type',
                  helperText: "* Required",
                  errorText: snapshot.error),
              isEmpty: snapshot.data == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: snapshot.data,
                  isDense: true,
                  onChanged: accountFormBloc.changeIdType,
                  items: _idTypes.map((String value) {
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

  Widget _idIssuerTextField() {
    return StreamBuilder(
      stream: accountFormBloc.idIssuer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _idIssuerController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _idIssuerController.selection);
        }
        return TextField(
          controller: _idIssuerController,
          textCapitalization: TextCapitalization.characters,
          onChanged: accountFormBloc.changeIdIssuer,
          keyboardType: TextInputType.text,
          maxLength: 40,
          maxLines: null,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            labelText: 'ID Issuer',
            helperText: '* Required',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget _idNumberTextField() {
    return StreamBuilder(
      stream: accountFormBloc.idNumber,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _idNumberController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _idNumberController.selection);
        }
        return TextField(
          controller: _idNumberController,
          textCapitalization: TextCapitalization.characters,
          onChanged: accountFormBloc.changeIdNumber,
          keyboardType: TextInputType.text,
          maxLength: 20,
          maxLines: null,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            labelText: 'ID Number',
            helperText: '* Required',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }


  Widget _idPlaceOfIssue() {
    return StreamBuilder(
      stream: accountFormBloc.idPlaceOfIssue,
      builder: (context, snapshot) {
        return FormField<String>(
          autovalidate: true,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'ID Place of Issue',
                  helperText: "* Required",
                  errorText: snapshot.error),
              isEmpty: snapshot.data == '',
              child: DropdownButtonHideUnderline(
                child: StreamBuilder<List<StateEntity>>(
                    stream: statesBloc.states,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<StateEntity>> shot) {
                      if (!shot.hasData) return SizedBox(
                          height: 24.0,
                          child: Center(child: CircularProgressIndicator()));
                      return DropdownButton<String>(
                        value: snapshot.data,
                        items: shot.data.map((StateEntity value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name),
                          );
                        }).toList(),
                        onChanged: accountFormBloc.changePlaceOfIssue,

                        isDense: true, //value: _currentUser,
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }

  Widget _sendEmailCheckBox() {
    return StreamBuilder(
        stream: accountFormBloc.isSendEmail,
        builder: (context, snapshot) {
          return CheckboxListTile(
            onChanged: accountFormBloc.changeIsSendEmail,
            title: new Text('Send statement to email'),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.red,
            dense: true,
            value: snapshot.hasData ? snapshot.data : false,
          );
        });
  }

  Widget _receiveSmsCheckBox() {
    return StreamBuilder(
        stream: accountFormBloc.isReceiveSmsAlert,
        builder: (context, snapshot) {
          return CheckboxListTile(
            onChanged: accountFormBloc.changeIsReceiveSms,
            title: new Text('Receive SMS alert'),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.red,
            dense: true,
            value: snapshot.hasData ? snapshot.data : false,
          );
        });
  }

  Widget _requestHardwareTokenCheckBox() {
    return StreamBuilder(
        stream: accountFormBloc.isRequestHardwareToken,
        builder: (context, snapshot) {
          return CheckboxListTile(
            onChanged: accountFormBloc.changeIsRequestHardwareToken,
            title: new Text('Request hardware token'),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.red,
            dense: true,
            value: snapshot.hasData ? snapshot.data : false,
          );
        });
  }

  Widget _requestInternetBankingCheckBox() {
    return StreamBuilder(
        stream: accountFormBloc.isRequestInternetBanking,
        builder: (context, snapshot) {
          return CheckboxListTile(
            onChanged: accountFormBloc.changeIsRequestInternetBanking,
            title: new Text('Request internet banking'),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.red,
            dense: true,
            value: snapshot.hasData ? snapshot.data : false,
          );
        });
  }

  @override
  void dispose() {
    _idTypeController.dispose();
    _idPlaceOfIssueController.dispose();
    _idIssueDateController.dispose();
    _idExpiryDateController.dispose();
    _idNumberController.dispose();
    _idIssuerController.dispose();
    statesBloc.dispose();
    super.dispose();
  }

  Widget _idIssueDateField() {
    return StreamBuilder(
      stream: accountFormBloc.idIssueDate,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _idIssueDateController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _idIssueDateController.selection);
        }
        return GestureDetector(
            onTap: () async {
              DateTime picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: new DateTime(DateTime.now().year - 25),
                  lastDate: new DateTime.now());

              if (picked != null) {
                var formatter = new DateFormat('dd-MMM-yy');

                var date = formatter.format(picked);

                _idIssueDateController.text = date;
                accountFormBloc.changeIssueDate(date);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: _idIssueDateController,
                onChanged: accountFormBloc.changeIssueDate,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'ID Issue Date',
                  helperText: "* Required",
                  suffixIcon: Icon(Icons.date_range),
                  errorText: snapshot.error,
                ),
              ),
            ));
      },
    );
  }

  Widget _idExpiryDateField() {
    return StreamBuilder(
      stream: accountFormBloc.idExpiryDate,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _idExpiryDateController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _idExpiryDateController.selection);
        }
        return GestureDetector(
            onTap: () async {
              DateTime picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: new DateTime.now(),
                  lastDate: new DateTime(DateTime.now().year + 25));

              if (picked != null) {
                var formatter = new DateFormat('dd-MMM-yy');

                var date = formatter.format(picked);

                _idExpiryDateController.text = date;
                accountFormBloc.changeExpiryDate(date);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: _idExpiryDateController,
                onChanged: accountFormBloc.changeExpiryDate,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'ID Expiry Date',
                  helperText: "* Required",
                  suffixIcon: Icon(Icons.date_range),
                  errorText: snapshot.error,
                ),
              ),
            ));
      },
    );
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
                  _idTypeTextField(),
                  SizedBox(height: 30.0),
                  _idIssuerTextField(),
                  SizedBox(height: 30.0),
                  _idNumberTextField(),
                  SizedBox(height: 30.0),
                  _idPlaceOfIssue(),
                  SizedBox(height: 30.0),
                  _idIssueDateField(),
                  SizedBox(height: 30.0),
                  _idExpiryDateField(),
                  SizedBox(height: 30.0),
                  _sendEmailCheckBox(),
                  _receiveSmsCheckBox(),
                  _requestHardwareTokenCheckBox(),
                  _requestInternetBankingCheckBox(),
                ],
              ),
              SizedBox(height: 60.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
