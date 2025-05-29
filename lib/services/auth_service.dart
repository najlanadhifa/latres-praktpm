import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _isLoggedInKey = 'isLoggedIn';

  static Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // cek user udah ada apa blm
    final existingUsername = prefs.getString(_usernameKey);
    if (existingUsername == username) {
      return false; 
    }

    // simpen username sm password baru
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
    return true;
  }

  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // ambil data yg udah disimpen
    final savedUsername = prefs.getString(_usernameKey);
    final savedPassword = prefs.getString(_passwordKey);

    // klo cocok, set login jd true
    if (savedUsername == username && savedPassword == password) {
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // set status login jd false
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    // cek user lg login apa ngga
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    // klo lg login, ambil usernamenya
    if (isLoggedIn) {
      return prefs.getString(_usernameKey);
    }
    return null;
  }
}