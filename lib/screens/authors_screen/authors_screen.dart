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
      appBar: AppBar(title: const Text('Galeri Penulis')),
      body: Column(
        children: [
          // Widget untuk menampilkan grid thumbnail
          Expanded(
            child: Consumer<AuthorProvider>(
              builder: (context, authorProvider, child) {
                if (authorProvider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
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
                          childAspectRatio: 0.70,
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
                        // Author card
                        child: Container(
                          width: 100.0,
                          height: 150.0,
                          margin: const EdgeInsets.all(6.0),
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(14.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 134, 87, 87),
                                blurRadius: 2,
                                offset: const Offset(0, 2.0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Author image
                              Container(
                                width: 90.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12.0),
                                  // Set background image either from user metadata or default
                                  image: author.imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(author.imageUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: author.imageUrl == null
                                    ? Icon(
                                        Icons.person,
                                        size: 60.0,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      )
                                    : null,
                              ),

                              const SizedBox(height: 6.0),

                              // Author name
                              Text(
                                author.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
