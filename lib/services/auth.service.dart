import 'dart:convert';

import 'package:climber_monitoring/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  static const String uri = 'https://qua-ecs.climberrms.com/api/authenticate';
  final _storage = const FlutterSecureStorage();

  Future<bool> login(User user) async {
    user.username =  'jp77';
    user.password = 'jB5k6Ijb7BbJypG8TWCDj9rNXTVkWA2A';
    
    final response = await http.post(Uri.parse(uri),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
      body: jsonEncode(user)
    );

    String token = response.headers.entries.firstWhere((element) => element.key == 'authorization').value;
    await _storage.write(key: 'token', value: token);

    return token != '';
  }

  Future<String?> getToken() {
    return _storage.read(key: 'token');
  }

  void logout() async {
    _storage.deleteAll();
  }
}