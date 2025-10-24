import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsnu_app/models/author_model.dart';
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

    if (authorProvider.authors.isNotEmpty) return;
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
                  final List<AuthorModel> authors = authorProvider.authors;
                  return GridView.builder(
                    padding: const EdgeInsets.all(12.0),
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
                          GoRouter.of(
                            context,
                          ).go('/authors/form', extra: author);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: author.imageUrl != null
                                    ? Image.network(
                                        author.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.deepPurple,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  author.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
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
