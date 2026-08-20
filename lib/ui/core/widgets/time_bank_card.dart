import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../../features/dashboard/view_models/pact_dashboard_view_model.dart';
import '../../features/dashboard/widgets/history_popup_dialog.dart';

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
                _buildInfoItem('💰 내 자산', '${formatter.format(totalMoney)}원', AppTheme.lightGreen),
                _buildInfoItem('⏱️ 오늘 집중', '$todayFocus분', Colors.white),
                _buildInfoItem('🔥 연속 일수', '$streak일', AppTheme.tomatoRed),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '👆 탭하여 상세 히스토리 보기',
              style: TextStyle(color: Colors.white30, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}



