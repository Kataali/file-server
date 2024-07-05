class File {
  final String title;
  final String type;
  final String description;
  final String uploadedOn;

  File(
      {required this.title,
      required this.type,
      required this.description,
      required this.uploadedOn});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
        title: json['title'],
        type: json['type'],
        description: json['description'],
        uploadedOn: json['uploadedOn']);
  }
}
