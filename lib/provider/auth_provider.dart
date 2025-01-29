import 'package:flutter/material.dart';
import 'package:story_app_flutter/data/api/api_service.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter/data/model/login_response.dart';
import 'package:story_app_flutter/data/model/register_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthPreferences authRepository;
  final ApiService apiService;

  AuthProvider(this.authRepository, this.apiService);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  bool _isRegistered = false;

  LoginResponse? loginResponse;
  RegisterResponse? _registerResponse;

  bool get isRegistered => _isRegistered;
  RegisterResponse? get registerResponse => _registerResponse;

  String _message = "";
  String get message => _message;

  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      loginResponse = await apiService.userLogin(email, password);
      if (loginResponse != null) {
        final userToken = loginResponse!.loginResult.token;

        await authRepository.saveToken(userToken);
        await authRepository.login();
      }

      _message = loginResponse!.message;
      notifyListeners();

      isLoadingLogin = false;
      notifyListeners();
    } catch (e) {
      _message = "Error: $e";

      isLoadingLogin = false;
      notifyListeners();
    }

    isLoggedIn = await authRepository.isLoggedIn();

    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteToken();
    }
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }

  Future<bool> userRegister(
    String name,
    String email,
    String password,
  ) async {
    _message = "";
    isLoadingRegister = true;
    notifyListeners();

    try {
      _registerResponse = await apiService.userRegister(name, email, password);
      
      _isRegistered = (_registerResponse!.error == false) ? true : false;

      _message = registerResponse?.message ?? "Success";
      isLoadingRegister = false;
      notifyListeners();
    } catch (e) {
      _isRegistered = false;
      _message = "Error: $e";
      isLoadingRegister = false;
      notifyListeners();
    }

    return isRegistered;
  }
}
