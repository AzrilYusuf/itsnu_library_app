import 'package:flutter/material.dart';
import 'package:itsnu_app/screens/halaman_penulis.dart';
import 'package:itsnu_app/screens/halaman_buku.dart';
import 'package:itsnu_app/screens/halaman_kategori.dart';
import 'package:itsnu_app/screens/halaman_profil.dart';

void main() {
  runApp(const PERPUSITS());
}

class PERPUSITS extends StatelessWidget {
  const PERPUSITS({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  // Selalu mulai dari tab "Beranda" (index 0)
  final int _currentIndex = 0;

  void _bukaHalaman(int index) {
    // Navigasi hanya terjadi untuk item selain "Beranda"
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanPenulis()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanBuku()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanKategori()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanProfil()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PERPUSITS"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pastikan Anda sudah menambahkan logo di assets/images/logo.png
            Image.asset(
              "assets/images/logo.png",
              width: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 150);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Selamat Datang!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("Mahasiswa ITSNU"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _bukaHalaman,
        selectedItemColor: Colors.teal,
        type: BottomNavigationBarType.fixed, // Agar warna background terlihat
        backgroundColor: Colors.grey[200],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: "Penulis",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Buku"),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Kategori",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
