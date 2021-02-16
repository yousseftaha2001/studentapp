class Assignment {
  String title;
  String description;
  DateTime deadline;
  String fileType;
  List<dynamic> fileUrls;
  Assignment({
    this.title,
    this.description,
    this.deadline,
    this.fileType,
    this.fileUrls,
  });
  Assignment.fromJson({Map<String, dynamic> json}) {
    title = json["Title"];
    description = json["Description"];
    deadline = json["deadline"].toDate();
    fileType = json["fileType"];
    fileUrls = json["fileUrls"];
  }
}
