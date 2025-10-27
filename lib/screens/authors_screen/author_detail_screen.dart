import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsnu_app/models/author_model.dart';
import 'package:itsnu_app/models/book_model.dart';
import 'package:itsnu_app/providers/book_provider.dart';
import 'package:provider/provider.dart';

class AuthorDetailScreen extends StatefulWidget {
  final AuthorModel author;

  const AuthorDetailScreen({super.key, required this.author});

  @override
  State<AuthorDetailScreen> createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BookProvider bookProvider = Provider.of<BookProvider>(context);
    // Filter books by author
    final List<BookModel> filteredBooks = bookProvider.books
        .where((b) => b.authorId == widget.author.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Detail Penulis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70.0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: widget.author.imageUrl != null
                  ? NetworkImage(widget.author.imageUrl!)
                  : null,
              child: widget.author.imageUrl == null
                  ? Icon(
                      Icons.person,
                      size: 60.0,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : null,
            ),

            const SizedBox(height: 12.0),

            Text(
              widget.author.name,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            const SizedBox(height: 16.0),

            Column(
              children: [
                Text(
                  'Buku:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                const SizedBox(height: 8.0),

                if (bookProvider.isLoading) ...[
                  Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ] else if (bookProvider.hasError) ...[
                  Center(child: Text('Error: ${bookProvider.errorMessage}')),
                ] else ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final BookModel book = filteredBooks[index];
                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go('/books/detail', extra: book);
                        },
                        // Book Card
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
                              // Book Cover
                              Container(
                                height: 90.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12.0),
                                  image: book.imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(book.imageUrl!),
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

                              // Book Title
                              Text(
                                book.title,
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
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
