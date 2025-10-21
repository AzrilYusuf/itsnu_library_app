import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:itsnu_app/providers/book_provider.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  void initState() {
    super.initState();
    // Run code after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData() async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    await bookProvider.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        backgroundColor: Colors.teal,
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          return ListView.builder(
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final book = bookProvider.books[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: book.imageUrl != null
                        ? NetworkImage(book.imageUrl!)
                        : null,
                    child: book.imageUrl == null
                        ? const Icon(Icons.book)
                        : null,
                  ),
                  title: Text(book.title),
                  subtitle: Text(
                    'Penulis: ${book.authorName ?? 'Tidak diketahui'}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    GoRouter.of(context).go('/books/form', extra: book);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/books/form');
        },
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
