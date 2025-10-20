import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:itsnu_app/providers/author_provider.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
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
    final authorProvider = Provider.of<AuthorProvider>(context, listen: false);

    await authorProvider.fetchAuthors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galeri Penulis"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Widget untuk menampilkan grid thumbnail
          Expanded(
            child: Consumer<AuthorProvider>(
              builder: (context, authorProvider, child) {
                if (authorProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (authorProvider.hasError) {
                  return Center(
                    child: Text('Error: ${authorProvider.errorMessage}'),
                  );
                } else {
                  final authors = authorProvider.authors;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                    itemCount: authors.length,
                    itemBuilder: (context, index) {
                      final author = authors[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle thumbnail tap if needed
                        },
                        child: Image.network(
                          author.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoRouter.of(context).go('/authors/form');
        },
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
