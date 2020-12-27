class UserModel {
  String name = "";
  String age = "";
  String password = "";
  String email = "";
  String uid = "";

  UserModel({
    this.age,
    this.email,
    this.name,
    this.password,
    this.uid,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    age = json["age"];
    password = json["password"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["name"] = this.name;
    data["age"] = this.age;
    data["password"] = this.password;
    data["email"] = this.email;

    return data;
  }
}
