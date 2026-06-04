class Fighter {
  final String id;
  final String cityId;
  final String fullName;
  final String? fatherName;
  final bool isMartyr;
  final String maritalStatus;
  final int numberOfWives;
  final int totalChildren;
  final int childrenUnder5;
  final int children5to15;
  final int childrenAbove15;
  final int schoolChildren;
  final double houseRent;
  final String? notes;
  final bool isActive;
  final String? previousCityId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Fighter({
    required this.id,
    required this.cityId,
    required this.fullName,
    this.fatherName,
    this.isMartyr = false,
    required this.maritalStatus,
    this.numberOfWives = 0,
    this.totalChildren = 0,
    this.childrenUnder5 = 0,
    this.children5to15 = 0,
    this.childrenAbove15 = 0,
    this.schoolChildren = 0,
    this.houseRent = 0,
    this.notes,
    this.isActive = true,
    this.previousCityId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city_id': cityId,
      'full_name': fullName,
      'father_name': fatherName,
      'is_martyr': isMartyr ? 1 : 0,
      'marital_status': maritalStatus,
      'number_of_wives': numberOfWives,
      'total_children': totalChildren,
      'children_under_5': childrenUnder5,
      'children_5_to_15': children5to15,
      'children_above_15': childrenAbove15,
      'school_children': schoolChildren,
      'house_rent': houseRent,
      'notes': notes,
      'is_active': isActive ? 1 : 0,
      'previous_city_id': previousCityId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Fighter.fromMap(Map<String, dynamic> map) {
    return Fighter(
      id: map['id'],
      cityId: map['city_id'],
      fullName: map['full_name'],
      fatherName: map['father_name'],
      isMartyr: map['is_martyr'] == 1,
      maritalStatus: map['marital_status'],
      numberOfWives: map['number_of_wives'] ?? 0,
      totalChildren: map['total_children'] ?? 0,
      childrenUnder5: map['children_under_5'] ?? 0,
      children5to15: map['children_5_to_15'] ?? 0,
      childrenAbove15: map['children_above_15'] ?? 0,
      schoolChildren: map['school_children'] ?? 0,
      houseRent: (map['house_rent'] ?? 0).toDouble(),
      notes: map['notes'],
      isActive: map['is_active'] == 1,
      previousCityId: map['previous_city_id'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  String get maritalStatusDisplay {
    if (isMartyr) return 'شهید';
    return maritalStatus;
  }

  double get totalMonthlySupport {
    double support = 0;
    support += childrenUnder5 * 500;
    support += schoolChildren * 300;
    support += houseRent;
    if (isMartyr) support += 2000;
    return support;
  }
}
