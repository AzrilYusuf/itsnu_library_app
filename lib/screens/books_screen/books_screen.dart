import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsnu_app/models/author_model.dart';
import 'package:itsnu_app/models/book_model.dart';
import 'package:itsnu_app/providers/author_provider.dart';
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
    final BookProvider bookProvider = Provider.of<BookProvider>(
      context,
      listen: false,
    );

    if (bookProvider.books.isNotEmpty) return;
    await bookProvider.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    final List<AuthorModel> authors = Provider.of<AuthorProvider>(
      context,
      listen: false,
    ).authors;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Buku')),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (bookProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            );
          } else if (bookProvider.hasError) {
            return Center(child: Text('Error: ${bookProvider.errorMessage}'));
          } else {
            return ListView.builder(
              itemCount: bookProvider.books.length,
              itemBuilder: (context, index) {
                final BookModel book = bookProvider.books[index];
                return Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: book.imageUrl != null
                          ? NetworkImage(book.imageUrl!)
                          : null,
                      child: book.imageUrl == null
                          ? Icon(
                              Icons.book,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : null,
                    ),
                    title: Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    subtitle: Text(
                      'Penulis: ${book.authorName ?? authors.firstWhere(
                            (a) => a.id == book.authorId,
                            orElse: () => AuthorModel(id: '', name: 'Tidak diketahui'),
                          ).name}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onTap: () {
                      GoRouter.of(context).go('/books/form', extra: book);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/books/form');
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
