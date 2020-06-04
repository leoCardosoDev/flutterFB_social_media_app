import 'package:flutter/material.dart';

header(BuildContext context, {bool isAppTitle = false, String titleText}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
    title: Text(
      isAppTitle ? 'FlutterShare' : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Signatra" : "",
        fontSize: isAppTitle ? 40 : 22,
      ),
    ),
  );
}
