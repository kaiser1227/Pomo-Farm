import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../view_models/pact_dashboard_view_model.dart';

class TomatoFarmWidget extends StatelessWidget {
  final PactDashboardViewModel viewModel;

  const TomatoFarmWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final farm = viewModel.tomatoFarm;
    final progress = farm.currentGrowth;
    final isReadyToHarvest = progress >= 100.0;
    
    // Scale emoji based on progress (min size 30, max size 70)
    final double emojiSize = 30.0 + ((progress / 100.0) * 40.0);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '🌱 토마토 농장',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightGreen,
            ),
          ),
          const SizedBox(height: 10),
          
          // Tomato Emoji Display
          SizedBox(
            height: 80,
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 500),
                style: TextStyle(
                  fontSize: isReadyToHarvest ? 70 : emojiSize,
                  fontFamilyFallback: const ['Noto Color Emoji', 'Apple Color Emoji', 'Segoe UI Emoji'],
                ),
                child: const Text('🍅'),
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / 100.0,
              minHeight: 10,
              backgroundColor: AppTheme.backgroundDark,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.tomatoRed),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '성장도: ${progress.toStringAsFixed(1)}% (현재 ${viewModel.currentBonusMultiplier.toStringAsFixed(1)}배속)',
            style: const TextStyle(color: AppTheme.textLight, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          
          if (isReadyToHarvest) ...[
            const SizedBox(height: 10),
            // Harvest Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.tomatoRed,
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                viewModel.harvestTomato();
              },
              child: const Text(
                '🍅 수확!',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
