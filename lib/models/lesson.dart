class Lesson {
  String title;
  String description;
  DateTime created;
  String fileType;
  List<dynamic> fileUrls;
  String lId;
  Lesson({
    this.title,
    this.description,
    this.created,
    this.fileType,
    this.fileUrls,
    this.lId
  });
  Lesson.fromJson({Map<String, dynamic> json,String iD}) {
    title = json["Title"];
    description = json["Description"];
    created = json["Created"].toDate();
    fileType = json["fileType"];
    fileUrls = json["fileUrls"];
    lId=iD;
  }
}
