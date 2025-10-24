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
      appBar: AppBar(
        title: const Text("PERPUSITS"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Selamat Datang di Perpustakaan ITSNU',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            const SizedBox(height: 16.0),

            // Books Collection
            SizedBox(
              height: 200.0, // required to constrain height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Koleksi Buku',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  Expanded(
                    child: Consumer<BookProvider>(
                      builder: (context, bookProvider, child) {
                        if (bookProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
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

                                child: Container(
                                  width: 100.0,
                                  height: 150.0,
                                  margin: const EdgeInsets.all(6.0),
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          255,
                                          218,
                                          218,
                                          218,
                                        ),
                                        blurRadius: 2,
                                        offset: const Offset(0, 2.0),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 70.0,
                                        height: 80.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            10.0,
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
                                            ? Icon(Icons.book, size: 60.0)
                                            : null,
                                      ),

                                      const SizedBox(height: 4.0),

                                      Text(
                                        book.title,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),

                                      const SizedBox(height: 2.0),

                                      Text(
                                        authors
                                            .firstWhere(
                                              (a) => a.id == book.authorId,
                                            )
                                            .name,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
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
              height: 160.0, // required to constrain height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Penulis',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  Expanded(
                    child: Consumer<AuthorProvider>(
                      builder: (context, authorProvider, child) {
                        if (authorProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (authorProvider.hasError) {
                          return Center(
                            child: Text('Error: ${authorProvider.errorMessage}'),
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: authorProvider.authors.length,
                            itemBuilder: (context, index) {
                              final AuthorModel author = authorProvider.authors[index];
                              return GestureDetector(
                                onTap: () {
                                  GoRouter.of(
                                    context,
                                  ).go('/authors/form', extra: author);
                                },

                                child: Container(
                                  width: 100.0,
                                  height: 150.0,
                                  margin: const EdgeInsets.all(6.0),
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          255,
                                          218,
                                          218,
                                          218,
                                        ),
                                        blurRadius: 2,
                                        offset: const Offset(0, 2.0),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 70.0,
                                        height: 80.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            10.0,
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
                                            ? Icon(Icons.person, size: 60.0)
                                            : null,
                                      ),

                                      const SizedBox(height: 4.0),

                                      Text(
                                        author.name,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
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
    );
  }
}
