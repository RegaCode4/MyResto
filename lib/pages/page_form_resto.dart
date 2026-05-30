// lib/pages/page_form_resto.dart

import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/resto.dart';
import '../services/api_service.dart';

class PageFormResto extends StatefulWidget {
  final int userId;
  final Resto? resto; // null = mode tambah, ada isi = mode edit

  const PageFormResto({
    super.key,
    required this.userId,
    this.resto,
  });

  @override
  State<PageFormResto> createState() => _PageFormRestoState();
}

class _PageFormRestoState extends State<PageFormResto> {
  final _namaCtrl = TextEditingController();
  final _jenisCtrl = TextEditingController();
  final _reviewCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();

  bool get _isEdit => widget.resto != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final r = widget.resto!;
      _namaCtrl.text = r.namaResto;
      _jenisCtrl.text = r.jenisKuliner;
      _reviewCtrl.text = r.reviewSingkat;
      _latCtrl.text = r.latitude.toString();
      _lngCtrl.text = r.longitude.toString();
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _jenisCtrl.dispose();
    _reviewCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submit() async {
    if (_namaCtrl.text.isEmpty ||
        _latCtrl.text.isEmpty ||
        _lngCtrl.text.isEmpty) {
      _showSnackBar('Nama resto, latitude, dan longitude wajib diisi');
      return;
    }

    final lat = double.tryParse(_latCtrl.text);
    final lng = double.tryParse(_lngCtrl.text);
    if (lat == null || lng == null) {
      _showSnackBar('Format latitude/longitude tidak valid');
      return;
    }

    try {
      Map<String, dynamic> res;

      if (_isEdit) {
        res = await ApiService.updateResto(
          id: widget.resto!.id,
          namaResto: _namaCtrl.text.trim(),
          jenisKuliner: _jenisCtrl.text.trim(),
          reviewSingkat: _reviewCtrl.text.trim(),
          latitude: lat,
          longitude: lng,
        );
      } else {
        res = await ApiService.insertResto(
          userId: widget.userId,
          namaResto: _namaCtrl.text.trim(),
          jenisKuliner: _jenisCtrl.text.trim(),
          reviewSingkat: _reviewCtrl.text.trim(),
          latitude: lat,
          longitude: lng,
        );
      }

      _showSnackBar(res['message'] ?? '');
      if (res['is_success'] == true && mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Restoran' : 'Tambah Restoran'),
        backgroundColor: Color(kPrimaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _namaCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nama Restoran *',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _jenisCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Jenis Kuliner',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _reviewCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Review Singkat',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _latCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Latitude *',
                  hintText: 'Contoh: -0.9143211',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _lngCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Longitude *',
                  hintText: 'Contoh: 100.4660',
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
                onPressed: _submit,
                child: Text(_isEdit ? 'Simpan Perubahan' : 'Tambah Restoran'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
