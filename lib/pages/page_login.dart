// lib/pages/page_login.dart

import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
import 'page_register.dart';
import 'page_list_resto.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Semua field harus diisi');
      return;
    }

    try {
      final res = await ApiService.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (res['is_success'] == true) {
        _showSnackBar('Berhasil login');
        final user = res['data'];
        await SessionService.saveSession(
          id: user['id'] is int ? user['id'] : int.parse(user['id'].toString()),
          username: user['username'],
          fullname: user['fullname'],
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => PageListResto(
                userId: user['id'] is int
                    ? user['id']
                    : int.parse(user['id'].toString()),
                fullname: user['fullname'],
              ),
            ),
          );
        }
      } else {
        _showSnackBar(res['message'] ?? 'Login gagal');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan saat melakukan login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Color(kPrimaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(kPrimaryColor),
                  foregroundColor: Colors.white,
                ),
                onPressed: login,
                child: const Text('Login'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PageRegister()),
                  );
                },
                child: const Text('Belum punya akun? Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
