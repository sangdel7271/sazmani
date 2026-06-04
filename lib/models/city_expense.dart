class CityExpense {
  final String id;
  final String cityId;
  final double amount;
  final String expenseType;
  final String? description;
  final DateTime expenseDate;
  final String createdBy;
  final DateTime createdAt;

  CityExpense({
    required this.id,
    required this.cityId,
    required this.amount,
    required this.expenseType,
    this.description,
    required this.expenseDate,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city_id': cityId,
      'amount': amount,
      'expense_type': expenseType,
      'description': description,
      'expense_date': expenseDate.toIso8601String(),
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CityExpense.fromMap(Map<String, dynamic> map) {
    return CityExpense(
      id: map['id'],
      cityId: map['city_id'],
      amount: (map['amount'] ?? 0).toDouble(),
      expenseType: map['expense_type'] ?? 'سایر',
      description: map['description'],
      expenseDate: DateTime.parse(map['expense_date']),
      createdBy: map['created_by'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
