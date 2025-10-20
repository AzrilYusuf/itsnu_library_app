import 'dart:typed_data'; // for Uint8List
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itsnu_app/core/auth_notifier.dart';

class SupabaseUserService {
  /*
  code: static final SupabaseUserService _instance = SupabaseUserService._internal();
  * Create a single, shared instance of SupabaseUserService
  * _internal is a private constructor. Prevents external code from creating multiple instances directly.
  code: factory SupabaseUserService() => _instance;
  * Any call to SupabaseUserService() will return the same instance
  * Ensures only one instance exists accross the app
  */
  static final SupabaseUserService _instance = SupabaseUserService._internal();
  factory SupabaseUserService() => _instance;
  SupabaseUserService._internal();

  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthNotifier _authNotifier = AuthNotifier();

  // Getter
  SupabaseClient get supabaseClient => _supabaseClient;
  User? get currentUser => _supabaseClient.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  Map<String, dynamic>? get currentUserMetaData => currentUser!.userMetadata;

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

  // Log in/Sign in user using email and password
  Future<AuthResponse> logIn(String email, String password) async {
    try {
      final AuthResponse response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      final String? token = response.session?.accessToken;

      await _authNotifier.saveToken(token!);
      return response;
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }

  Future<void> logOut() async {
    try {
      await _authNotifier.clearToken();
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      if (currentUser == null) {
        throw Exception('User belum login');
      }

      await _supabaseClient.auth.updateUser(
        UserAttributes(
          data: {
            ...?currentUserMetaData,
            // Preventing empty strings from overwriting existing data
            if (data['name']?.trim().isNotEmpty ?? false) 'name': data['name'],
            if (data['phone']?.trim().isNotEmpty ?? false)
              'phone': data['phone'],
            if (data['address']?.trim().isNotEmpty ?? false)
              'address': data['address'],
          },
        ),
      );
    } catch (e) {
      throw Exception('Gagal update data: $e');
    }
  }

  Future<void> updateUserPassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (currentUser == null) {
        throw Exception('User belum login');
      }
      if (currentUser?.email == null) {
        throw Exception('User belum login');
      }

      /* 
        Check if current password is correct using signInWithPassword
        Because updateUser doesn't require current password and 
        supabase doesn't have a way to check if current password is correct
      */
      final AuthResponse res = await _supabaseClient.auth.signInWithPassword(
        email: currentUser?.email,
        password: currentPassword,
      );

      // Check if session is null
      if (res.session == null) {
        throw Exception('Password lama salah');
      }

      // Update password after checking if current password is correct
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception('Gagal update password: $e');
    }
  }

  // Upload user profile image to storage
  Future<void> uploadUserProfilePhoto(Uint8List fileBytes) async {
    try {
      if (currentUser == null) {
        throw Exception('User belum login');
      }

        // If image exists, Delete existing image
      if (currentUserMetaData!['image_url'] != null) {
        await deleteUserProfilePhoto();
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

      // Get file URL
      final String fileUrl = _supabaseClient.storage
          .from('assets')
          .getPublicUrl(filePath);

      // Update user profile image (in user table)
      await _updateUserProfilePhoto(fileUrl);
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  // Update user profile image (in user table)
  Future<void> _updateUserProfilePhoto(String fileUrl) async {
    try {
      if (currentUser == null) {
        throw Exception('User belum login');
      }

      await _supabaseClient.auth.updateUser(
        UserAttributes(data: {...?currentUserMetaData, 'image_url': fileUrl}),
      );
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

      if (currentUserMetaData!['image_url'] == null) {
        throw Exception('Tidak ada gambar untuk dihapus');
      }

      // Get user profile image url
      final String imageUrl = currentUserMetaData!['imageUrl'];
      final String filePath = imageUrl.split('/assets/').last;

      // Delete image from storage
      await _supabaseClient.storage.from('assets').remove([filePath]);

      await _supabaseClient.auth.updateUser(
        UserAttributes(data: {...?currentUserMetaData, 'image_url': null}),
      );
    } catch (e) {
      throw Exception('Gagal menghapus gambar: $e');
    }
  }
}
