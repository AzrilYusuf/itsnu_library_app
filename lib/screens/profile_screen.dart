import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Pengguna"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 60, child: Icon(Icons.person, size: 80)),
            SizedBox(height: 20),
            Text(
              "Ini adalah halaman profil Anda",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
