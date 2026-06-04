class Payment {
  final String id;
  final String fighterId;
  final double totalSalary;
  final double paidAmount;
  final double debtDeducted;
  final double remainingDebt;
  final DateTime paymentDate;
  final int month;
  final int year;
  final String? notes;
  final String createdBy;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.fighterId,
    required this.totalSalary,
    required this.paidAmount,
    this.debtDeducted = 0,
    this.remainingDebt = 0,
    required this.paymentDate,
    required this.month,
    required this.year,
    this.notes,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fighter_id': fighterId,
      'total_salary': totalSalary,
      'paid_amount': paidAmount,
      'debt_deducted': debtDeducted,
      'remaining_debt': remainingDebt,
      'payment_date': paymentDate.toIso8601String(),
      'month': month,
      'year': year,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      fighterId: map['fighter_id'],
      totalSalary: (map['total_salary'] ?? 0).toDouble(),
      paidAmount: (map['paid_amount'] ?? 0).toDouble(),
      debtDeducted: (map['debt_deducted'] ?? 0).toDouble(),
      remainingDebt: (map['remaining_debt'] ?? 0).toDouble(),
      paymentDate: DateTime.parse(map['payment_date']),
      month: map['month'] ?? DateTime.now().month,
      year: map['year'] ?? DateTime.now().year,
      notes: map['notes'],
      createdBy: map['created_by'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
