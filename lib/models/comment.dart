class Comment {
  String name;
  String comment;
  DateTime time;
  
  Comment({
    this.name,
    this.comment,
    this.time,
   
  });
  Comment.fromJson({Map<String, dynamic> json,String iD}) {
    name = json["name"];
    comment = json["comment"];
    time = json["time"].toDate();
  }
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["name"] = this.name;
    data["comment"] = this.comment;
    data["time"] = this.time;
    return data;
  }
}
