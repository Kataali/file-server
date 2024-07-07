import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/app_bar.dart';

class FileStatsPage extends StatefulWidget {
  static const routeName = '/file-stats';
  const FileStatsPage({super.key});

  @override
  State<FileStatsPage> createState() => _FileStatsPageState();
}

class _FileStatsPageState extends State<FileStatsPage> {
  List<String> cols = [
    "Title",
    "Type",
    "Description",
    "Uploaded on",
    "Download \nCount",
    "Email \nCount"
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: MyAppBar(title: "File Statistics"),
      ),
    );
  }

  // Future<List<File>> getFiles() async {
  //   List<File> interimFiles = [];
  //   final res = await http.get(
  //     Uri.parse("$serverEndpoint/all"),
  //   );
  //   if (res.statusCode == 200) {
  //     final resData = jsonDecode(res.body);
  //     resData.forEach((i) {
  //       File file = File.fromJson(i);
  //       interimFiles.add(file);
  //     });
  //     return interimFiles;
  //   } else {
  //     throw Exception("Unable to get Files");
  //   }
  // }
}
