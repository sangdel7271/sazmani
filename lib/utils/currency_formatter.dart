class CurrencyFormatter {
  static String format(double amount) {
    if (amount == 0) return '۰ روپیه';
    final parts = amount.toStringAsFixed(0).split('');
    final formatted = <String>[];
    for (var i = parts.length - 1; i >= 0; i--) {
      formatted.insert(0, parts[i]);
      if ((parts.length - i) % 3 == 0 && i != 0) {
        formatted.insert(0, ',');
      }
    }
    return '${formatted.join()} روپیه';
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
