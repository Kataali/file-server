import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/models/user.dart';
import 'package:file_server/pages/forgot_password.dart';
import 'package:file_server/pages/home.dart';
import 'package:file_server/pages/signup.dart';
import 'package:file_server/widgets/button.dart';
import 'package:file_server/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/api_model.dart';
import '../providers/user.provider.dart';
import '../widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  bool showPassword = false;
  final String serverEndPoint = Api.userEndpoint;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlurryModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: false,
          child: GestureDetector(
            onTap: () {
              SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Container(
                      color: color.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: 700,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 30.0, top: 70),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color: color.secondary),
                            ),
                          ),
                          AuthTextField(
                            prefixIcon: const Icon(Icons.email_outlined),
                            suffixIcon: null,
                            hintText: 'Email',
                            controller: emailController,
                            contentPadding:
                                const EdgeInsets.only(top: 5, left: 16.0),
                            obscure: false,
                            keyboard: TextInputType.emailAddress,
                          ),
                          const Divider(
                            height: 30,
                            thickness: .001,
                          ),
                          AuthTextField(
                            prefixIcon: const Icon(Icons.key_outlined),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(
                                  () {
                                    showPassword = !showPassword;
                                  },
                                );
                              },
                              child: showPassword
                                  ? const Icon(Icons.visibility_outlined)
                                  : const Icon(Icons.visibility_off_outlined),
                            ),
                            hintText: ' Password',
                            controller: passwordController,
                            contentPadding:
                                const EdgeInsets.only(top: 5, left: 16.0),
                            obscure: showPassword ? false : true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ForgotPasswordPage.routeName);
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: color.onSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 30,
                            thickness: .001,
                          ),
                          MyButton(
                            onPressed: () async {
                              SystemChannels.textInput
                                  .invokeMethod<void>('TextInput.hide');
                              final String email =
                                  emailController.value.text.trim();
                              final String password =
                                  passwordController.value.text.trim();
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (await logIn(email, password)) {
                                    if (context.mounted) {
                                      CustomSnackbar.show(
                                          context, "Login Successful");
                                      Navigator.pushNamed(
                                          context, HomePage.routeName);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "Wrong Password. Try Again!!");
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    CustomSnackbar.show(context,
                                        "Enter a registered Email. $e");
                                  }
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            text: 'Login',
                          ),
                          const Divider(
                            height: 30,
                            thickness: .001,
                          ),
                          Row(
                            children: [
                              Text(
                                "Don't have an Account?",
                                style: TextStyle(
                                    color: color.secondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, SingUpPage.routeName);
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: color.onSecondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> logIn(email, password) async {
    final res = await http.post(
      Uri.parse("$serverEndPoint/login/$email"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"password": password},
      ),
    );
    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      // print(resData["message"][0]);
      final User user = User.fromJson(resData["message"][0]);
      if (context.mounted) {
        Provider.of<UserData>(context, listen: false).getUser(user);
      }
      return true;
    } else {
      return false;
    }
  }
}
