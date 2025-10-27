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
      appBar: AppBar(
        title: Text('Detail Buku'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70.0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: widget.book.imageUrl != null
                    ? NetworkImage(widget.book.imageUrl!)
                    : null,
                child: widget.book.imageUrl == null
                    ? Icon(Icons.book, size: 60.0, color: Theme.of(context).colorScheme.secondary)
                    : null,
              ),
            ),

            const SizedBox(height: 16.0),

            Text(
              widget.book.title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            const SizedBox(height: 16.0),

            Text(
              'Penulis: ${authors.name}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            const SizedBox(height: 16.0),

            Text(
              'Kategori: ${widget.book.category.name}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            // Add more book details here
          ],
        ),
      ),
    );
  }
}
