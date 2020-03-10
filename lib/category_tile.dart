// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'category.dart';
import 'colors.dart';

// We use an underscore to indicate that these variables are private.
// See https://www.dartlang.org/guides/language/effective-dart/design#libraries
const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

/// A [CategoryTile] to display a [Category].
class CategoryTile extends StatelessWidget {
  final Category category;
  final ValueChanged<Category> onTap;

  const CategoryTile({
    Key key,
    @required this.category,
    this.onTap,
  })  : assert(category != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: new InkWell(
      onTap: onTap == null ? null : () => onTap(category),
      child: Container(
        padding: EdgeInsets.only(top: 40.0),
        color: ZxplorePrimaryColor,
        child: Text(
          category.toString().toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
  }
}
