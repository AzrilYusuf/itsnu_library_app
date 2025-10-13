import 'package:flutter/material.dart';
import 'package:itsnu_app/screens/auth_screen/auth_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itsnu_app/screens/authors_screen/authors_screen.dart';
import 'package:itsnu_app/screens/books_screen/books_screen.dart';
import 'package:itsnu_app/screens/category_screen/category_screen.dart';
import 'package:itsnu_app/screens/profile_screen/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Init Supabase
  await Supabase.initialize(
    url: 'https://uadcrpkrcmcdvgxrrhiq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhZGNycGtyY21jZHZneHJyaGlxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5OTc1MDUsImV4cCI6MjA3NTU3MzUwNX0.5d_FXgTZ2uJeznSJzl3ObvehX-lclQqTuy_sM0shbUk',
  );

  runApp(const PERPUSITSNU());
}

class PERPUSITSNU extends StatelessWidget {
  const PERPUSITSNU({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Selalu mulai dari tab "Beranda" (index 0)
  final int _currentIndex = 0;

  void _bukaHalaman(int index) {
    // Navigasi hanya terjadi untuk item selain "Beranda"
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AuthorsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BooksScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoryScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
