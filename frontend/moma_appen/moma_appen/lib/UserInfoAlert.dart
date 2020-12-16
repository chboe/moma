import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moma_appen/profile.dart';

void userInfo(BuildContext context, Profile loggedInAs) {
  var alert = AlertDialog(
    title: Text("User Info"),
    content: Text("Name: "+loggedInAs.name+"\nUsername: "+loggedInAs.username+"\nE-mail: "+loggedInAs.email),
  );
  showDialog(context: context, builder: (BuildContext context) => alert);
}