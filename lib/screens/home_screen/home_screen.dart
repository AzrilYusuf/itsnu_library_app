import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    );
  }
}
