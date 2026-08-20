import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../view_models/pact_dashboard_view_model.dart';

class FocusStatsDialog extends StatelessWidget {
  final PactDashboardViewModel viewModel;

  const FocusStatsDialog({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = viewModel.weeklyStats;
    // Find the max value to scale the chart, minimum scale is 120 (2 hours)
    final int maxMinutes = stats.fold(120, (max, current) => current > max ? current : max);

    // X-axis labels
    final now = DateTime.now();
    final List<String> labels = [];
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      labels.add(weekdays[date.weekday - 1]);
    }

    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E), // Dark theme color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '📊 주간 집중 시간',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final minutes = stats[index];
                  final heightRatio = minutes / maxMinutes;
                  
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        minutes > 0 ? '${minutes}m' : '',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 24,
                        height: 150 * heightRatio,
                        decoration: BoxDecoration(
                          color: index == 6 ? AppTheme.tomatoRed : AppTheme.tomatoRed.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: index == 6 ? Colors.white : Colors.white60,
                          fontWeight: index == 6 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                primary: Colors.white24,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('닫기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
