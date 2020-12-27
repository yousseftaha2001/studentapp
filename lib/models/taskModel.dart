
class TaskModel {
  String name;
  String description;
  String id;
  String createdTime;
  String deadline;
  String attachenmts = "";


  TaskModel({
    this.name,
    this.deadline,
    this.description,
    this.attachenmts,
    this.createdTime,
    this.id,
  });
  TaskModel.fromJson(Map<String, dynamic> json,String tid) {
    name = json["name"];
    description = json["description"];
    id = tid;
    attachenmts = json["attachenmts"];
    createdTime = json["createdTime"];
    deadline = json["deadline"];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["name"] = this.name;
    data["description"] = this.description;
    data["id"] = this.id;
    data["attachenmts"] = this.attachenmts;
    data["deadline"] = this.deadline;
    data["createdTime"] = this.createdTime;
    return data;
  }
}
