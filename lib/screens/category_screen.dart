// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zxplore_app/blocs/account_form_bloc.dart';
import 'package:zxplore_app/blocs/provider.dart';

import '../backdrop.dart';
import '../category.dart';
import '../category_tile.dart';
import 'account_form.dart';

/// Loads in unit conversion data, and displays the data.
///
/// This is the main screen to our app. It retrieves conversion data from a
/// JSON asset and from an API. It displays the [Categories] in the back panel
/// of a [Backdrop] widget and shows the [UnitConverter] in the front panel.
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryPage extends StatefulWidget {
  final String accountReferenceId;
  final bool isEditAccount;
  const CategoryPage({this.accountReferenceId, this.isEditAccount = false});

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryPage> {
  Category _defaultCategory;
  Category _currentCategory;
  String accountReferenceId;
  AccountFormBloc accountFormBloc;
  bool _isEditAccount;
  // Widgets are supposed to be deeply immutable objects. We can update and edit
  // _categories as we build our app, and when we pass it into a widget's
  // `children` property, we call .toList() on it.
  // For more details, see https://github.com/dart-lang/sdk/issues/27755
  final _categories = <Category>[];

  @override
  void initState() {
    super.initState();
    accountFormBloc = new AccountFormBloc();

    _setDefaults();
  }

  void _setDefaults() {
    setState(() {
      accountReferenceId = widget.accountReferenceId;
      _isEditAccount = widget.isEditAccount;

    });
  }

  _getCategories() {
    var categoryIndex = 0;

    setState(() {
      _categories.add(Category(
        id: 0,
        name: 'Account Information',
      ));
      _categories.add(Category(
        id: 1,
        name: 'Personal Information',
      ));
      _categories.add(Category(
        id: 2,
        name: 'Contact Details',
      ));
      _categories.add(Category(
        id: 3,
        name: 'Means of Identification',
      ));
      _categories.add(Category(
        id: 4,
        name: 'ID Card Upload',
      ));
      _categories.add(Category(
        id: 5,
        name: 'Passport Upload',
      ));
      _categories.add(Category(
        id: 6,
        name: 'Utility Bill Upload',
      ));
      _categories.add(Category(
        id: 7,
        name: 'Signatory',
      ));

      if (categoryIndex == 0) {
        _defaultCategory = _categories[0];
      }
    });
    categoryIndex += 1;
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_categories.isEmpty) {
      _getCategories();
    }
  }

  /// Function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  /// Makes the correct number of rows for the list view, based on whether the
  /// device is portrait or landscape.
  ///
  /// For portrait, we use a [ListView]. For landscape, we use a [GridView].
  Widget _buildCategoryWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var _category = _categories[index];
          return CategoryTile(
            category: _category,
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 3.0,
        children: _categories.map((Category c) {
          return CategoryTile(
            category: c,
            onTap: _onCategoryTap,
          );
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      _getCategories();
    }

    // Based on the device size, figure out how to best lay out the list
    // You can also use MediaQuery.of(context).size to calculate the orientation
    assert(debugCheckHasMediaQuery(context));
    final listView = Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
    );
    return Backdrop(
      accountFormBloc: accountFormBloc,
      currentCategory:
          _currentCategory == null ? _defaultCategory : _currentCategory,
      frontPanel: _currentCategory == null
          ? AccountFormPage(category: _defaultCategory,accountFormBloc: accountFormBloc,accountReferenceId: accountReferenceId,isEditAccount: _isEditAccount,)
          : AccountFormPage(category: _currentCategory,accountFormBloc: accountFormBloc,accountReferenceId: accountReferenceId,isEditAccount: _isEditAccount),
      backPanel: listView,
      frontTitle: Text('Create Account'),
      backTitle: Text('Select a Category'),
    );
  }
}
