import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get userRole => _currentUser?.role ?? '';

  // Mock authentication for UI demonstration
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock users for demonstration
    if (email == 'admin@softleticspro.com' && password == 'admin123') {
      _currentUser = User(
        id: '1',
        name: 'Admin User',
        email: email,
        role: 'admin',
        status: 'active',
        createdAt: DateTime.now(),
        department: 'Management',
      );
      _isAuthenticated = true;
    } else if (email == 'pm@softleticspro.com' && password == 'pm123') {
      _currentUser = User(
        id: '2',
        name: 'Project Manager',
        email: email,
        role: 'project_manager',
        status: 'active',
        createdAt: DateTime.now(),
        department: 'Development',
      );
      _isAuthenticated = true;
    } else if (email == 'employee@softleticspro.com' && password == 'emp123') {
      _currentUser = User(
        id: '3',
        name: 'John Employee',
        email: email,
        role: 'employee',
        status: 'active',
        createdAt: DateTime.now(),
        department: 'Development',
      );
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
    return _isAuthenticated;
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock registration success
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      role: role,
      status: 'active',
      createdAt: DateTime.now(),
    );
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser != null) {
      // Update user data
      _currentUser = User(
        id: _currentUser!.id,
        name: data['name'] ?? _currentUser!.name,
        email: data['email'] ?? _currentUser!.email,
        role: _currentUser!.role,
        status: _currentUser!.status,
        createdAt: _currentUser!.createdAt,
        avatar: data['avatar'] ?? _currentUser!.avatar,
        phone: data['phone'] ?? _currentUser!.phone,
        department: data['department'] ?? _currentUser!.department,
      );
      notifyListeners();
    }
  }
}
