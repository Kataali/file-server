import '../models/file.dart';
import 'package:flutter/foundation.dart';

class FileData extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<File> _allFiles = [
    File(
      title: "Naming Ceremony",
      type: "JPG",
      description:
          "The file represents a sample of the naming ceremony card design.",
      uploadedOn: DateTime.now.toString(),
      id: 1,
      path: '__',
    ),
    File(
        id: 2,
      title: "Naming Ceremony",
      type: "PDF",
      description:
          "The file represents a sample of the naming ceremony card design.",
      uploadedOn: DateTime.now.toString(),
        path: "__"
    ),
    File(
        id: 3,
      title: "Naming Ceremony",
      type: "PNG",
      description:
          "The file represents a sample of the naming ceremony card design.",
      uploadedOn: DateTime.now.toString(),
        path: "__"
    )
  ];

  void addFile(File product) {
    _allFiles.add(product);
    notifyListeners();
  }

  void removeFile(File product) {
    _allFiles.remove(product);
    notifyListeners();
  }

  void emptyVitalsList() {
    _allFiles.clear();
  }

  void mergeWithVitalList(List<File> newFiles) {
    _allFiles.addAll(newFiles);
    notifyListeners();
  }

  int get filesLength => _allFiles.length;
  File getFileByIndex(int index) => _allFiles[index];
}
