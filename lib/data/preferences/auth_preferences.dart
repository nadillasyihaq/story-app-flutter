import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  final String stateKey = "AUTH_STATE";
  final String tokenKey = "USER_TOKEN";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(stateKey, false);
  }

  Future<bool> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(tokenKey, token);
  }

  Future<bool> deleteToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(tokenKey, '');
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) ?? '';
  }
}
