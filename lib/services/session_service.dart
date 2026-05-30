// lib/services/session_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyId       = 'user_id';
  static const _keyUsername = 'username';
  static const _keyFullname = 'fullname';

  static Future<void> saveSession({
    required int    id,
    required String username,
    required String fullname,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(   _keyId,       id);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyFullname, fullname);
  }

  static Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_keyId);
    if (id == null) return null;
    return {
      'id':       id,
      'username': prefs.getString(_keyUsername) ?? '',
      'fullname': prefs.getString(_keyFullname) ?? '',
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
