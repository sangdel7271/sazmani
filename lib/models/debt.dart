class Debt {
  final String id;
  final String fighterId;
  final double amount;
  final double remainingAmount;
  final String? description;
  final DateTime debtDate;
  final bool isPaid;
  final DateTime createdAt;

  Debt({
    required this.id,
    required this.fighterId,
    required this.amount,
    required this.remainingAmount,
    this.description,
    required this.debtDate,
    this.isPaid = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fighter_id': fighterId,
      'amount': amount,
      'remaining_amount': remainingAmount,
      'description': description,
      'debt_date': debtDate.toIso8601String(),
      'is_paid': isPaid ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
      id: map['id'],
      fighterId: map['fighter_id'],
      amount: (map['amount'] ?? 0).toDouble(),
      remainingAmount: (map['remaining_amount'] ?? 0).toDouble(),
      description: map['description'],
      debtDate: DateTime.parse(map['debt_date']),
      isPaid: map['is_paid'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
