// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/resto.dart';

class ApiService {
  // ── Auth ──────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String fullname,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {
        'username': username,
        'email':    email,
        'password': password,
        'fullname': fullname,
      },
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {
        'username': username,
        'password': password,
      },
    );
    return jsonDecode(res.body);
  }

  // ── Resto CRUD ────────────────────────────────────────────────────────────

  static Future<List<Resto>> getResto(int userId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/get_resto.php'),
      body: {'user_id': userId.toString()},
    );
    final json = jsonDecode(res.body);
    if (json['is_success'] == true) {
      return (json['data'] as List).map((e) => Resto.fromJson(e)).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> insertResto({
    required int    userId,
    required String namaResto,
    required String jenisKuliner,
    required String reviewSingkat,
    required double latitude,
    required double longitude,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/insert_resto.php'),
      body: {
        'user_id':        userId.toString(),
        'nama_resto':     namaResto,
        'jenis_kuliner':  jenisKuliner,
        'review_singkat': reviewSingkat,
        'latitude':       latitude.toString(),
        'longitude':      longitude.toString(),
      },
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateResto({
    required int    id,
    required String namaResto,
    required String jenisKuliner,
    required String reviewSingkat,
    required double latitude,
    required double longitude,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/update_resto.php'),
      body: {
        'id':             id.toString(),
        'nama_resto':     namaResto,
        'jenis_kuliner':  jenisKuliner,
        'review_singkat': reviewSingkat,
        'latitude':       latitude.toString(),
        'longitude':      longitude.toString(),
      },
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> deleteResto(int id) async {
    final res = await http.post(
      Uri.parse('$baseUrl/delete_resto.php'),
      body: {'id': id.toString()},
    );
    return jsonDecode(res.body);
  }
}
