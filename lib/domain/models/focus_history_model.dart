import 'daily_snapshot_model.dart';

class FocusHistoryModel {
  // Key: 'yyyy-MM-dd', Value: focus duration in minutes (legacy/simple record)
  final Map<String, int> dailyRecords;
  
  // Key: 'yyyy-MM-dd', Value: detailed snapshot for the day
  final Map<String, DailySnapshotModel> dailySnapshots;

  FocusHistoryModel({
    Map<String, int>? dailyRecords,
    Map<String, DailySnapshotModel>? dailySnapshots,
  }) : dailyRecords = dailyRecords ?? {},
       dailySnapshots = dailySnapshots ?? {};

  FocusHistoryModel copyWith({
    Map<String, int>? dailyRecords,
    Map<String, DailySnapshotModel>? dailySnapshots,
  }) {
    return FocusHistoryModel(
      dailyRecords: dailyRecords ?? this.dailyRecords,
      dailySnapshots: dailySnapshots ?? this.dailySnapshots,
    );
  }

  factory FocusHistoryModel.fromJson(Map<String, dynamic> json) {
    final records = json['dailyRecords'] as Map<String, dynamic>? ?? {};
    final snapshotsJson = json['dailySnapshots'] as Map<String, dynamic>? ?? {};
    
    final snapshots = snapshotsJson.map((key, value) {
      return MapEntry(key, DailySnapshotModel.fromJson(value as Map<String, dynamic>));
    });

    return FocusHistoryModel(
      dailyRecords: records.map((key, value) => MapEntry(key, value as int)),
      dailySnapshots: snapshots,
    );
  }

  Map<String, dynamic> toJson() {
    final snapshotsJson = dailySnapshots.map((key, value) => MapEntry(key, value.toJson()));
    return {
      'dailyRecords': dailyRecords,
      'dailySnapshots': snapshotsJson,
    };
  }

}
