import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../../features/dashboard/view_models/pact_dashboard_view_model.dart';
import '../../features/dashboard/widgets/history_popup_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeBankCard extends StatelessWidget {
  final PactDashboardViewModel viewModel;

  const TimeBankCard({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final totalMoney = viewModel.timeBank.money;
    final streak = viewModel.streak.currentStreakDays;
    final todayFocus = viewModel.todayFocusMinutes;
    final loc = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => HistoryPopupDialog(viewModel: viewModel),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E3B32), Color(0xFF1E2822)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(Icons.monetization_on, loc.myAsset, '${formatter.format(totalMoney)}${loc.moneyUnit}', AppTheme.lightGreen),
                _buildInfoItem(Icons.timer, loc.todayFocus, '$todayFocus${loc.minuteUnit}', Colors.white),
                _buildInfoItem(Icons.local_fire_department, loc.streakDaysTitle, '$streak${loc.dayUnit}', AppTheme.tomatoRed),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.touch_app, color: Colors.white30, size: 12),
                const SizedBox(width: 4),
                Text(
                  loc.tapForHistory,
                  style: const TextStyle(color: Colors.white30, fontSize: 11),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppTheme.textGrey),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}



