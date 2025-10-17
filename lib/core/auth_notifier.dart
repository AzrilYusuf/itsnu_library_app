import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Save token after login
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
    _isLoggedIn = true;
    notifyListeners(); // Notify listeners is used for updating the UI
  }

  // Read token from local storage
  Future<void> restoreLogin() async {
    final String? token = await _secureStorage.read(key: 'access_token');
    _isLoggedIn = token != null; // Check if token is not null
    notifyListeners();
  }

  // Clear token on logout
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'access_token');
    _isLoggedIn = false;
    notifyListeners();
  }
}
