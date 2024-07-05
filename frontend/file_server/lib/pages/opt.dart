import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/widgets/otp_text_field.dart';
import 'package:file_server/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/api_model.dart';
import '../models/user_args.dart';
import '../widgets/app_bar.dart';

class OtpPage extends StatefulWidget {
  static const routeName = '/otp';
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  TextEditingController thirdController = TextEditingController();
  TextEditingController fourthController = TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String serverEndPoint = Api.userEndpoint;

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final args = ModalRoute.of(context)!.settings.arguments as UserArgs?;
    final String? email = args?.email;
    final String? password = args?.password;

    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
      },
      child: BlurryModalProgressHUD(
        inAsyncCall: isLoading,
        dismissible: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 70),
            child: MyAppBar(
              title: "Account Verification",
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: color.secondary,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Divider(
                        height: 60,
                        thickness: 0.005,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Verification code sent to $email",
                          style: TextStyle(
                            color: color.secondary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "\n\n\nPlease check the inbox or spam folder and enter the code that was sent below to complete Registration",
                              style: TextStyle(
                                letterSpacing: 2,
                                color: color.secondary,
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(
                        height: 30,
                        thickness: 0.005,
                      ),
                      SizedBox(
                        width: 700,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OtpTextField(controller: firstController),
                            OtpTextField(
                              controller: secondController,
                            ),
                            OtpTextField(
                              controller: thirdController,
                            ),
                            OtpTextField(
                              controller: fourthController,
                            )
                          ],
                        ),
                      ),
                      // const Divider(
                      //   height: 20,
                      //   thickness: 0.005,
                      // ),
                      // RichText(
                      //   text: TextSpan(
                      //     text: "Didn't recieve code?? ",
                      //     style: TextStyle(
                      //       color: color.secondary,
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w300,
                      //       height: 0,
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //         text: "Resend",
                      //         style: TextStyle(
                      //           color: color.primary,
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w700,
                      //           height: 0,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const Divider(
                        height: 30,
                        thickness: 0.005,
                      ),
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () async {
                            SystemChannels.textInput
                                .invokeMethod<void>('TextInput.hide');
                            if (!_formKey.currentState!.validate()) {
                              return;
                            } else {
                              try {
                                final String code = firstController.value.text +
                                    secondController.value.text +
                                    thirdController.value.text +
                                    fourthController.value.text;

                                setState(() {
                                  isLoading = true;
                                });

                                if (await verifyOtp(code)) {
                                  try {
                                    if (await addUser(email, password)) {
                                      if (context.mounted) {
                                        CustomSnackbar.show(
                                            context, "Registration Successful");
                                        Navigator.pushNamed(
                                            context, LoginPage.routeName);
                                      }
                                    } else {
                                      if (context.mounted) {
                                        CustomSnackbar.show(context,
                                            "User Registration Failed");
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "User Registration Failed $e");
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    CustomSnackbar.show(
                                        context, "Incorrect Code. Try Again!!");
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  CustomSnackbar.show(
                                      context, "User verification Failed $e");
                                }
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: color.primary),
                          child: Text(
                            "Verify and Proceed",
                            style: TextStyle(
                                color: color.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
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

  Future<bool> verifyOtp(code) async {
    return false;
  }

  Future<bool> addUser(email, password) async {
    return false;
  }
}
