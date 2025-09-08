import 'package:flutter/material.dart';

class HalamanBuku extends StatelessWidget {
  const HalamanBuku({super.key});

  // Data dummy untuk daftar buku
  final List<Map<String, String>> daftarBuku = const [
    {"judul": "Flutter untuk Pemula", "penulis": "Andi Setiawan", "imgId": "1"},
    {"judul": "Seni Berbicara", "penulis": "Budi Santoso", "imgId": "2"},
    {"judul": "Mastering Dart", "penulis": "Citra Lestari", "imgId": "3"},
    {"judul": "Kisah di Balik Awan", "penulis": "Dewi Anggraini", "imgId": "4"},
    {"judul": "Manajemen Waktu", "penulis": "Eko Prasetyo", "imgId": "6"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buku Populer"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: daftarBuku.length,
        itemBuilder: (context, index) {
          final buku = daftarBuku[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://picsum.photos/id/${buku['imgId']}/200/200",
                ),
              ),
              title: Text(buku['judul']!),
              subtitle: Text("Penulis: ${buku['penulis']!}"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Aksi ketika item di-tap
              },
            ),
          );
        },
      ),
    );
  }
}
