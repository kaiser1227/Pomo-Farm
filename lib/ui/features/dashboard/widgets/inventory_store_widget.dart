import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/app_theme.dart';
import '../view_models/pact_dashboard_view_model.dart';

class InventoryStoreWidget extends StatefulWidget {
  final PactDashboardViewModel viewModel;

  const InventoryStoreWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<InventoryStoreWidget> createState() => _InventoryStoreWidgetState();
}

class _InventoryStoreWidgetState extends State<InventoryStoreWidget> {
  Timer? _actionTimer;
  DateTime? _pressStartTime;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _audioPlayer2 = AudioPlayer(); // For polyphony if needed
  bool _useFirstPlayer = true;

  void _playSound(String assetPath) async {
    final player = _useFirstPlayer ? _audioPlayer : _audioPlayer2;
    _useFirstPlayer = !_useFirstPlayer;
    
    if (player.state == PlayerState.playing) {
      await player.stop();
    }
    await player.play(AssetSource(assetPath));
  }

  void _startContinuousAction(Function action, bool Function() canExecute, String soundPath) {
    if (canExecute()) {
      _playSound(soundPath);
      action();
      _pressStartTime = DateTime.now();
      _scheduleNextAction(action, canExecute, soundPath);
    }
  }

  void _scheduleNextAction(Function action, bool Function() canExecute, String soundPath) {
    if (_pressStartTime == null) return;
    
    final duration = DateTime.now().difference(_pressStartTime!);
    final secondsElapsed = duration.inMilliseconds / 1000.0;
    
    // Base 3 times/sec, increase 1 time/sec every 0.5 sec, max at 3 seconds (6 increases)
    int additionalTimesPerSec = (secondsElapsed / 0.5).floor();
    if (additionalTimesPerSec > 6) additionalTimesPerSec = 6;
    
    int currentRate = 3 + additionalTimesPerSec;
    int delayMs = (1000 / currentRate).round();
    
    _actionTimer = Timer(Duration(milliseconds: delayMs), () {
      if (_pressStartTime == null) return;
      if (canExecute()) {
        _playSound(soundPath);
        action();
        _scheduleNextAction(action, canExecute, soundPath);
      } else {
        _stopContinuousAction();
      }
    });
  }

  void _stopContinuousAction() {
    _pressStartTime = null;
    _actionTimer?.cancel();
    _actionTimer = null;
  }

  @override
  void dispose() {
    _stopContinuousAction();
    _audioPlayer.dispose();
    _audioPlayer2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final farm = widget.viewModel.tomatoFarm;
    final canSellTomato = farm.harvestCount > 0;
    final canWater = farm.waterCount > 0 && farm.currentGrowth < 100.0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          // Inventory & Usage
          Expanded(
            child: Column(
              children: [
                Text('💦 보유 물: ${farm.waterCount}개', style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: GestureDetector(
                    onLongPress: () => _startContinuousAction(
                      () => widget.viewModel.useWater(),
                      () => widget.viewModel.tomatoFarm.waterCount > 0 && widget.viewModel.tomatoFarm.currentGrowth < 100.0,
                      'sounds/water_drop.wav',
                    ),
                    onLongPressUp: () => _stopContinuousAction(),
                    onLongPressCancel: () => _stopContinuousAction(),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      onPressed: canWater ? () {
                        _playSound('sounds/water_drop.wav');
                        widget.viewModel.useWater();
                      } : null,
                      child: Text('물 주기\n(+${(1.0 * widget.viewModel.currentBonusMultiplier).toStringAsFixed(1)}%)', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          Container(width: 1, height: 60, color: Colors.white24),
          const SizedBox(width: 16),
          
          // Store
          Expanded(
            child: Column(
              children: [
                Text('🍅 보유 토마토: ${farm.harvestCount}개', style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: GestureDetector(
                    onLongPress: () => _startContinuousAction(
                      () => widget.viewModel.sellTomato(),
                      () => widget.viewModel.tomatoFarm.harvestCount > 0,
                      'sounds/coin.wav',
                    ),
                    onLongPressUp: () => _stopContinuousAction(),
                    onLongPressCancel: () => _stopContinuousAction(),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: canSellTomato ? AppTheme.tomatoRed : Colors.grey,
                        side: BorderSide(color: canSellTomato ? AppTheme.tomatoRed : Colors.grey, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      onPressed: canSellTomato ? () {
                        _playSound('sounds/coin.wav');
                        widget.viewModel.sellTomato();
                      } : null,
                      child: const Text('수확물 팔기\n(+1,000원)', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

