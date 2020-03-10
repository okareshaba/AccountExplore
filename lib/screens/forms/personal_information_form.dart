import 'package:flutter/material.dart';
import 'package:zxplore_app/blocs/account_form_bloc.dart';
import 'package:zxplore_app/blocs/countries_bloc.dart';
import 'package:zxplore_app/blocs/provider.dart';
import 'package:intl/intl.dart';
import 'package:zxplore_app/blocs/states_bloc.dart';
import 'package:zxplore_app/data/entities/country_entity.dart';
import 'package:zxplore_app/data/entities/state_entity.dart';
import 'package:zxplore_app/utils/flushbar_helper.dart';
import 'package:zxplore_app/utils/helper_functions.dart';

import '../../colors.dart';

class PersonalInformationStep extends StatefulWidget {
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformationStep>
    with AutomaticKeepAliveClientMixin<PersonalInformationStep> {
  final _titles = [
    'Miss',
    'Dr.',
    'Prof.',
    'Rev.',
    'Chief',
    'Mr.',
    'Barrister',
    'Pastor',
    'Otunba',
    'Mrs',
    'Engr',
    'Alhaji',
    'Alhaja',
    'Mr & Mrs',
    'Dr. & Mrs.',
    'Hon Just.',
    'Hon'
  ];

  AccountFormBloc accountFormBloc;

  CountriesBloc countriesBloc;

  StatesBloc statesBloc;

  TextEditingController _bvnController;
  TextEditingController _firstNameController;
  TextEditingController _titleController;
  TextEditingController _surnameController;
  TextEditingController _otherNameController;
  TextEditingController _mothersMaidenNameController;
  TextEditingController _dateOfBirthController;
  TextEditingController _stateOfOriginController;
  TextEditingController _countryOfOriginController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    countriesBloc = CountriesBloc();
    statesBloc = StatesBloc();
    accountFormBloc = BlocProvider.of<AccountFormBloc>(context);
    _bvnController = TextEditingController();
    _firstNameController = TextEditingController();
    _titleController = TextEditingController();
    _surnameController = TextEditingController();
    _otherNameController = TextEditingController();
    _mothersMaidenNameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _stateOfOriginController = TextEditingController();
    _countryOfOriginController = TextEditingController();
  }

  @override
  void dispose() {
    statesBloc.dispose();
    countriesBloc.dispose();
    _firstNameController.dispose();
    _bvnController.dispose();
    _titleController.dispose();
    _surnameController.dispose();
    _otherNameController.dispose();
    _mothersMaidenNameController.dispose();
    _dateOfBirthController.dispose();
    _stateOfOriginController.dispose();
    _countryOfOriginController.dispose();

    super.dispose();
  }

  Widget titleTextField() {
    return StreamBuilder(
      stream: accountFormBloc.title,
      builder: (context, snapshot) {
        return FormField<String>(
          autovalidate: true,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'Title',
                  helperText: "* Required",
                  errorText: snapshot.error),
              isEmpty: snapshot.data == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: snapshot.data,
                  isDense: true,
                  onChanged: accountFormBloc.changeTitle,
                  items: _titles.map((String value) {
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

  Widget _bvnField() {
    return StreamBuilder(
        stream: accountFormBloc.bvn,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _bvnController.value = TextEditingValue(
                text: snapshot.data.toString(),
                selection: _bvnController.selection);
          }
          return TextField(
            controller: _bvnController,
            obscureText: false,
            keyboardType: TextInputType.number,
            onChanged: accountFormBloc.changeBvn,
            decoration: InputDecoration(
              labelText: 'BVN',
              helperText:
                  'Click the verify BVN button to populate account form.',
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _surnameField() {
    return StreamBuilder(
      stream: accountFormBloc.surname,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _surnameController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _surnameController.selection);
        }
        return TextField(
          controller: _surnameController,
          textCapitalization: TextCapitalization.characters,
          onChanged: accountFormBloc.changeSurname,
          keyboardType: TextInputType.text,
          maxLength: 40,
          enabled: accountFormBloc.bvnlastNameValue,
          maxLines: null,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            labelText: 'Surname',
            helperText: '* Required',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  //Workaround for this issue on text TextFields: https://github.com/flutter/flutter/issues/11416

  Widget _firstNameField() {
    return StreamBuilder(
      stream: accountFormBloc.firstName,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _firstNameController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _firstNameController.selection);
        }
        return TextField(
          controller: _firstNameController,
          textCapitalization: TextCapitalization.characters,
          onChanged: accountFormBloc.changeFirstName,
          keyboardType: TextInputType.text,
          maxLength: 40,
          enabled: accountFormBloc.bvnFirstName,
          maxLines: null,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            labelText: 'First Name',
            helperText: '* Required',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget _otherNameField() {
    return StreamBuilder(
      stream: accountFormBloc.otherName,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _otherNameController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _otherNameController.selection);
        }
        return TextField(
          controller: _otherNameController,
          textCapitalization: TextCapitalization.characters,
          onChanged: accountFormBloc.changeOtherName,
          keyboardType: TextInputType.text,
          maxLength: 40,
          enabled: accountFormBloc.bvnOtherName,
          maxLines: null,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            labelText: 'Other Name',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget _mothersMaidenNameField() {
    return StreamBuilder(
      stream: accountFormBloc.mothersMaidenName,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _mothersMaidenNameController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _mothersMaidenNameController.selection);
        }
        return TextField(
          controller: _mothersMaidenNameController,
          textCapitalization: TextCapitalization.characters,
          onChanged: accountFormBloc.changeMothersMaidenName,
          keyboardType: TextInputType.text,
          maxLength: 40,
          maxLines: null,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            labelText: 'Mother\'s Maiden Name',
            helperText: '* Required',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget _dateOfBirthTextField() {
    return StreamBuilder(
      stream: accountFormBloc.dateOfBirth,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _dateOfBirthController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _dateOfBirthController.selection);
        }
        return TextField(
          controller: _dateOfBirthController,
          textCapitalization: TextCapitalization.characters,
          onChanged: accountFormBloc.changeDateOfBirth,
          keyboardType: TextInputType.text,
          maxLength: 40,
          enabled: accountFormBloc.bvnDateOfBirths,
          maxLines: null,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            helperText: '* Required',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget _dateOfBirthField() {
    return StreamBuilder(
      stream: accountFormBloc.dateOfBirth,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _dateOfBirthController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _dateOfBirthController.selection);
        }
        return GestureDetector(
            onTap: () async {
              DateTime picked = await showDatePicker(
                  context: context,
                  initialDate: new DateTime(DateTime.now().year - 13),
                  firstDate: new DateTime(1900),
                  lastDate: new DateTime(DateTime.now().year - 13));

              if (picked != null) {
                var formatter = new DateFormat('dd-MMM-yy');
                var dob = formatter.format(picked);

                _dateOfBirthController.text = dob;
                accountFormBloc.changeDateOfBirth(dob);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: _dateOfBirthController,
                onChanged: accountFormBloc.changeDateOfBirth,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  helperText: "* Required",
                  suffixIcon: Icon(Icons.date_range),
                  errorText: snapshot.error,
                ),
              ),
            ));
      },
    );
  }

  Widget _stateOfOriginField() {
    return StreamBuilder(
      stream: accountFormBloc.stateOfOrigin,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _stateOfOriginController.value = TextEditingValue(
              text: snapshot.data.toString(),
              selection: _stateOfOriginController.selection);
        }
        return TextField(
          controller: _stateOfOriginController,
          textCapitalization: TextCapitalization.characters,
          onChanged: accountFormBloc.changeStateOfOrigin,
          keyboardType: TextInputType.text,
          maxLength: 40,
          enabled: accountFormBloc.bvnState,
          maxLines: null,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            helperText: '* Required',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget _stateOfOriginTextField() {
    return StreamBuilder(
      stream: accountFormBloc.stateOfOrigin,
      builder: (context, snapshot) {
        return FormField<String>(
          autovalidate: true,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'State of Origin',
                  helperText: "* Required",
                  errorText: snapshot.error),
              isEmpty: snapshot.data == '',
              child: DropdownButtonHideUnderline(
                child: StreamBuilder<List<StateEntity>>(
                    stream: statesBloc.states,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<StateEntity>> shot) {
                      if (!shot.hasData)
                        return SizedBox(
                            height: 24.0,
                            child: Center(child: CircularProgressIndicator()));
                      return DropdownButton<String>(
                        value: snapshot.hasData
                            ? Helper.returnValidStateSelectedItem(snapshot.data,
                                shot.data.map((x) => x.name).toList())
                            : null,
                        items: shot.data != null
                            ? shot.data.map((StateEntity value) {
                                return DropdownMenuItem<String>(
                                  value: value.name,
                                  child: Text(value.name),
                                );
                              }).toList()
                            : null,
                        onChanged: accountFormBloc.changeStateOfOrigin,

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

  Widget _countryOfOriginTextField() {
    return StreamBuilder(
      stream: accountFormBloc.countryOfOrigin,
      builder: (context, snapshot) {
        return FormField<String>(
          autovalidate: true,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'Country of Origin',
                  helperText: "* Required",
                  errorText: snapshot.error),
              child: DropdownButtonHideUnderline(
                child: StreamBuilder<List<CountryEntity>>(
                    stream: countriesBloc.countries,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CountryEntity>> shot) {
                      if (!shot.hasData)
                        return SizedBox(
                            height: 24.0,
                            child: Center(child: CircularProgressIndicator()));
                      return DropdownButton<String>(
                        value: shot.data != null
                            ? shot.data?.first?.name
                            : 'NIGERIA',
                        items: shot.data.map((CountryEntity value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name),
                          );
                        }).toList(),
                        onChanged: accountFormBloc.changeCountryOfOrigin,

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

  Widget _buildDateOfBirth() {
    return StreamBuilder(
        stream: accountFormBloc.bvnDateOfBirth,
        builder: (context, snapShot) {
          if (!snapShot.hasData) {
            return _dateOfBirthField();
          }
          if (snapShot.data) {
            return _dateOfBirthField();
          } else
            return _dateOfBirthTextField();
        });
  }

  Widget _buildStateOfOrigin() {
    return StreamBuilder(
        stream: accountFormBloc.bvnStateOfOrigin,
        builder: (context, snapShot) {
          if (!snapShot.hasData) {
            return _stateOfOriginTextField();
          }
          if (snapShot.data) {
            return _stateOfOriginTextField();
          } else
            return _stateOfOriginField();
        });
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
                  IntrinsicHeight(
                    child: Column(
                      children: <Widget>[
                        _bvnField(),
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          height: 60.0,
                          child: OutlineButton(
                            child: Text('VERIFY BVN'),
                            textColor: ZxplorePrimaryColor,
                            color: Colors.transparent,
                            onPressed: () {
                              var loadingBar = FlushbarHelper.createLoading(
                                  message: "verifying BVN PLease wait...",
                                  linearProgressIndicator: null);
                              loadingBar..show(context);
                              accountFormBloc.verifyBvn();
                              accountFormBloc.bvnVerificationResponse
                                  .listen((response) {
                                loadingBar.dismiss();
                                FlushbarHelper.createSuccess(
                                    message: "BVN provided is correct.")
                                  ..show(context);
                              }).onError((error) {
                                loadingBar.dismiss();
                                FlushbarHelper.createError(
                                        message:
                                            "BVN provided could not be verified.")
                                    .show(context);
                                loadingBar.dismiss();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  titleTextField(),
                  SizedBox(height: 30.0),
                  _surnameField(),
                  SizedBox(height: 30.0),
                  _firstNameField(),
                  SizedBox(height: 30.0),
                  _otherNameField(),
                  SizedBox(height: 30.0),
                  _mothersMaidenNameField(),
                  SizedBox(height: 30.0),
                  _buildDateOfBirth(),
                  SizedBox(height: 30.0),
                  _stateOfOriginTextField(),
                  SizedBox(height: 30.0),
                  _countryOfOriginTextField(),
                ],
              ),
              SizedBox(height: 60.0),
            ],
          ),
        ),
      ),
    );
  }
}
