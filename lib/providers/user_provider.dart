import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _username;

  String? get username => _username;

  bool get isLoggedIn => _username != null;

  // Set username dan simpan ke SharedPreferences
  Future<void> setUsername(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    notifyListeners();
  }

  // Ambil username dari SharedPreferences saat aplikasi dimulai
  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    notifyListeners();
  }

  // Logout dan hapus username dari SharedPreferences
  Future<void> logout() async {
    _username = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    notifyListeners();
  }
}
