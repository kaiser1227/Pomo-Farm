import '../../domain/models/streak_model.dart';
import '../../domain/models/time_bank_model.dart';
import '../../domain/models/focus_history_model.dart';
import '../../domain/models/tomato_farm_model.dart';
import '../../domain/models/daily_snapshot_model.dart';
import '../local/local_storage_service.dart';

class FocusPactRepository {
  final LocalStorageService _localStorage;

  FocusPactRepository(this._localStorage);

  // --- Streak Methods ---
  StreakModel getStreak() {
    return _localStorage.getStreak();
  }

  Future<void> updateStreak(StreakModel streak) async {
    await _localStorage.saveStreak(streak);
  }

  Future<void> incrementStreak() async {
    final streak = getStreak();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0];
    
    if (streak.historyMap[today] == true) {
      return; // Already completed a session today
    }

    final updatedHistory = Map<String, bool>.from(streak.historyMap);
    updatedHistory[today] = true;

    int newCurrent = 1;
    if (streak.historyMap[yesterday] == true) {
      newCurrent = streak.currentStreakDays + 1;
    }

    final newLongest = newCurrent > streak.longestStreakDays ? newCurrent : streak.longestStreakDays;

    final updated = streak.copyWith(
      currentStreakDays: newCurrent,
      longestStreakDays: newLongest,
      historyMap: updatedHistory,
    );

    await updateStreak(updated);
    await _updateDailySnapshot();
  }

  Future<void> resetStreak() async {
    final streak = getStreak();
    
    // Mark today as failed
    final today = DateTime.now().toIso8601String().split('T')[0];
    final updatedHistory = Map<String, bool>.from(streak.historyMap);
    updatedHistory[today] = false;

    final updated = streak.copyWith(
      currentStreakDays: 0,
      historyMap: updatedHistory,
    );

    await updateStreak(updated);
    await _updateDailySnapshot();
  }

  // --- Time Bank Methods ---
  TimeBankModel getTimeBank() {
    return _localStorage.getTimeBank();
  }

  Future<void> updateTimeBank(TimeBankModel timeBank) async {
    await _localStorage.saveTimeBank(timeBank);
  }

  Future<void> addSavedTime(int minutes) async {
    final tb = getTimeBank();

    final updated = tb.copyWith(
      totalSavedMinutes: tb.totalSavedMinutes + minutes,
    );
    await updateTimeBank(updated);
  }

  Future<void> addMoney(int amount) async {
    final tb = getTimeBank();
    final updated = tb.copyWith(
      money: tb.money + amount,
    );
    await updateTimeBank(updated);
  }

  Future<void> deductPenaltyTime(int penaltyMinutes) async {
    final tb = getTimeBank();
    int newTotal = tb.totalSavedMinutes - penaltyMinutes;
    if (newTotal < 0) newTotal = 0;

    final updated = tb.copyWith(
      totalSavedMinutes: newTotal,
    );
    await updateTimeBank(updated);
  }

  Future<void> deductMoney(int amount) async {
    final tb = getTimeBank();
    int newMoney = tb.money - amount;
    if (newMoney < 0) newMoney = 0;

    final updated = tb.copyWith(
      money: newMoney,
    );
    await updateTimeBank(updated);
  }

  // --- Focus History Methods ---
  FocusHistoryModel getFocusHistory() {
    return _localStorage.getFocusHistory();
  }

  Future<void> addFocusTime(int minutes) async {
    final history = getFocusHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final updatedRecords = Map<String, int>.from(history.dailyRecords);
    updatedRecords[today] = (updatedRecords[today] ?? 0) + minutes;

    await _localStorage.saveFocusHistory(history.copyWith(dailyRecords: updatedRecords));
    await _updateDailySnapshot();
  }

  int getTodayFocusMinutes() {
    final history = getFocusHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return history.dailyRecords[today] ?? 0;
  }

  // Returns focus minutes for the last 7 days including today (index 6 is today, 0 is 6 days ago)
  List<int> getWeeklyFocusStats() {
    final history = getFocusHistory();
    final List<int> stats = [];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateString = date.toIso8601String().split('T')[0];
      stats.add(history.dailyRecords[dateString] ?? 0);
    }
    return stats;
  }

  // --- Tomato Farm Methods ---
  TomatoFarmModel getTomatoFarm() {
    return _localStorage.getTomatoFarm();
  }

  Future<void> updateTomatoFarm(TomatoFarmModel farm) async {
    await _localStorage.saveTomatoFarm(farm);
    await _updateDailySnapshot();
  }

  Future<void> _updateDailySnapshot() async {
    final history = getFocusHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final streak = getStreak();
    final farm = getTomatoFarm();
    final todayFocus = history.dailyRecords[today] ?? 0;

    final snapshot = DailySnapshotModel(
      date: today,
      focusMinutes: todayFocus,
      streakDays: streak.currentStreakDays,
      harvestCount: farm.harvestCount,
    );

    final updatedSnapshots = Map<String, DailySnapshotModel>.from(history.dailySnapshots);
    updatedSnapshots[today] = snapshot;

    await _localStorage.saveFocusHistory(history.copyWith(dailySnapshots: updatedSnapshots));
  }

  // --- Premium Status ---
  bool isPremium() {
    return _localStorage.getPremium();
  }

  Future<void> setPremium(bool premium) async {
    await _localStorage.setPremium(premium);
  }

  Future<void> purchasePremium() async {
    await _localStorage.setPremium(true);
  }

  bool getHasSeenTutorial() => _localStorage.getHasSeenTutorial();

  Future<void> setHasSeenTutorial(bool seen) async {
    await _localStorage.setHasSeenTutorial(seen);
  }

  Future<void> clearAllData() async {
    await _localStorage.clearAllData();
  }
}
