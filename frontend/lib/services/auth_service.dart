import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  final ApiService apiService;
  final SharedPreferences prefs;
  
  User? _currentUser;
  bool _isAuthenticated = false;

  AuthService({required this.apiService, required this.prefs}) {
    _loadSession();
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> _loadSession() async {
    final token = prefs.getString('auth_token');
    if (token != null) {
      apiService.setToken(token);
      try {
        final response = await apiService.getCurrentUser();
        _currentUser = User.fromJson(response['user']);
        _isAuthenticated = true;
        notifyListeners();
      } catch (e) {
        // Token is invalid, clear it
        await _clearSession();
      }
    }
  }

  Future<void> register(String username, String password) async {
    final response = await apiService.register(username, password);
    final token = response['token'] as String;
    _currentUser = User.fromJson(response['user']);
    _isAuthenticated = true;
    
    await prefs.setString('auth_token', token);
    apiService.setToken(token);
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    final response = await apiService.login(username, password);
    final token = response['token'] as String;
    _currentUser = User.fromJson(response['user']);
    _isAuthenticated = true;
    
    await prefs.setString('auth_token', token);
    apiService.setToken(token);
    notifyListeners();
  }

  Future<void> logout() async {
    await apiService.logout();
    await _clearSession();
  }

  Future<void> _clearSession() async {
    await prefs.remove('auth_token');
    apiService.setToken(null);
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

