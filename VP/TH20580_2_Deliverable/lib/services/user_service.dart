// user_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _isLoggedInKey = 'isLoggedIn';

  // Save user credentials
  static Future<void> saveCredentials(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, username);
      await prefs.setString(_passwordKey, password);
      await prefs.setBool(_isLoggedInKey, true);

      // Verify saved credentials
      final savedUsername = prefs.getString(_usernameKey);
      final savedPassword = prefs.getString(_passwordKey);
      print('Credentials saved - Username: $savedUsername, Password: $savedPassword');
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  // Get saved credentials
  static Future<Map<String, String>> getCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString(_usernameKey) ?? '';
      final password = prefs.getString(_passwordKey) ?? '';

      print('Retrieved credentials - Username: $username, Password: $password');

      return {
        'username': username,
        'password': password,
      };
    } catch (e) {
      print('Error getting credentials: $e');
      return {
        'username': '',
        'password': '',
      };
    }
  }

  // Clear credentials (for logout)
  static Future<void> clearCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      print('Logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }
}