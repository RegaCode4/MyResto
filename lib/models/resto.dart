// lib/models/resto.dart

class Resto {
  final int    id;
  final int    userId;
  final String namaResto;
  final String jenisKuliner;
  final String reviewSingkat;
  final double latitude;
  final double longitude;

  Resto({
    required this.id,
    required this.userId,
    required this.namaResto,
    required this.jenisKuliner,
    required this.reviewSingkat,
    required this.latitude,
    required this.longitude,
  });

  factory Resto.fromJson(Map<String, dynamic> json) {
    return Resto(
      id:            json['id'],
      userId:        json['user_id'],
      namaResto:     json['nama_resto']     ?? '',
      jenisKuliner:  json['jenis_kuliner']  ?? '',
      reviewSingkat: json['review_singkat'] ?? '',
      latitude:      (json['latitude']  as num).toDouble(),
      longitude:     (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id':             id,
    'user_id':        userId,
    'nama_resto':     namaResto,
    'jenis_kuliner':  jenisKuliner,
    'review_singkat': reviewSingkat,
    'latitude':       latitude,
    'longitude':      longitude,
  };
}
