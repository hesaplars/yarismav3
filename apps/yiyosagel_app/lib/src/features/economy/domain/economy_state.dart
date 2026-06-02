class EconomyState {
  const EconomyState({
    required this.balance,
    required this.storeItems,
    required this.inventory,
    required this.limits,
  });

  final int balance;
  final List<Map<String, dynamic>> storeItems;
  final List<Map<String, dynamic>> inventory;
  final Map<String, dynamic> limits;

  factory EconomyState.empty() {
    return const EconomyState(balance: 0, storeItems: [], inventory: [], limits: {});
  }

  factory EconomyState.fromJson(Map<String, dynamic> json) {
    final wallet = Map<String, dynamic>.from((json['wallet'] as Map?) ?? {});
    return EconomyState(
      balance: ((wallet['balance'] as num?) ?? 0).round(),
      storeItems: _list(json['storeItems']),
      inventory: _list(json['inventory']),
      limits: Map<String, dynamic>.from((json['limits'] as Map?) ?? {}),
    );
  }

  static List<Map<String, dynamic>> _list(Object? value) {
    if (value is List) {
      return value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }
}
