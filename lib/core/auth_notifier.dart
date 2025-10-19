import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Save token after login
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: 'access_token', value: token);
      _isLoggedIn = true;
      notifyListeners(); // Notify listeners is used for updating the UI
    } catch (e) {
      throw Exception('Gagal menyimpan token: $e');
    }
  }

  // Read token from local storage
  Future<void> restoreLogin() async {
    try {
      final String? token = await _secureStorage.read(key: 'access_token');
      _isLoggedIn = token != null; // Check if token is not null
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal membaca token: $e');
    }
  }

  // Clear token on logout
  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: 'access_token');
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menghapus token: $e');
    }
  }
}
