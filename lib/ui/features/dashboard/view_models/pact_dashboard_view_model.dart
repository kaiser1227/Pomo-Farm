import 'package:flutter/material.dart';
import '../../../../domain/models/streak_model.dart';
import '../../../../domain/models/time_bank_model.dart';
import '../../../../domain/models/tomato_farm_model.dart';
import '../../../../domain/models/focus_history_model.dart';
import '../../../../data/repositories/focus_pact_repository.dart';

class PactDashboardViewModel extends ChangeNotifier {
  final FocusPactRepository _repository;

  StreakModel _streak = StreakModel();
  TimeBankModel _timeBank = TimeBankModel();
  TomatoFarmModel _tomatoFarm = TomatoFarmModel();
  bool _isPremium = false;
  int _todayFocusMinutes = 0;
  List<int> _weeklyStats = List.filled(7, 0);
  FocusHistoryModel _focusHistory = FocusHistoryModel();
  bool _hasSeenTutorial = false;
  bool _isAdminMode = false;

  StreakModel get streak => _streak;
  TimeBankModel get timeBank => _timeBank;
  TomatoFarmModel get tomatoFarm => _tomatoFarm;
  bool get isPremium => _isPremium;
  int get todayFocusMinutes => _todayFocusMinutes;
  List<int> get weeklyStats => _weeklyStats;
  FocusHistoryModel get focusHistory => _focusHistory;
  bool get hasSeenTutorial => _hasSeenTutorial;
  bool get isAdminMode => _isAdminMode;

  double get currentBonusMultiplier {
    // 1.0(기본) + (연속 횟수 * 0.1)
    return 1.0 + (_streak.currentStreakDays * 0.1);
  }

  PactDashboardViewModel(this._repository) {
    _loadData();
  }

  void _loadData() {
    _streak = _repository.getStreak();
    
    // 연속 일수 깨짐 체크
    final today = DateTime.now().toIso8601String().split('T')[0];
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0];
    if (_streak.currentStreakDays > 0 && 
        _streak.historyMap[today] != true && 
        _streak.historyMap[yesterday] != true) {
      _streak = _streak.copyWith(currentStreakDays: 0);
      _repository.updateStreak(_streak);
    }

    _timeBank = _repository.getTimeBank();
    _tomatoFarm = _repository.getTomatoFarm();

    _isPremium = _repository.isPremium();
    _todayFocusMinutes = _repository.getTodayFocusMinutes();
    _weeklyStats = _repository.getWeeklyFocusStats();
    _focusHistory = _repository.getFocusHistory();
    _hasSeenTutorial = _repository.getHasSeenTutorial();
    notifyListeners();
  }

  void refreshData() {
    _loadData();
  }

  Future<void> markTutorialAsSeen() async {
    await _repository.setHasSeenTutorial(true);
    _hasSeenTutorial = true;
    notifyListeners();
  }

  Future<void> purchasePremium() async {
    await _repository.setPremium(true);
    _loadData();
  }

  Future<void> togglePremium() async {
    _isPremium = !_isPremium;
    await _repository.setPremium(_isPremium);
    _loadData();
  }

  Future<void> completeFocusSession(int minutes, {bool isKioskActive = true}) async {
    await _repository.incrementStreak();
    if (isKioskActive) {
      await _repository.addSavedTime(minutes);
    }
    await _repository.addFocusTime(minutes);
    
    // 신규 경제: 집중 시간 1분당 1 물방울 지급
    await _repository.updateTomatoFarm(_tomatoFarm.copyWith(
      waterCount: _tomatoFarm.waterCount + minutes,
    ));
    
    _loadData();
  }

  Future<void> failFocusSession(int targetMinutes) async {
    await _repository.resetStreak();
    int penalty = targetMinutes ~/ 2;
    await _repository.deductPenaltyTime(penalty);
    _loadData();
  }

  // (Deprecated) buyWater is no longer used, we earn water by focusing.
  Future<void> buyWater() async {
    // keeping for safety if called
  }

  Future<void> sellTomato() async {
    if (_tomatoFarm.harvestCount > 0) {
      // 1 토마토 = 1,000원
      await _repository.addMoney(1000);
      await _repository.updateTomatoFarm(_tomatoFarm.copyWith(
        harvestCount: _tomatoFarm.harvestCount - 1,
      ));
      _loadData();
    }
  }



  Future<void> useWater() async {
    if (_tomatoFarm.waterCount > 0 && _tomatoFarm.currentGrowth < 100.0) {
      double addedGrowth = 1.0 * currentBonusMultiplier;
      double newGrowth = _tomatoFarm.currentGrowth + addedGrowth;
      if (newGrowth > 100.0) newGrowth = 100.0;

      int newTotalWater = _tomatoFarm.totalWaterUsed + 1;

      await _repository.updateTomatoFarm(_tomatoFarm.copyWith(
        waterCount: _tomatoFarm.waterCount - 1,
        currentGrowth: newGrowth,
        totalWaterUsed: newTotalWater,
      ));
      _loadData();
    }
  }



  Future<void> harvestTomato() async {
    if (_tomatoFarm.currentGrowth >= 100.0) {
      await _repository.updateTomatoFarm(_tomatoFarm.copyWith(
        currentGrowth: 0.0,
        harvestCount: _tomatoFarm.harvestCount + 1,
      ));
      _loadData();
    }
  }

  Future<void> buyAccessory(String id, int cost) async {
    if (_timeBank.money >= cost && !_tomatoFarm.ownedAccessories.contains(id)) {
      final updatedAccessories = List<String>.from(_tomatoFarm.ownedAccessories)..add(id);
      
      await _repository.deductMoney(cost);
      
      await _repository.updateTomatoFarm(_tomatoFarm.copyWith(
        ownedAccessories: updatedAccessories,
        equippedAccessory: id,
      ));
      _loadData();
    }
  }

  Future<void> equipAccessory(String? id) async {
    await _repository.updateTomatoFarm(_tomatoFarm.copyWith(
      equippedAccessory: id,
      clearEquipped: id == null,
    ));
    _loadData();
  }

  Future<void> toggleAdminMode(bool value) async {
    _isAdminMode = value;
    if (value) {
      _timeBank = _timeBank.copyWith(money: 10000);
      await _repository.updateTimeBank(_timeBank);
      _tomatoFarm = _tomatoFarm.copyWith(waterCount: 100, harvestCount: 100);
      await _repository.updateTomatoFarm(_tomatoFarm);
    } else {
      await _repository.clearAllData();
    }
    _loadData();
  }

  Future<void> resetData() async {
    await _repository.clearAllData();
    _loadData();
  }
}
