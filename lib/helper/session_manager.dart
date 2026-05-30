// lib/helper/session_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Fungsi untuk menyimpan data setelah berhasil login
  static Future<void> saveUserSession(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_success', true);
    await prefs.setString('username', userData['username']);
    await prefs.setString('fullname', userData['fullname']);
    await prefs.setString('id', userData['id'].toString());
  }

  // Fungsi untuk mengambil data user yang sedang login
  static Future<Map<String, String?>> getUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'is_success': prefs.getBool('is_success').toString(),
      'username': prefs.getString('username'),
      'fullname': prefs.getString('fullname'),
      'id': prefs.getString('id'),
    };
  }

  // Fungsi untuk mengecek apakah user sedang login atau belum
  static Future<bool> isLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_success') ?? false;
  }

  // Fungsi untuk menghapus data session (logout)
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_success');
    await prefs.clear();
  }
}
