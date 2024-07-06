import 'package:file_server/pages/login.dart';
import 'package:file_server/providers/user.provider.dart';
import 'package:file_server/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_bar.dart';

class ManageAccountPage extends StatefulWidget {
  static const routeName = '/manage-account';
  const ManageAccountPage({super.key});

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var provider = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 70),
          child: MyAppBar(title: "Manage Account")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            width: 700,
            color: color.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                Text(
                  "Account Information",
                  style: TextStyle(
                    // letterSpacing: 2,
                    color: color.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "User ID:",
                      style: TextStyle(
                        // letterSpacing: 2,
                        color: color.secondary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    Text(
                      "${provider.userId}",
                      style: TextStyle(
                        letterSpacing: 2,
                        color: color.secondary,
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email:",
                      style: TextStyle(
                        // letterSpacing: 2,
                        color: color.secondary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    Text(
                      provider.userEmail,
                      style: TextStyle(
                        letterSpacing: 2,
                        color: color.secondary,
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 120,
                  thickness: .001,
                ),
                MyButton(
                  leading: Icon(
                    Icons.logout_outlined,
                    color: color.onPrimary,
                  ),
                  text: "Logout",
                  color: color.onSecondary,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginPage.routeName);
                  },
                ),
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                MyButton(
                  leading: Icon(
                    Icons.delete_outlined,
                    color: color.onPrimary,
                  ),
                  text: "Delete Account",
                  color: color.onSecondary,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
