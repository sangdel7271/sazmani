import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/fighter.dart';

class FighterProvider extends ChangeNotifier {
  List<Fighter> _fighters = [];
  List<Fighter> _archivedFighters = [];
  bool _isLoading = false;
  String? _error;

  List<Fighter> get fighters => _fighters;
  List<Fighter> get archivedFighters => _archivedFighters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFighters(String cityId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final db = await DatabaseHelper.instance.database;
      final activeData = await db.query('fighters',
          where: 'city_id = ? AND is_active = 1',
          whereArgs: [cityId],
          orderBy: 'full_name ASC');
      _fighters = activeData.map((map) => Fighter.fromMap(map)).toList();

      final archivedData = await db.query('fighters',
          where: 'city_id = ? AND is_active = 0',
          whereArgs: [cityId],
          orderBy: 'full_name ASC');
      _archivedFighters =
          archivedData.map((map) => Fighter.fromMap(map)).toList();
      _error = null;
    } catch (e) {
      _error = 'خطا در بارگذاری مبارزین';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addFighter({
    required String cityId,
    required String fullName,
    String? fatherName,
    required String maritalStatus,
    int numberOfWives = 0,
    int totalChildren = 0,
    int childrenUnder5 = 0,
    int children5to15 = 0,
    int childrenAbove15 = 0,
    int schoolChildren = 0,
    double houseRent = 0,
    String? notes,
    bool isMartyr = false,
  }) async {
    try {
      final fighter = Fighter(
        id: const Uuid().v4(),
        cityId: cityId,
        fullName: fullName.trim(),
        fatherName: fatherName?.trim(),
        maritalStatus: maritalStatus,
        numberOfWives: numberOfWives,
        totalChildren: totalChildren,
        childrenUnder5: childrenUnder5,
        children5to15: children5to15,
        childrenAbove15: childrenAbove15,
        schoolChildren: schoolChildren,
        houseRent: houseRent,
        notes: notes?.trim(),
        isMartyr: isMartyr,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final db = await DatabaseHelper.instance.database;
      await db.insert('fighters', fighter.toMap());
      await loadFighters(cityId);
      return true;
    } catch (e) {
      _error = 'خطا در افزودن مبارز';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFighter(Fighter fighter) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update('fighters', {
        ...fighter.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      }, where: 'id = ?', whereArgs: [fighter.id]);
      await loadFighters(fighter.cityId);
      return true;
    } catch (e) {
      _error = 'خطا در ویرایش مبارز';
      notifyListeners();
      return false;
    }
  }

  Future<void> archiveFighter(String fighterId, String cityId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update('fighters', {
        'is_active': 0,
        'updated_at': DateTime.now().toIso8601String(),
      }, where: 'id = ?', whereArgs: [fighterId]);
      await loadFighters(cityId);
    } catch (e) {
      _error = 'خطا در بایگانی مبارز';
      notifyListeners();
    }
  }

  Future<bool> transferFighter(String fighterId, String newCityId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update('fighters', {
        'previous_city_id':
            fighters.firstWhere((f) => f.id == fighterId).cityId,
        'city_id': newCityId,
        'updated_at': DateTime.now().toIso8601String(),
      }, where: 'id = ?', whereArgs: [fighterId]);
      return true;
    } catch (e) {
      _error = 'خطا در انتقال مبارز';
      notifyListeners();
      return false;
    }
  }

  Future<double> getTotalDebt(String fighterId) async {
    return await DatabaseHelper.instance.getTotalDebtForFighter(fighterId);
  }
}
