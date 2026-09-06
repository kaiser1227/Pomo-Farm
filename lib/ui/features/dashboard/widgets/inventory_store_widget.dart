import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/app_theme.dart';
import '../view_models/pact_dashboard_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final AudioPlayer _audioPlayer2 = AudioPlayer();
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.eco, color: AppTheme.tomatoRed, size: 16),
                    const SizedBox(width: 4),
                    Text(AppLocalizations.of(context)!.ownedTomatoes(farm.harvestCount), style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
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
                      child: Text(AppLocalizations.of(context)!.sellTomatoes, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
