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

  // Upload user profile image to storage
  Future<String> uploadUserProfilePhoto(Uint8List fileBytes) async {
    try {
      if (currentUser == null) {
        throw Exception('User belum login');
      }

      // Create unique filename for user
      final String fileName =
          '${currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // Define user file path
      final String filePath = 'user-profile-images/$fileName';

      // Upload file to 'assets' bucket
      await _supabaseClient.storage
          .from('assets')
          .uploadBinary(filePath, fileBytes);

      // Update user profile image (in user table)
      await _updateUserProfilePhoto(filePath);

      return filePath;
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  // Update user profile image (in user table)
  Future<void> _updateUserProfilePhoto(String filePath) async {
    try {
      await _supabaseClient.from('users').update({'image_path': filePath});
    } catch (e) {
      throw Exception('Gagal menyimpan gambar: $e');
    }
  }

  // Delete user profile image from storage
  Future<void> deleteUserProfilePhoto() async {
    try {
      if (currentUser == null) {
        throw Exception('User belum login');
      }

      final Map<String, dynamic> user = await _supabaseClient
          .from('users')
          .select('image_path')
          .eq('id', currentUser!.id)
          .single();
      final imagePath = user['image_path'];

      if (imagePath == null) {
        return;
      }

      await _supabaseClient.storage.from('assets').remove([imagePath]);
    } catch (e) {
      throw Exception('Gagal menghapus gambar: $e');
    }
  }
}
