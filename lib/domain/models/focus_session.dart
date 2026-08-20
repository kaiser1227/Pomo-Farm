class FocusSession {
  final int targetMinutes;
  final int elapsedSeconds;
  final bool isCompleted;
  final bool isFailed;

  FocusSession({
    this.targetMinutes = 25,
    this.elapsedSeconds = 0,
    this.isCompleted = false,
    this.isFailed = false,
  });

  FocusSession copyWith({
    int? targetMinutes,
    int? elapsedSeconds,
    bool? isCompleted,
    bool? isFailed,
  }) {
    return FocusSession(
      targetMinutes: targetMinutes ?? this.targetMinutes,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}
