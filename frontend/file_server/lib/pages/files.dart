import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/api_model.dart';
import '../models/file.dart';
import '../providers/user.provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_textfield.dart';

class HomePageView extends StatefulWidget {
  static const routeName = '/home';
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  List<String> cols = [
    "Title",
    "Type",
    "Description",
    "Uploaded on",
    "Download",
    "Send as Email"
  ];
  List<String> titles = ["Title 1", "Title 2", "Title 3"];
  List<String> types = ['png', 'jpg', 'pdf'];
  List<String> descriptions = ['PNG file', 'JPG file', 'PDF file'];
  bool buttonColorState = false;
  final TextEditingController searchController = TextEditingController();
  final String serverEndpoint = Api.filesEndpoint;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: MyAppBar(title: "Library"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 35,
                  width: 300,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.search_outlined),
                    hintText: "Search for File",
                    controller: searchController,
                  ),
                ),
                const VerticalDivider(
                  width: 15,
                  thickness: .001,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Search",
                    style: TextStyle(color: color.onPrimary),
                  ),
                )
              ],
            ),
            const Divider(
              height: 30,
              thickness: .001,
            ),
            Row(
              children: [
                Expanded(
                  child: DataTable(
                    headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: color.onPrimary),
                    headingRowColor: WidgetStateProperty.all(color.primary),
                    dataTextStyle: TextStyle(color: color.secondary),
                    columns: List.generate(
                      cols.length,
                      (index) => DataColumn(
                        label: Text(
                          cols[index],
                        ),
                      ),
                    ),
                    rows: List.generate(
                      titles.length,
                      (index) {
                        return DataRow(cells: <DataCell>[
                          DataCell(
                            Text(titles[index]),
                          ),
                          DataCell(
                            Text(types[index]),
                          ),
                          DataCell(
                            Text(
                              descriptions[index],
                            ),
                          ),
                          DataCell(
                            Text(DateTime.now().toString()),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                print("Download ${titles[index]}");
                              },
                              icon: Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(width: 0.5),
                                    ),
                                    // color: color.tertiary,
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.only(right: 7),
                                  child: const Icon(Icons.download_outlined)),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                print("Email  ${titles[index]}");
                              },
                              icon: Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(width: 1),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.only(right: 7),
                                  child: const Icon(Icons.email_outlined)),
                            ),
                          ),
                        ]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> logIn() async {
    final res = await http.get(
      Uri.parse("$serverEndpoint/all"),
    );
    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      final File user = File.fromJson(resData["userData"]);
      if (context.mounted) {
        // Provider.of<UserData>(context, listen: false).getUser(user);
      }
      return true;
      return false;
    } else {
      throw Exception("Failed to login.");
    }
  }
}
