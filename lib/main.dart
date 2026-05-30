// lib/main.dart

import 'package:flutter/material.dart';
import 'helper/session_manager.dart';
import 'pages/page_login.dart';
import 'pages/page_list_resto.dart';

void main() {
  runApp(const RestoTrackerApp());
}

class RestoTrackerApp extends StatelessWidget {
  const RestoTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RestoTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100),
          primary: const Color(0xFFE65100),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE65100),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE65100),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const SplashRouter(),
    );
  }
}

// Cek session saat aplikasi pertama dibuka
class SplashRouter extends StatelessWidget {
  const SplashRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionManager.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Sesi aktif → langsung ke Dashboard
        if (snapshot.data == true) {
          return FutureBuilder<Map<String, String?>>(
            future: SessionManager.getUserSession(),
            builder: (context, sessionSnap) {
              if (sessionSnap.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final session = sessionSnap.data;
              if (session != null) {
                return PageListResto(
                  userId: int.tryParse(session['id'] ?? '0') ?? 0,
                  fullname: session['fullname'] ?? '',
                );
              }
              return const PageLogin();
            },
          );
        }

        // Tidak ada sesi → halaman Login
        return const PageLogin();
      },
    );
  }
}
