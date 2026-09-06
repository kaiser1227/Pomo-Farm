import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/app_theme.dart';
import '../view_models/pact_dashboard_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TomatoFarmWidget extends StatefulWidget {
  final PactDashboardViewModel viewModel;

  const TomatoFarmWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<TomatoFarmWidget> createState() => _TomatoFarmWidgetState();
}

class _TomatoFarmWidgetState extends State<TomatoFarmWidget> {
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

  String _getStageImagePath(double progress) {
    if (progress < 20) return 'assets/images/tomato_stage_1.png';
    if (progress < 40) return 'assets/images/tomato_stage_2.png';
    if (progress < 60) return 'assets/images/tomato_stage_3.png';
    if (progress < 80) return 'assets/images/tomato_stage_4.png';
    if (progress < 100) return 'assets/images/tomato_stage_5.png';
    return 'assets/images/tomato_stage_6.png';
  }

  Widget _buildTomatoImage(double progress) {
    if (progress >= 80 && progress < 100) {
      double redOpacity = (progress - 80) / 20.0;
      return SizedBox(
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/tomato_stage_4.png',
              height: 220,
              fit: BoxFit.contain,
            ),
            Opacity(
              opacity: redOpacity,
              child: Image.asset(
                'assets/images/tomato_stage_5.png',
                height: 220,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      );
    } else {
      return Image.asset(
        _getStageImagePath(progress),
        height: 220,
        fit: BoxFit.contain,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final farm = widget.viewModel.tomatoFarm;
    final progress = farm.currentGrowth;
    final isReadyToHarvest = progress >= 100.0;
    final hasWater = farm.waterCount > 0;
    final canWater = hasWater && progress < 100.0;
    final canSellTomato = farm.harvestCount > 0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.spa, color: AppTheme.lightGreen, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.tomatoFarmTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightGreen,
                    ),
                  ),
                ],
              ),
              Text(
                AppLocalizations.of(context)!.currentMultiplier(widget.viewModel.currentBonusMultiplier.toStringAsFixed(1)),
                style: const TextStyle(color: AppTheme.textGrey, fontSize: 12),
              ),
            ]
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Image and Growth Stage
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3), width: 2),
                      ),
                      child: Center(
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: isReadyToHarvest ? 1.0 : (progress < 80 ? 0.3 + (progress / 80.0) * 0.7 : 1.0),
                          child: _buildTomatoImage(progress),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right side: Actions
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.growthStage, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('${progress.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress / 100.0,
                        minHeight: 8,
                        backgroundColor: AppTheme.backgroundDark,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.tomatoRed),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!isReadyToHarvest)
                      GestureDetector(
                        onLongPress: () => _startContinuousAction(
                          () => widget.viewModel.useWater(),
                          () => widget.viewModel.tomatoFarm.waterCount > 0 && widget.viewModel.tomatoFarm.currentGrowth < 100.0,
                          'sounds/water_drop.wav',
                        ),
                        onLongPressUp: () => _stopContinuousAction(),
                        onLongPressCancel: () => _stopContinuousAction(),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: canWater ? Colors.lightBlueAccent : AppTheme.backgroundDark,
                            onPrimary: canWater ? Colors.white : AppTheme.textGrey,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: canWater ? 3 : 0,
                          ),
                          icon: const Icon(Icons.opacity, size: 20),
                          label: Text(
                            AppLocalizations.of(context)!.waterAction(farm.waterCount),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          onPressed: canWater ? () {
                            _playSound('sounds/water_drop.wav');
                            widget.viewModel.useWater();
                          } : null,
                        ),
                      ),
                      
                    if (isReadyToHarvest)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.tomatoRed,
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                        ),
                        icon: Image.asset('assets/images/tomato_stage_6.png', width: 24, height: 24),
                        label: Text(
                          AppLocalizations.of(context)!.harvestAction,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => widget.viewModel.harvestTomato(),
                      ),
                      
                    const SizedBox(height: 24),
                    const Divider(color: Colors.grey, height: 1),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/tomato_stage_6.png', width: 16, height: 16),
                        const SizedBox(width: 4),
                        Text(AppLocalizations.of(context)!.tomatoCountLabel(farm.harvestCount), style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: canSellTomato ? () {
                          _playSound('sounds/coin.wav');
                          widget.viewModel.sellTomato();
                        } : null,
                        child: Text(AppLocalizations.of(context)!.sellAction, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
