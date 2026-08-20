import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import 'focus_stats_dialog.dart';
import '../view_models/pact_dashboard_view_model.dart';

class FocusProgressRing extends StatelessWidget {
  final PactDashboardViewModel viewModel;
  final int targetMinutes;

  const FocusProgressRing({
    Key? key,
    required this.viewModel,
    this.targetMinutes = 120, // Default 2 hours
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int currentMinutes = viewModel.todayFocusMinutes;
    final double progress = (currentMinutes / targetMinutes).clamp(0.0, 1.0);
    
    // Format minutes to hours/minutes (e.g., 01h 25m)
    final hours = currentMinutes ~/ 60;
    final mins = currentMinutes % 60;
    final timeString = '${hours.toString().padLeft(2, '0')}h ${mins.toString().padLeft(2, '0')}m';
    
    final targetHours = targetMinutes ~/ 60;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => FocusStatsDialog(viewModel: viewModel),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 16,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.tomatoRed),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timeString,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '/ ${targetHours}h',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '터치하여 주간 통계 보기',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
