import 'package:flutter/material.dart';

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
    return const Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 70),
          child: MyAppBar(title: "Manage Account")),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
