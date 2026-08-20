import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/streak_model.dart';
import '../../domain/models/time_bank_model.dart';
import '../../domain/models/focus_history_model.dart';
import '../../domain/models/tomato_farm_model.dart';

class LocalStorageService {
  static const String _streakKey = 'streak_data';
  static const String _timeBankKey = 'time_bank_data';
  static const String _focusHistoryKey = 'focus_history_data';
  static const String _tomatoFarmKey = 'tomato_farm_data';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // --- Streak ---
  Future<void> saveStreak(StreakModel streak) async {
    final jsonString = jsonEncode(streak.toJson());
    await _prefs.setString(_streakKey, jsonString);
  }

  StreakModel getStreak() {
    final jsonString = _prefs.getString(_streakKey);
    if (jsonString != null) {
      return StreakModel.fromJson(jsonDecode(jsonString));
    }
    return StreakModel();
  }

  // --- Time Bank ---
  Future<void> saveTimeBank(TimeBankModel timeBank) async {
    final jsonString = jsonEncode(timeBank.toJson());
    await _prefs.setString(_timeBankKey, jsonString);
  }

  TimeBankModel getTimeBank() {
    final jsonString = _prefs.getString(_timeBankKey);
    if (jsonString != null) {
      return TimeBankModel.fromJson(jsonDecode(jsonString));
    }
    return TimeBankModel();
  }

  // --- Focus History ---
  Future<void> saveFocusHistory(FocusHistoryModel history) async {
    final jsonString = jsonEncode(history.toJson());
    await _prefs.setString(_focusHistoryKey, jsonString);
  }

  FocusHistoryModel getFocusHistory() {
    final jsonString = _prefs.getString(_focusHistoryKey);
    if (jsonString != null) {
      return FocusHistoryModel.fromJson(jsonDecode(jsonString));
    }
    return FocusHistoryModel();
  }

  // --- Tomato Farm ---
  Future<void> saveTomatoFarm(TomatoFarmModel farm) async {
    final jsonString = jsonEncode(farm.toJson());
    await _prefs.setString(_tomatoFarmKey, jsonString);
  }

  TomatoFarmModel getTomatoFarm() {
    final jsonString = _prefs.getString(_tomatoFarmKey);
    if (jsonString != null) {
      return TomatoFarmModel.fromJson(jsonDecode(jsonString));
    }
    return TomatoFarmModel();
  }

  // --- Premium Status ---
  static const String _isPremiumKey = 'is_premium';

  Future<void> setPremium(bool isPremium) async {
    await _prefs.setBool(_isPremiumKey, isPremium);
  }

  bool getPremium() {
    return _prefs.getBool(_isPremiumKey) ?? false;
  }

  // --- Tutorial Status ---
  static const String _hasSeenTutorialKey = 'has_seen_tutorial';

  Future<void> setHasSeenTutorial(bool seen) async {
    await _prefs.setBool(_hasSeenTutorialKey, seen);
  }

  bool getHasSeenTutorial() {
    return _prefs.getBool(_hasSeenTutorialKey) ?? false;
  }

  // --- Reset ---
  Future<void> clearAllData() async {
    await _prefs.remove(_streakKey);
    await _prefs.remove(_timeBankKey);
    await _prefs.remove(_focusHistoryKey);
    await _prefs.remove(_tomatoFarmKey);
  }
}

