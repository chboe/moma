import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'package:flutter/material.dart';


_launchURL() async {
  const url = 'https://www.youtube.com/watch?v=oHg5SJYRHA0';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}