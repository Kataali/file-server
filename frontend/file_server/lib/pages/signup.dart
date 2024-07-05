import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/opt.dart';
import 'package:file_server/widgets/auth_text_field.dart';
import 'package:file_server/widgets/button.dart';
import 'package:file_server/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/api_model.dart';
import '../models/user_args.dart';

class SingUpPage extends StatefulWidget {
  static const routeName = '/signup';
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool isLessThanSix = false;
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
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
      },
      child: Scaffold(
        body: BlurryModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: false,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  width: 700,
                  color: color.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0, top: 70),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: color.secondary),
                        ),
                      ),
                      AuthTextField(
                        prefixIcon: const Icon(Icons.email_outlined),
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
                        prefixIcon: const Icon(Icons.lock_outlined),
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
                      if (isLessThanSix)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'The password should be at least 6 characters long',
                              style: TextStyle(
                                  color: color.onSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: MyButton(
                          onPressed: () async {
                            SystemChannels.textInput
                                .invokeMethod<void>('TextInput.hide');
                            if (!_formKey.currentState!.validate()) {
                              return;
                            } else {
                              if (passwordController.value.text.trim().length >
                                  6) {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (await sendOtp()) {
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                          context, OtpPage.routeName,
                                          arguments: UserArgs(
                                            email: emailController.value.text,
                                            password:
                                                passwordController.value.text,
                                          ));
                                    }
                                  } else {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "Check Connection and Try Again");
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    CustomSnackbar.show(context,
                                        "Check Connection and Try Again $e");
                                  }
                                }
                              } else {
                                setState(() {
                                  isLessThanSix = true;
                                });
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          text: 'Register',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendOtp() async {
    return true;
  }
}
