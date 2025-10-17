import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsnu_app/core/auth_notifier.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final AuthNotifier auth = Provider.of<AuthNotifier>(context, listen: false);
    await auth.restoreLogin();
    if (auth.isLoggedIn) {
      if (!mounted) return;
      GoRouter.of(context).go('/home');
    } else {
      if (!mounted) return;
      GoRouter.of(context).go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
