// ignore_for_file: file_names

class UserData {
  String name;
  String email;
  String pass;

  UserData({required this.email, required this.name, required this.pass});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'pass': pass};
  }

  static UserData fromuserdata(Map<String, dynamic> json) =>
      UserData(email: json['email'], name: json['name'], pass: json['pass']);
}
