import 'package:flutter/material.dart';
import 'package:itsnu_app/models/book_model.dart';

class BookFormScreen extends StatefulWidget {
  final BookModel? book;

  const BookFormScreen({this.book, super.key});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Tambah Buku' : 'Edit Buku'),
      ),
      body: Center(
        child: Text(widget.book == null
            ? 'Form untuk menambahkan buku baru'
            : 'Form untuk mengedit buku: ${widget.book!.title}'),
      ),
    );
  }
}
