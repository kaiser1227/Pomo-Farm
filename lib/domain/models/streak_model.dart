class StreakModel {
  final int currentStreakDays;
  final int longestStreakDays;
  final Map<String, bool> historyMap; // 'YYYY-MM-DD' -> true(success), false(failed)

  StreakModel({
    this.currentStreakDays = 0,
    this.longestStreakDays = 0,
    this.historyMap = const {},
  });

  StreakModel copyWith({
    int? currentStreakDays,
    int? longestStreakDays,
    Map<String, bool>? historyMap,
  }) {
    return StreakModel(
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      historyMap: historyMap ?? this.historyMap,
    );
  }

  // Helper method for JSON serialization if needed later
  Map<String, dynamic> toJson() {
    return {
      'currentStreakDays': currentStreakDays,
      'longestStreakDays': longestStreakDays,
      'historyMap': historyMap,
    };
  }

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      currentStreakDays: json['currentStreakDays'] ?? 0,
      longestStreakDays: json['longestStreakDays'] ?? 0,
      historyMap: Map<String, bool>.from(json['historyMap'] ?? {}),
    );
  }
}
