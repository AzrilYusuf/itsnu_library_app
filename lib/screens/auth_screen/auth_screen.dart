import 'package:flutter/material.dart';
import 'package:itsnu_app/main.dart';
import 'package:itsnu_app/services/supabase_user_service.dart';
import 'package:itsnu_app/widgets/app_logo.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SupabaseUserService _supabaseUserService = SupabaseUserService();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Form key is used to validate the form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true; // Used to toggle between login and signup
  bool _isLoading = false;
  String? _errorMessage;

  // Dispose controllers when the widget is disposed
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Validate the form, if invalid, return
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      if (_isLogin) {
        await _supabaseUserService.logIn(email, password);
      } else {
        await _supabaseUserService.register(email, password);
      }

      // Check if widget isn't mounted then return null
      // Ensures navigation only happens if the widget is still exists after the async
      if (!mounted) return;
      
      // Navigate to home screen
      //* NOTE: Navigator.pushReplacement replaces the current screen (login/register) with the home screen
      //* const HomeScreen() should be the main/home widget
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              // key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  AppLogo(
                    size: 60,
                    showBackground: false,
                    useColorFilter: false,
                  ),

                  const SizedBox(height: 10.0),

                  // Title
                  Text(
                    "PERPUSITSNU",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  Text(
                    _isLogin ? 'Masuk' : 'Daftar',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900],
                    ),
                  ),

                  const SizedBox(height: 32.0),

                  // Email field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tolong isi email anda';
                        }

                        if (!value.contains('@')) {
                          return 'Email tidak valid';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Kata Sandi',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tolong isi kata sandi anda';
                        }

                        if (value.length < 6) {
                          return 'Kata sandi minimal 6 karakter';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Error message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade900),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Submit button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0, // Set the stroke width here
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _isLogin ? 'Masuk' : 'Daftar',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Toggle login/register
                  TextButton(
                    onPressed: _isLoading ? null : _toggleMode,
                    child: Text(
                      _isLogin
                          ? 'Belum punya akun? Daftar di sini.'
                          : 'Sudah punya akun? Masuk di sini.',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
