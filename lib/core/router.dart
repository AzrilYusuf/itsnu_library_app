import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsnu_app/core/auth_notifier.dart';
import 'package:itsnu_app/models/author_model.dart';
import 'package:itsnu_app/models/book_model.dart';
import 'package:itsnu_app/screens/auth_screen/auth_screen.dart';
import 'package:itsnu_app/screens/authors_screen/author_detail_screen.dart';
import 'package:itsnu_app/screens/authors_screen/author_form_screen.dart';
import 'package:itsnu_app/screens/authors_screen/authors_screen.dart';
import 'package:itsnu_app/screens/books_screen/book_detail_screen.dart';
import 'package:itsnu_app/screens/books_screen/book_form_screen.dart';
import 'package:itsnu_app/screens/books_screen/books_screen.dart';
import 'package:itsnu_app/screens/category_screen/category_screen.dart';
import 'package:itsnu_app/screens/home_screen/home_screen.dart';
import 'package:itsnu_app/screens/profile_screen/edit_profile_screen.dart';
import 'package:itsnu_app/screens/profile_screen/profile_screen.dart';
import 'package:itsnu_app/screens/splash_screen/splash_screen.dart';

GoRouter createRouter(AuthNotifier authNotifier) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable:
        authNotifier, // Router will re-evaluate redirects when auth changes
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),

      // Bottom nav shell with per-tab stack preservation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (i) => navigationShell.goBranch(i),
              selectedItemColor: Colors.teal,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.grey[200],
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_note),
                  label: 'Penulis',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Buku'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Kategori',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          );
        },
        branches: [
          // Home branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Authors branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/authors',
                name: 'authors',
                builder: (context, state) => const AuthorsScreen(),
                routes: [
                  GoRoute(
                    path: '/form',
                    name: 'authorForm',
                    builder: (context, state) {
                      final author = state.extra as AuthorModel?;
                      return AuthorFormScreen(author: author);
                    },
                  ),
                  GoRoute(
                    path: '/detail',
                    name: 'authorDetail',
                    builder: (context, state) {
                      final author = state.extra as AuthorModel;
                      return AuthorDetailScreen(author: author);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Books branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/books',
                name: 'books',
                builder: (context, state) => const BooksScreen(),

                routes: [
                  GoRoute(
                    path: '/form',
                    name: 'bookForm',
                    builder: (context, state) {
                      final book =
                          state.extra
                              as BookModel?; // add ? cause BookModel in book_form_screen can be null
                      return BookFormScreen(book: book);
                    },
                  ),
                  GoRoute(
                    path: '/detail',
                    name: 'bookDetail',
                    builder: (context, state) {
                      final book = state.extra as BookModel;
                      return BookDetailScreen(book: book);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Category branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/category',
                name: 'category',
                builder: (context, state) => const CategoryScreen(),
              ),
            ],
          ),

          // Profile branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: '/edit',
                    name: 'edit',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],

    // Global redirect logic
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authNotifier.isLoggedIn;
      final bool loggingIn = state.path == '/auth' || state.path == '/splash';
      final String path = state.uri.path;
      // If not logged and trying to access protected tabs (profile)
      if (!loggedIn && path.startsWith('/profile')) return '/auth';

      // After splash finished, if logged in go to / else to /auth
      // Let SplashScreen decide to go to / or /auth
      if (path == '/splash') return null;

      // If already logged in and at /auth, send to /
      if (loggingIn && path == '/auth') return '/';

      return null;
    },
  );
}
