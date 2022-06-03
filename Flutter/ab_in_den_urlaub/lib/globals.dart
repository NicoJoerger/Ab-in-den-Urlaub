import 'package:flutter/material.dart';

class LoginInfo {
  static final LoginInfo _singleton = LoginInfo._internal();
  var userid = 0;
  var tokens = 10;

  factory LoginInfo() {
    return _singleton;
  }

  LoginInfo._internal();
}
