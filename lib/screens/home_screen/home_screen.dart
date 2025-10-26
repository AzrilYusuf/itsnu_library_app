import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsnu_app/models/author_model.dart';
import 'package:itsnu_app/models/book_model.dart';
import 'package:itsnu_app/providers/author_provider.dart';
import 'package:itsnu_app/providers/book_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _loadData() {
    final BookProvider bookProvider = Provider.of<BookProvider>(
      context,
      listen: false,
    );
    final AuthorProvider authorProvider = Provider.of<AuthorProvider>(
      context,
      listen: false,
    );

    bookProvider.fetchBooks();
    authorProvider.fetchAuthors();
  }

  @override
  Widget build(BuildContext context) {
    final List<AuthorModel> authors = Provider.of<AuthorProvider>(
      context,
    ).authors; // Listen: true

    return Scaffold(
      appBar: AppBar(title: Text('PERPUS ITSNU')),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
        child: Column(
          children: [
            // Books Collection
            SizedBox(
              height: 230.0, // required to constrain height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Koleksi Buku',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  Expanded(
                    child: Consumer<BookProvider>(
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
                          return Center(
                            child: Text('Error: ${bookProvider.errorMessage}'),
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: bookProvider.books.length,
                            itemBuilder: (context, index) {
                              final BookModel book = bookProvider.books[index];
                              return GestureDetector(
                                onTap: () {
                                  GoRouter.of(
                                    context,
                                  ).go('/books/detail', extra: book);
                                },

                                // Book card
                                child: Container(
                                  width: 100.0,
                                  height: 150.0,
                                  margin: const EdgeInsets.all(6.0),
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(14.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          255,
                                          134,
                                          87,
                                          87,
                                        ),
                                        blurRadius: 2,
                                        offset: const Offset(0, 2.0),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // Book image
                                      Container(
                                        width: 90.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                          // Set background image either from user metadata or default
                                          image: book.imageUrl != null
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                    book.imageUrl!,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: book.imageUrl == null
                                            ? Icon(
                                                Icons.book,
                                                size: 60.0,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                              )
                                            : null,
                                      ),

                                      const SizedBox(height: 4.0),

                                      // Book title
                                      Text(
                                        book.title,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                      const SizedBox(height: 2.0),

                                      // Book author
                                      Text(
                                        authors
                                            .firstWhere(
                                              (a) => a.id == book.authorId,
                                            )
                                            .name,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontStyle: FontStyle.italic,
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
            ),

            const SizedBox(height: 16.0),

            // Authors
            SizedBox(
              height: 190.0, // required to constrain height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Penulis',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8.0),

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
                            child: Text(
                              'Error: ${authorProvider.errorMessage}',
                            ),
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: authorProvider.authors.length,
                            itemBuilder: (context, index) {
                              final AuthorModel author =
                                  authorProvider.authors[index];
                              return GestureDetector(
                                onTap: () {
                                  GoRouter.of(
                                    context,
                                  ).go('/authors/detail', extra: author);
                                },

                                // Author card
                                child: Container(
                                  width: 100.0,
                                  height: 150.0,
                                  margin: const EdgeInsets.all(6.0),
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(14.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          255,
                                          134,
                                          87,
                                          87,
                                        ),
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
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                          // Set background image either from user metadata or default
                                          image: author.imageUrl != null
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                    author.imageUrl!,
                                                  ),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
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
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
