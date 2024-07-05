import 'package:file_server/constants/app_routes.dart';
import 'package:file_server/constants/theme_data.dart';
import 'package:file_server/pages/file_email.dart';
import 'package:file_server/pages/home.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/pages/opt.dart';
import 'package:file_server/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/user.provider.dart';

void main() {
  runApp(const FileServerApp());
}

class FileServerApp extends StatelessWidget {
  const FileServerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(
          create: (_) => UserData(),
        ),
        // ChangeNotifierProvider<MedicationData>(
        //   create: (_) => MedicationData(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(),
        routes: AppRoutes.getRoutes(),
        home: const HomePage(),
      ),
    );
  }
}
