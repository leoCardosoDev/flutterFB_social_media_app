import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    padding: EdgeInsets.only(top: 10),
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purpleAccent),
    ),
  );
}

linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purpleAccent),
    ),
  );
}
