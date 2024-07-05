import 'package:file_server/widgets/auth_text_field.dart';
import 'package:file_server/widgets/button.dart';
import 'package:file_server/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class FileEmailPage extends StatefulWidget {
  static const routeName = '/email-file';
  const FileEmailPage({super.key});

  @override
  State<FileEmailPage> createState() => _FileEmailPageState();
}

class _FileEmailPageState extends State<FileEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: MyAppBar(title: "Email File"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: 700,
            color: color.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\nEmail the Email address you want the file to be sent to below:",
                  style: TextStyle(
                    letterSpacing: 2,
                    color: color.secondary,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                CustomTextField(hintText: "Email", controller: emailController),
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                MyButton(text: "Email File", onPressed: () {}),
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                MyButton(
                  color: color.onSecondary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Cancel',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
