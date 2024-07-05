import 'package:file_server/pages/home.dart';
import 'package:file_server/pages/forgot_password.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/pages/opt.dart';
import 'package:file_server/pages/signup.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      LoginPage.routeName: (context) => const LoginPage(),
      SingUpPage.routeName: (context) => const SingUpPage(),
      HomePage.routeName: (context) => const HomePage(),
      OtpPage.routeName: (context) => const OtpPage(),
      ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
    };
  }
}
