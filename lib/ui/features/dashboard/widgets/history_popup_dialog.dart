import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/app_theme.dart';
import '../view_models/pact_dashboard_view_model.dart';

class HistoryPopupDialog extends StatelessWidget {
  final PactDashboardViewModel viewModel;

  const HistoryPopupDialog({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '📅 상태 히스토리',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textGrey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const TabBar(
                labelColor: AppTheme.tomatoRed,
                unselectedLabelColor: AppTheme.textGrey,
                indicatorColor: AppTheme.tomatoRed,
                tabs: [
                  Tab(text: '일별'),
                  Tab(text: '요일별'),
                  Tab(text: '월별'),
                ],
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                child: TabBarView(
                  children: [
                    _buildDailyTab(context),
                    _buildWeekdayTab(context),
                    _buildMonthlyTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyTab(BuildContext context) {
    final snapshots = viewModel.focusHistory.dailySnapshots;
    final sortedKeys = snapshots.keys.toList()..sort((a, b) => b.compareTo(a));
    
    if (sortedKeys.isEmpty) {
      return const Center(child: Text('기록이 없습니다.', style: TextStyle(color: AppTheme.textGrey)));
    }
    
    return ListView.separated(
      shrinkWrap: true,
      itemCount: sortedKeys.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final dateKey = sortedKeys[index];
        final snapshot = snapshots[dateKey]!;
        DateTime date = DateTime.tryParse(dateKey) ?? DateTime.now();
        String formattedDate = DateFormat('yyyy년 MM월 dd일').format(date);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.backgroundDark.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formattedDate, style: const TextStyle(color: AppTheme.lightGreen, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('⏳', '${snapshot.focusMinutes}분'),
                  _buildStat('🔥', '${snapshot.streakDays}일'),
                  _buildStat('🍅', '${snapshot.harvestCount}개'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeekdayTab(BuildContext context) {
    final records = viewModel.focusHistory.dailyRecords;
    Map<int, int> weekdayStats = {1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0};
    for (var entry in records.entries) {
      DateTime date = DateTime.tryParse(entry.key) ?? DateTime.now();
      weekdayStats[date.weekday] = (weekdayStats[date.weekday] ?? 0) + entry.value;
    }
    
    final weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 7,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        int weekday = index + 1;
        int minutes = weekdayStats[weekday] ?? 0;
        return _buildAggregateRow(weekdays[index], minutes);
      },
    );
  }

  Widget _buildMonthlyTab(BuildContext context) {
    final records = viewModel.focusHistory.dailyRecords;
    Map<String, int> monthlyStats = {};
    for (var entry in records.entries) {
      if (entry.key.length >= 7) {
        String monthKey = entry.key.substring(0, 7); // yyyy-MM
        monthlyStats[monthKey] = (monthlyStats[monthKey] ?? 0) + entry.value;
      }
    }
    
    final sortedMonths = monthlyStats.keys.toList()..sort((a, b) => b.compareTo(a));
    
    if (sortedMonths.isEmpty) {
      return const Center(child: Text('기록이 없습니다.', style: TextStyle(color: AppTheme.textGrey)));
    }
    
    return ListView.separated(
      shrinkWrap: true,
      itemCount: sortedMonths.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        String monthKey = sortedMonths[index]; // 'yyyy-MM'
        int minutes = monthlyStats[monthKey] ?? 0;
        final parts = monthKey.split('-');
        String label = '${parts[0]}년 ${parts[1]}월';
        return _buildAggregateRow(label, minutes);
      },
    );
  }

  Widget _buildAggregateRow(String label, int minutes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Text('⏳', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text('$minutes 분', style: const TextStyle(color: AppTheme.lightGreen, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: AppTheme.textLight, fontSize: 14)),
      ],
    );
  }
}
