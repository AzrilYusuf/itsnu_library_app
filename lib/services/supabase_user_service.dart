import 'dart:typed_data'; // for Uint8List
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUserService {
  /*
  code: static final SupabaseService _instance = SupabaseService._internal();
  * Create a single, shared instance of SupabaseService
  * _internal is a private constructor. Prevents external code from creating multiple instances directly.
  code: factory SupabaseService() => _instance;
  * Any call to SupabaseService() will return the same instance
  * Ensures only one instance exists accross the app
  */
  // Create a single, shared instance of SupabaseService
  static final SupabaseUserService _instance = SupabaseUserService._internal();
  factory SupabaseUserService() => _instance;
  SupabaseUserService._internal();

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Getter
  SupabaseClient get supabaseClient => _supabaseClient;
  User? get currentUser => _supabaseClient.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // Register/Sign up user using email and password
  Future<AuthResponse> register(String email, String password) async {
    try {
      return await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Gagal mendaftarkan akun: $e');
    }
  }

  // Login/Sign in user using email and password
  Future<AuthResponse> login(String email, String password) async {
    try {
      return await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }
}
