import 'database_service.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  factory AuthService() => _instance;

  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> login(String username, String password) async {
    final user = await DatabaseService().getUser(username, password);
    if (user != null) {
      _currentUser = user;
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
  }
}
