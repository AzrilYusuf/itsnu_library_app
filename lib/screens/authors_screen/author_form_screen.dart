import 'package:flutter/material.dart';

class AuthorFormScreen extends StatefulWidget {
  const AuthorFormScreen({super.key});

  @override
  State<AuthorFormScreen> createState() => _AuthorFormScreenState();
}

class _AuthorFormScreenState extends State<AuthorFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Author Form"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text("Author Form Screen"),
      ),
    );
  }
}