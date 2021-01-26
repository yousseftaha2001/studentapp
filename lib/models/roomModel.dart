class RoomModel {
  int maximumStudents;
  String teacherId;
  String rules;
  String title;
  String roomId;

  RoomModel(
      {this.maximumStudents,
      this.teacherId,
      this.rules,
      this.title,
      this.roomId});

  RoomModel.fromJson(Map<String, dynamic> json, String id) {
    title = json["title"];
    roomId = id;
  }
}
