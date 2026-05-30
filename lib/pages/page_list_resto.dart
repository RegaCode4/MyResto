// lib/pages/page_list_resto.dart

import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/resto.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
import 'page_login.dart';
import 'page_form_resto.dart';
import 'page_detail_map.dart';

class PageListResto extends StatefulWidget {
  final int userId;
  final String fullname;

  const PageListResto({
    super.key,
    required this.userId,
    required this.fullname,
  });

  @override
  State<PageListResto> createState() => _PageListRestoState();
}

class _PageListRestoState extends State<PageListResto> {
  late Future<List<Resto>> _futureResto;
  final _searchCtrl = TextEditingController();
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      _futureResto = ApiService.getResto(widget.userId);
    });
  }

  Future<void> _confirmDelete(Resto resto) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Restoran'),
        content: Text('Yakin ingin menghapus "${resto.namaResto}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final res = await ApiService.deleteResto(resto.id);
      _showSnack(res['message'] ?? '');
      _loadData();
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _logout() async {
    await SessionService.clearSession();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PageLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kBgColor),
      appBar: AppBar(
        title: const Text('Rekomendasi Resto Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PageFormResto(userId: widget.userId),
            ),
          );
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _keyword = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // List
          Expanded(
            child: FutureBuilder<List<Resto>>(
              future: _futureResto,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final all = snapshot.data ?? [];
                final filtered = _keyword.isEmpty
                    ? all
                    : all
                        .where((r) =>
                            r.namaResto.toLowerCase().contains(_keyword) ||
                            r.jenisKuliner.toLowerCase().contains(_keyword))
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('Belum ada data restoran.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _RestoCard(
                      resto: filtered[i],
                      // Tap card → buka peta
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PageDetailMap(resto: filtered[i]),
                        ),
                      ),
                      // Tombol edit → buka form edit
                      onEdit: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PageFormResto(
                              userId: widget.userId,
                              resto: filtered[i],
                            ),
                          ),
                        );
                        _loadData();
                      },
                      // Tombol hapus
                      onDelete: () => _confirmDelete(filtered[i]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card Widget ────────────────────────────────────────────────────────────────

class _RestoCard extends StatelessWidget {
  final Resto resto;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RestoCard({
    required this.resto,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        // Tap seluruh card → buka peta
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar restoran
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
                  color: Color(kSecondaryColor),
                  child: const Icon(Icons.restaurant,
                      color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resto.namaResto,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      resto.jenisKuliner,
                      style:
                          TextStyle(color: Color(kPrimaryColor), fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      resto.reviewSingkat,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Tombol Edit & Hapus
                    Row(
                      children: [
                        _ActionBtn(
                          icon: Icons.edit_outlined,
                          label: 'Edit',
                          color: Colors.blue,
                          onTap: onEdit,
                        ),
                        const SizedBox(width: 16),
                        _ActionBtn(
                          icon: Icons.delete_outline,
                          label: 'Hapus',
                          color: Colors.red,
                          onTap: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Indikator tap ke peta
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Hentikan tap agar tidak trigger InkWell card di atasnya
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}
