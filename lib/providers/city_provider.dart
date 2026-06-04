import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/city.dart';

class CityProvider extends ChangeNotifier {
  List<City> _cities = [];
  bool _isLoading = false;
  String? _error;

  List<City> get cities => _cities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCities() async {
    _isLoading = true;
    notifyListeners();
    try {
      final db = await DatabaseHelper.instance.database;
      final data = await db.query('cities', orderBy: 'name ASC');
      _cities = data.map((map) => City.fromMap(map)).toList();
      _error = null;
    } catch (e) {
      _error = 'خطا در بارگذاری شهرها';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addCity(String name, {String? description}) async {
    try {
      final city = City(
        id: const Uuid().v4(),
        name: name.trim(),
        description: description?.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final db = await DatabaseHelper.instance.database;
      await db.insert('cities', city.toMap());
      await loadCities();
      return true;
    } catch (e) {
      _error = 'خطا در افزودن شهر';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCity(String id, String name, {String? description}) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update('cities', {
        'name': name.trim(),
        'description': description?.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      }, where: 'id = ?', whereArgs: [id]);
      await loadCities();
      return true;
    } catch (e) {
      _error = 'خطا در ویرایش شهر';
      notifyListeners();
      return false;
    }
  }

  Future<void> archiveCity(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update('cities', {
        'is_active': 0,
        'updated_at': DateTime.now().toIso8601String(),
      }, where: 'id = ?', whereArgs: [id]);
      await loadCities();
    } catch (e) {
      _error = 'خطا در بایگانی شهر';
      notifyListeners();
    }
  }
}
