import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  String? _message;

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
      throw Exception('Form tidak valid');
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _message = null;
    });

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      if (!_isLogin) {
        await _supabaseUserService.register(email, password);

        if (!mounted) return;
        setState(() {
          _message =
              'Silakan cek email Anda dan konfirmasi akun sebelum login.';
        });
        // Navigate to login screen
        GoRouter.of(context).go('/auth');
        return; // Stop the function (preventing calling logIn())
      }

      await _supabaseUserService.logIn(email, password);

      // Check if widget isn't mounted then return null
      // Ensures navigation only happens if the widget is still exists after the async
      if (!mounted) return;

      // Navigate to home screen
      GoRouter.of(context).go('/');
    } catch (e) {
      // if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                    'PERPUS ITSNU',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  Text(
                    _isLogin ? 'Masuk ke akun anda' : 'Daftar akun baru',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 32.0),

                  // Email field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        labelText: 'Email',
                        labelStyle: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        errorStyle: Theme.of(context).textTheme.labelSmall!
                            .copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.errorContainer,
                            ),
                        // Default border
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        // Focused border
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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

                  // Password field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        labelText: 'Kata Sandi',
                        labelStyle: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        errorStyle: Theme.of(context).textTheme.labelSmall!
                            .copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.errorContainer,
                            ),
                        // Default border
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        // Focused border
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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
                  if (_message != null)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _message!,
                        style: TextStyle(color: Colors.green.shade900),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Error message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: SizedBox(
                      height: 48.0,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0, // Set the stroke width here
                                  valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              )
                            : Text(
                                _isLogin ? 'Masuk' : 'Daftar',
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Toggle login/register
                  TextButton(
                    onPressed: _isLoading ? null : _toggleMode,
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text(
                      _isLogin
                          ? 'Belum punya akun? Daftar di sini.'
                          : 'Sudah punya akun? Masuk di sini.',
                      selectionColor: Theme.of(context).colorScheme.primary,
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
