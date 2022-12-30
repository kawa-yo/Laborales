import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:laborales/themes/theme.dart';

const treeViewTheme = TreeViewTheme(
  verticalSpacing: 5,
  iconTheme: IconThemeData(
    color: secondaryColor,
    opacity: 1.0,
    size: 14,
  ),
  labelOverflow: TextOverflow.fade,
  parentLabelOverflow: TextOverflow.fade,
);
