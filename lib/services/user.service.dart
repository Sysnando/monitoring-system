import 'package:climber_monitoring/models/user.dart';

class UserService {

  Future<String?> login(User user){
    return Future.value('{token: asdf1234}');
  }
}