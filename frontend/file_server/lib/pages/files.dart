import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_saver/file_saver.dart';
import 'package:file_server/pages/file_email.dart';
import 'package:file_server/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:html' as html;

import '../models/api_model.dart';
import '../models/file.dart';
import '../models/file_args.dart';
import '../providers/file.provider.dart';
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
  // List<String> titles = ["Title 1", "Title 2", "Title 3"];
  // List<String> types = ['png', 'jpg', 'pdf'];
  // List<String> descriptions = ['PNG file', 'JPG file', 'PDF file'];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  final String serverEndpoint = Api.filesEndpoint;
  late List<File> files;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var provider = Provider.of<FileData>(context, listen: false);

    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      dismissible: false,
      child: Scaffold(
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
                      onPressed: () async {
                        final keyword = searchController.value.text.trim();
                        await search(keyword);
                      },
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
                    ),
                    const VerticalDivider(
                      width: 15,
                      thickness: .001,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          files = await getFiles();
                          print(files);
                          provider.emptyVitalsList();
                          provider.mergeWithVitalList(files);
                        } catch (e) {
                          CustomSnackbar.show(context, "$e");
                          // Navigator.pop(context);
                        }

                        setState(() {
                          isLoading = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Get Files",
                        style: TextStyle(color: color.onPrimary),
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: FutureBuilder(
                //           future: getFiles(),
                //           builder: (context, snapshot) {
                //             return DataTable(
                //               headingTextStyle: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                   fontStyle: FontStyle.italic,
                //                   color: color.onPrimary),
                //               headingRowColor:
                //                   WidgetStateProperty.all(color.primary),
                //               dataTextStyle: TextStyle(color: color.secondary),
                //               columns: List.generate(
                //                 cols.length,
                //                 (index) => DataColumn(
                //                   label: Text(
                //                     cols[index],
                //                   ),
                //                 ),
                //               ),

                //               rows: List.generate(
                //                 titles.length,
                //                 (index) {
                //                   return DataRow(cells: <DataCell>[
                //                     DataCell(
                //                       Text(titles[index]),

                //                     ),
                //                     DataCell(
                //                       Text(types[index]),
                //                     ),
                //                     DataCell(
                //                       Text(
                //                         descriptions[index],
                //                       ),
                //                     ),
                //                     DataCell(
                //                       Text(DateTime.now().toString()),
                //                     ),
                //                     DataCell(
                //                       IconButton(
                //                         onPressed: () {
                //                           print("Download ${titles[index]}");
                //                         },
                //                         icon: Container(
                //                             decoration: ShapeDecoration(
                //                               shape: RoundedRectangleBorder(
                //                                 borderRadius:
                //                                     BorderRadius.circular(5),
                //                                 side:
                //                                     const BorderSide(width: 0.5),
                //                               ),
                //                               // color: color.tertiary,
                //                             ),
                //                             padding: const EdgeInsets.all(3),
                //                             margin:
                //                                 const EdgeInsets.only(right: 7),
                //                             child: const Icon(
                //                                 Icons.download_outlined)),
                //                       ),
                //                     ),
                //                     DataCell(
                //                       IconButton(
                //                         onPressed: () {
                //                           print("Email  ${titles[index]}");
                //                         },
                //                         icon: Container(
                //                             decoration: ShapeDecoration(
                //                               shape: RoundedRectangleBorder(
                //                                 borderRadius:
                //                                     BorderRadius.circular(5),
                //                                 side: const BorderSide(width: 1),
                //                               ),
                //                             ),
                //                             padding: const EdgeInsets.all(3),
                //                             margin:
                //                                 const EdgeInsets.only(right: 7),
                //                             child:
                //                                 const Icon(Icons.email_outlined)),
                //                       ),
                //                     ),
                //                   ]);
                //                 },
                //               ),
                //             );
                //           }),
                //     ),
                //   ],
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Consumer<FileData>(builder: (BuildContext context,
                          FileData value, Widget? child) {
                        return FittedBox(
                          fit: BoxFit.contain,
                          child: DataTable(
                            headingTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: color.onPrimary),
                            columnSpacing: 20,
                            headingRowColor:
                                WidgetStateProperty.all(color.primary),
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
                              provider.filesLength,
                              (index) {
                                File file = provider.getFileByIndex(index);
                                return DataRow(cells: <DataCell>[
                                  DataCell(
                                    Text(file.title),
                                  ),
                                  DataCell(
                                    Text(file.type),
                                  ),
                                  DataCell(
                                    Text(file.description),
                                  ),
                                  DataCell(
                                    Text(file.uploadedOn),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () async {
                                        // print("Download ${file.path}");
                                        final String filePath = file.path;
                                        final String name = file.title;
                                        final String ext = file.type;
                                        try {
                                          if (await downloadFile(
                                              name, filePath, ext)) {
                                            if (context.mounted) {
                                              CustomSnackbar.show(
                                                context,
                                                "Download Finished",
                                              );
                                            }
                                          } else {
                                            if (context.mounted) {
                                              CustomSnackbar.show(
                                                context,
                                                "Could not download file Try Again",
                                              );
                                            }
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            CustomSnackbar.show(
                                              context,
                                              "Could not download file Try Again $e",
                                            );
                                          }
                                        }
                                      },
                                      icon: Container(
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side:
                                                  const BorderSide(width: 0.5),
                                            ),
                                            // color: color.tertiary,
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          margin:
                                              const EdgeInsets.only(right: 7),
                                          child: const Icon(
                                              Icons.download_outlined)),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          FileEmailPage.routeName,
                                          arguments: FileArgs(
                                            path: file.path,
                                            title: file.title,
                                          ),
                                        );
                                        // print("Email  ${file.title}");
                                      },
                                      icon: Container(
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: const BorderSide(width: 1),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          margin:
                                              const EdgeInsets.only(right: 7),
                                          child:
                                              const Icon(Icons.email_outlined)),
                                    ),
                                  ),
                                ]);
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Future<List<File>> getFiles() async {
    List<File> interimFiles = [];
    final res = await http.get(
      Uri.parse("$serverEndpoint/all"),
    );
    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      resData.forEach((i) {
        File file = File.fromJson(i);
        interimFiles.add(file);
      });
      return interimFiles;
    } else {
      throw Exception("Unable to get Files");
    }
  }

  Future<bool> downloadFile(filename, filePath, ext) async {
    try {
      final url = Uri.parse("$serverEndpoint/download/$filePath");
      final response = await http.get(url);
      final blob = html.Blob([response.bodyBytes]);
      final anchorElement = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(blob).toString(),
      )..setAttribute('download', "$filename$ext");
      html.document.body!.children.add(anchorElement);
      anchorElement.click();
      html.document.body!.children.remove(anchorElement);
      print(response.bodyBytes.length);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<File>> search(keyword) async {
    List<File> interimFiles = [];
    final res = await http.get(
      Uri.parse("$serverEndpoint/search/$keyword"),
    );
    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      print(resData);
      resData.forEach((i) {
        File file = File.fromJson(i);
        interimFiles.add(file);
      });
      return interimFiles;
    } else {
      throw Exception("Unable to get Files");
    }
  }
}
