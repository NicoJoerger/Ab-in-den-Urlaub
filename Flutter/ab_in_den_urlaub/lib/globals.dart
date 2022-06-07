import 'package:flutter/material.dart';

class LoginInfo {
  static final LoginInfo _singleton = LoginInfo._internal();
  var userid = -1;
  var tokens = 0;
  var serverIP = "http://81.169.152.56:5000";
  bool vermieter = false;
  factory LoginInfo() {
    return _singleton;
  }

  LoginInfo._internal();
}
