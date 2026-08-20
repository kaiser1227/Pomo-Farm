class DailySnapshotModel {
  final String date;
  final int focusMinutes;
  final int streakDays;
  final int harvestCount;

  DailySnapshotModel({
    required this.date,
    this.focusMinutes = 0,
    this.streakDays = 0,
    this.harvestCount = 0,
  });

  DailySnapshotModel copyWith({
    String? date,
    int? focusMinutes,
    int? streakDays,
    int? harvestCount,
  }) {
    return DailySnapshotModel(
      date: date ?? this.date,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      streakDays: streakDays ?? this.streakDays,
      harvestCount: harvestCount ?? this.harvestCount,
    );
  }

  factory DailySnapshotModel.fromJson(Map<String, dynamic> json) {
    return DailySnapshotModel(
      date: json['date'] as String,
      focusMinutes: json['focusMinutes'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      harvestCount: json['harvestCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'focusMinutes': focusMinutes,
      'streakDays': streakDays,
      'harvestCount': harvestCount,
    };
  }
}
