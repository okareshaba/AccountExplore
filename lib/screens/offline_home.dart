import 'package:flutter/material.dart';
import 'package:zxplore_app/blocs/all_accounts_bloc.dart';
import 'package:zxplore_app/data/entities/offline_form_entity.dart';
import 'package:zxplore_app/home.dart';
import 'package:zxplore_app/screens/category_screen.dart';

import '../colors.dart';

class OfflineHomePage extends StatefulWidget {
  OfflineHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OfflineHomeState createState() => _OfflineHomeState();
}

class _OfflineHomeState extends State<OfflineHomePage> {
  AccountsBloc _accountsBloc;

  @override
  void initState() {
    _accountsBloc = AccountsBloc();
    _accountsBloc.getOfflineAccounts();
    super.initState();
  }

  Widget _buildErrorWidget(String error) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              color: Colors.black54,
              size: 60,
            ),
            SizedBox(height: 20),
            Text("$error",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14.0)),
            SizedBox(height: 20),
            Transform.scale(
              scale: 1.2,
              child: _actionChipError(error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionChipError(String error) {
    return ActionChip(
        backgroundColor: ZxploreGrey,
        padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
        avatar: CircleAvatar(
          backgroundColor: ZxploreGrey,
          child: const Icon(
            Icons.refresh,
            color: ZxplorePrimaryColor,
          ),
        ),
        label: Text('Try again',
            style: TextStyle(
                fontStyle: FontStyle.normal, color: ZxplorePrimaryColor)),
        onPressed: () {
          _accountsBloc.getOfflineAccounts();
        });
  }

  ListTile makeListTile(OfflineAccountEntity form, BuildContext _context) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(left: 16.0),
          child: IconButton(icon: const Icon(Icons.remove,color: Colors.red), onPressed: (){
            _accountsBloc.deleteOfflineAccount(form.id);
            _accountsBloc.getOfflineAccounts();

            setState(() {

            });
          }),
          ),

        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text.rich(
            TextSpan(
              text:
                  '${form.firstName != null ? form.firstName : ""} ${form.surname != null ? form.surname : ""}',
              // default text style
              style: TextStyle(
                color: Colors.black,
                background: Paint()
                  ..color = Colors.transparent
                  ..strokeWidth = 16.5
                  ..style = PaintingStyle.stroke,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        ' +234${form.phone != null ? form.phone : " No phone number provided"}',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Colors.black54,
                        fontSize: 14.0)),
              ],
            ),
          ),
        ),
        subtitle: Row(
          children: <Widget>[
            ActionChip(
                backgroundColor: ZxploreGrey,
                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                avatar: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: const Icon(
                    Icons.cloud_off,
                    color: Colors.black,
                  ),
                ),
                label: Text('Offline'),
                onPressed: () {}),
            Expanded(
                flex: 1,
                child: Container(
                  // tag: 'hero',
                  child: _statusWidget(form),
                )),
          ],
        ),
      );

  Widget _statusWidget(OfflineAccountEntity form) {
    return ActionChip(
        backgroundColor: Colors.transparent,
        labelPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
        avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: const Icon(
            Icons.call_made,
            color: Colors.black,
          ),
        ),
        label: Text(
          'Edit Account',
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CategoryPage(
                      accountReferenceId: form?.referenceId,
                      isEditAccount: true,
                    )),
          );
        });
  }

  Card makeCard(OfflineAccountEntity form, BuildContext _context) => Card(
        elevation: 0.0,
        color: Colors.white,
        margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
        child: Container(
          child: makeListTile(form, _context),
        ),
      );

  Widget makeBody(List<OfflineAccountEntity> accounts, BuildContext _context) =>
      Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int index) {
            return makeCard(accounts[index], _context);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
//              Navigator.popUntil(context, ModalRoute.withName('/home'));
            }),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        title: const Text(
          'Accounts created offline',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<OfflineAccountEntity>>(
        stream: _accountsBloc.offlineAccounts,
        builder: (context, AsyncSnapshot<List<OfflineAccountEntity>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              //todo: make use of error.
              return _buildErrorWidget('No offline forms found');
            }
            return makeBody(snapshot.data, context);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          }
          else {
            return Container();
          }
        },
      ),
    );
  }
}
