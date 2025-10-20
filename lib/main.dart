import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:itsnu_app/core/router.dart';
import 'package:itsnu_app/core/auth_notifier.dart';
import 'package:itsnu_app/providers/author_provider.dart';
import 'package:itsnu_app/providers/book_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Init Supabase
  await Supabase.initialize(
    url: 'https://uadcrpkrcmcdvgxrrhiq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhZGNycGtyY21jZHZneHJyaGlxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5OTc1MDUsImV4cCI6MjA3NTU3MzUwNX0.5d_FXgTZ2uJeznSJzl3ObvehX-lclQqTuy_sM0shbUk',
  );

  runApp(const PerpusITSNU());
}

class PerpusITSNU extends StatefulWidget {
  const PerpusITSNU({super.key});

  @override
  State<PerpusITSNU> createState() => _PerpusITSNUState();
}

class _PerpusITSNUState extends State<PerpusITSNU> {
  late final AuthNotifier _authNotifier;
  late final GoRouter _router;

  // initState is for initialization of variables and objects before the app starts
  @override
  void initState() {
    super.initState();
    _authNotifier = AuthNotifier();
    _router = createRouter(
      _authNotifier,
    ); // create once, uses refreshListenable
    _restore(); // start restoreLogin asynchronously
  }

  Future<void> _restore() async {
    try {
      await _authNotifier
          .restoreLogin(); // must call notifyListeners() internally
    } catch (e, st) {
      debugPrint('restoreLogin error: $e\n$st');
    }
  }

  @override
  void dispose() {
    _authNotifier.dispose(); // must call notifyListeners() internally
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>.value(value: _authNotifier),
        ChangeNotifierProvider<AuthorProvider>(create: (_) => AuthorProvider()),
        ChangeNotifierProvider<BookProvider>(create: (_) => BookProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Perpustakaan ITSNU',
      ),
    );
  }
}
