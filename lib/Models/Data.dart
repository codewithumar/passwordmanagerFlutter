class userdata {
  String name;
  String email;
  String pass;

  userdata({required this.email, required this.name, required this.pass});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'pass': pass};
  }
  static userdata fromuserdata(Map<String,dynamic>json)=>userdata(email: json['email'], name: json['name'], pass: json['pass']);
}
