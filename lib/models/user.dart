class User {

  String username;
  String password;

  User({
    required this.username,
    required this.password
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password
  };

  clear() {
    username = '';
    password = '';
  }
}