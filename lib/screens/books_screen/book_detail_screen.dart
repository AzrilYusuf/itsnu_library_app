import 'package:flutter/material.dart';
import 'package:itsnu_app/models/author_model.dart';
import 'package:itsnu_app/models/book_model.dart';
import 'package:itsnu_app/providers/author_provider.dart';
import 'package:provider/provider.dart';

class BookDetailScreen extends StatefulWidget {
  final BookModel book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadData() async {
    final AuthorProvider authorProvider = Provider.of<AuthorProvider>(
      context,
      listen: false,
    );

    if (authorProvider.authors.isNotEmpty) return;
    await authorProvider.fetchAuthors();
  }

  @override
  Widget build(BuildContext context) {
    final AuthorModel authors = Provider.of<AuthorProvider>(
      context,
    ).authors.firstWhere((author) => author.id == widget.book.authorId);

    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title), 
      backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.grey[200],
                backgroundImage: widget.book.imageUrl != null
                    ? NetworkImage(widget.book.imageUrl!)
                    : AssetImage('assets/images/placeholder.png'),
                child: widget.book.imageUrl == null
                    ? Icon(
                        Icons.book,
                        size: 80.0,
                        color: Colors.grey[800],
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),
            Text('Title: ${widget.book.title}'),
            const SizedBox(height: 16),
            Text('Author: ${authors.name}'),
            const SizedBox(height: 16),
            Text('Category: ${widget.book.category.name}'),
            // Add more book details here
          ],
        ),
      ),
    );
  }
}
