import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  String? get error => _error;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;
      final users = await db.query('users',
          where: 'username = ? AND password = ? AND is_active = 1',
          whereArgs: [username.trim(), password]);

      if (users.isNotEmpty) {
        _currentUser = User.fromMap(users.first);
        await db.update('users',
            {'last_login': DateTime.now().toIso8601String()},
            where: 'id = ?', whereArgs: [_currentUser!.id]);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'نام کاربری یا رمز عبور اشتباه است';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'خطا در اتصال به پایگاه داده';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser == null) return false;
    try {
      final db = await DatabaseHelper.instance.database;
      if (_currentUser!.password != oldPassword) {
        _error = 'رمز عبور فعلی اشتباه است';
        notifyListeners();
        return false;
      }
      await db.update('users', {'password': newPassword},
          where: 'id = ?', whereArgs: [_currentUser!.id]);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'خطا در تغییر رمز عبور';
      notifyListeners();
      return false;
    }
  }
}
