import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsnu_app/models/book_model.dart';
import 'package:provider/provider.dart';
import 'package:itsnu_app/providers/book_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Map<int, bool> _expanded = {};

  @override
  void initState() {
    super.initState();
    _loadData();
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
    final List<BookModel> books = Provider.of<BookProvider>(context).books;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Buku'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: BookCategory.values.length,
        itemBuilder: (context, index) {
          final category = BookCategory.values[index];
          final isExpanded = _expanded[index] ?? false;
          final filteredBooks = books
              .where((book) => book.category == category)
              .toList();

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(category.name),
                    trailing: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onTap: () {
                      setState(() {
                        _expanded[index] = !isExpanded;
                      });
                    },
                  ),
                  if (isExpanded) ...[
                    if (filteredBooks.isNotEmpty)
                      ...filteredBooks.map(
                        (book) => ListTile(
                          title: Text('Judul: ${book.title}'),
                          onTap: () => GoRouter.of(
                            context,
                          ).go('/books/detail', extra: book),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Tidak ada buku dalam kategori ini.'),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
