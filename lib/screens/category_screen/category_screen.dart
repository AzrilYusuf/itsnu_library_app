import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itsnu_app/providers/book_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
    final BookProvider bookProvider = Provider.of<BookProvider>(context, listen: false);

    await bookProvider.fetchBooks();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Buku'),
        backgroundColor: Colors.teal,
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          return ListView.builder(
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final category = bookProvider.books[index].category.value;
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(category),
                  onTap: () {
                    // Navigate to book details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
