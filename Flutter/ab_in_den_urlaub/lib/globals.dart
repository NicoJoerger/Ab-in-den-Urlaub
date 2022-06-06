import 'package:flutter/material.dart';

class LoginInfo {
  static final LoginInfo _singleton = LoginInfo._internal();
  var userid = -1;
  var tokens = 0;

  factory LoginInfo() {
    return _singleton;
  }

  LoginInfo._internal();
}
