import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StreakBadge extends StatelessWidget {
  final int streakDays;

  const StreakBadge({Key? key, required this.streakDays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isFire = streakDays > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isFire ? AppTheme.tomatoRed.withOpacity(0.15) : AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFire ? AppTheme.tomatoRed : AppTheme.textGrey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isFire ? '🍅' : '🪴',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Text(
            isFire ? AppLocalizations.of(context)!.streakDaysPlural(streakDays) : AppLocalizations.of(context)!.streakZero,
            style: TextStyle(
              color: isFire ? AppTheme.tomatoRed : AppTheme.textGrey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
