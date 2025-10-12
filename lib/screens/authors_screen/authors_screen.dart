import 'package:flutter/material.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  // URL gambar utama yang akan berubah
  String gambarPenulisUtama = "https://i.pravatar.cc/500?img=7";

  // List data penulis (URL dan nama)
  final List<Map<String, String>> dataPenulis = [
    {"url": "https://i.pravatar.cc/150?img=7", "id": "7"},
    {"url": "https://i.pravatar.cc/150?img=5", "id": "5"},
    {"url": "https://i.pravatar.cc/150?img=11", "id": "11"},
    {"url": "https://i.pravatar.cc/150?img=14", "id": "14"},
    {"url": "https://i.pravatar.cc/150?img=32", "id": "32"},
    {"url": "https://i.pravatar.cc/150?img=40", "id": "40"},
  ];

  void _gantiGambarUtama(String id) {
    setState(() {
      gambarPenulisUtama = "https://i.pravatar.cc/500?img=$id";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galeri Penulis"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Widget untuk menampilkan gambar utama
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(gambarPenulisUtama),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Widget untuk menampilkan grid thumbnail
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: dataPenulis.length,
              itemBuilder: (context, index) {
                final penulis = dataPenulis[index];
                return GestureDetector(
                  onTap: () => _gantiGambarUtama(penulis['id']!),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(penulis['url']!),
                        fit: BoxFit.cover,
                      ),
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
