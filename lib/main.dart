// lib/main.dart

import 'package:flutter/material.dart';
import 'constants.dart';
import 'services/session_service.dart';
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
          seedColor: Color(kPrimaryColor),
          primary:   Color(kPrimaryColor),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(kPrimaryColor),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(kPrimaryColor),
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
    return FutureBuilder<Map<String, dynamic>?>(
      future: SessionService.getSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Sesi aktif → langsung ke Dashboard
        if (snapshot.hasData && snapshot.data != null) {
          final session = snapshot.data!;
          return PageListResto(
            userId:   session['id'],
            fullname: session['fullname'],
          );
        }

        // Tidak ada sesi → halaman Login
        return const PageLogin();
      },
    );
  }
}
