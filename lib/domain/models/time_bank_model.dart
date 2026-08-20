class TimeBankModel {
  final int totalSavedMinutes;
  final int money;

  TimeBankModel({
    this.totalSavedMinutes = 0,
    this.money = 0,
  });

  TimeBankModel copyWith({
    int? totalSavedMinutes,
    int? money,
  }) {
    return TimeBankModel(
      totalSavedMinutes: totalSavedMinutes ?? this.totalSavedMinutes,
      money: money ?? this.money,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSavedMinutes': totalSavedMinutes,
      'money': money,
    };
  }

  factory TimeBankModel.fromJson(Map<String, dynamic> json) {
    return TimeBankModel(
      totalSavedMinutes: json['totalSavedMinutes'] ?? 0,
      // fallback for old users: calculate money from saved minutes if money is not set
      money: json['money'] ?? ((json['totalSavedMinutes'] ?? 0) * 100),
    );
  }
}
