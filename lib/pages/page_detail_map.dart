// lib/pages/page_detail_map.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/resto.dart';

class PageDetailMap extends StatefulWidget {
  final Resto resto;

  const PageDetailMap({super.key, required this.resto});

  @override
  State<PageDetailMap> createState() => _PageDetailMapState();
}

class _PageDetailMapState extends State<PageDetailMap> {
  late GoogleMapController _mapController;
  late LatLng _koordinat;
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _koordinat = LatLng(widget.resto.latitude, widget.resto.longitude);
    _markers = {
      Marker(
        markerId: MarkerId(widget.resto.id.toString()),
        position: _koordinat,
        infoWindow: InfoWindow(
          title: widget.resto.namaResto,
          snippet: widget.resto.reviewSingkat,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final resto = widget.resto;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PageDetailMap'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Peta — tinggi tetap 300 sesuai referensi
          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _koordinat,
                zoom: 15,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),

          // Info Panel
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama restoran
                  Text(
                    resto.namaResto,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Badge jenis kuliner
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      resto.jenisKuliner.isEmpty
                          ? 'Kuliner'
                          : resto.jenisKuliner,
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Ulasan singkat
                  const Text(
                    'Ulasan Singkat:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    resto.reviewSingkat.isEmpty
                        ? 'Belum ada ulasan.'
                        : resto.reviewSingkat,
                    style: const TextStyle(fontSize: 14, height: 1.6),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Koordinat lokasi
                  const Text(
                    'Koordinat Lokasi:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lat: ${resto.latitude} | Lng: ${resto.longitude}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Petunjuk Arah — animateCamera zoom ke lokasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(_koordinat, 17),
                        );
                      },
                      icon: const Icon(Icons.navigation),
                      label: const Text('Petunjuk Arah'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
