import 'package:flutter/material.dart';

void userInfo(BuildContext context) {
  var alert = AlertDialog(
    title: Text("User Info"),
    content: Text("Username: Mr. Dog\n\nE-mail: Doggo@god.com\n"),
  );
  showDialog(context: context, builder: (BuildContext context) => alert);
}