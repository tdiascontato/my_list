import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _loggedInUserEmail;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String? get loggedInUserEmail => _loggedInUserEmail;
  String? get errorMessage => _errorMessage;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _errorMessage = null;
    try {
      final success = await AuthService.login(email: email, password: password);
      if (success) {
        _isAuthenticated = true;
        _loggedInUserEmail = email;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Erro de servidor: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    _errorMessage = null;
    try {
      final success =
          await AuthService.register(email: email, password: password);
      return success;
    } catch (e) {
      _errorMessage = 'Erro de servidor: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _loggedInUserEmail = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
