import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

class TripleWarningDialog extends StatefulWidget {
  final int targetMinutes;
  const TripleWarningDialog({Key? key, required this.targetMinutes}) : super(key: key);

  @override
  State<TripleWarningDialog> createState() => _TripleWarningDialogState();
}

class _TripleWarningDialogState extends State<TripleWarningDialog> {
  final TextEditingController _controller = TextEditingController();
  
  static const List<String> _sentences = [
    "나는 지금 유혹에 굴복하여 나의 소중한 시간을 버립니다",
    "나와의 약속을 깨고 순간의 즐거움을 선택하겠습니다",
    "오늘도 핑계를 대며 내일의 나에게 책임을 떠넘깁니다",
    "성장의 기회를 포기하고 편안함에 안주하겠습니다",
    "나의 미래보다 지금 당장의 도파민이 더 중요합니다",
    "이 작은 인내심조차 발휘하지 못하는 나를 인정합니다",
    "스마트폰의 노예가 되어 주체적인 시간을 포기합니다",
    "결심은 쉽지만 실천은 어렵다는 것을 다시금 증명합니다",
    "목표를 향한 발걸음을 멈추고 제자리에 머물겠습니다",
    "소중한 사람들과의 약속보다 화면 속 가짜 세상이 더 좋습니다",
    "잠깐의 유혹을 이기지 못해 그동안 쌓아온 공든 탑을 무너뜨립니다",
    "스스로 정한 규칙조차 지키지 못하는 얄팍한 의지력을 받아들입니다",
    "집중의 고통을 피하고 산만함이 주는 쾌락을 좇겠습니다",
    "나를 성장시킬 소중한 자산을 한순간에 낭비해 버리겠습니다",
    "나쁜 습관의 사슬을 끊지 못하고 다시 굴레로 들어갑니다",
    "변화하겠다는 나의 다짐은 그저 공허한 메아리였습니다",
    "현재의 나태함을 위해 미래의 보상을 기꺼이 희생하겠습니다",
    "아주 작은 난관 앞에서도 쉽게 포기하는 사람이 되겠습니다",
    "진짜 내 삶의 주인이 되기를 포기하고 스마트폰에 끌려다니겠습니다",
    "후회할 것을 뻔히 알면서도 당장의 유혹에 손을 뻗습니다",
    "나는 나 자신을 통제할 능력이 없음을 스스로 증명합니다",
    "이 순간의 나약함이 모여 내 인생의 거대한 실패를 만듭니다",
    "의미 있는 노력 대신 시간 때우기용 컨텐츠를 소비하겠습니다",
    "위대한 성취보다 보잘것없는 쾌락이 내게는 더 어울립니다",
    "포기하는 것에 익숙해져 더 이상 도전조차 시도하지 않겠습니다",
    "나를 믿고 응원하는 파트너의 기대를 무참히 저버리겠습니다",
    "그 어떤 변명도 통하지 않는 온전한 나의 패배입니다",
    "다시 시작하면 된다는 핑계로 오늘의 실패를 덮고 넘어갑니다",
    "나는 내 하나뿐인 인생을 스마트폰 화면 속에 갈아 넣고 있습니다",
    "지금 이 선택이 어떤 결과를 가져올지 알면서도 눈을 감습니다",
  ];

  late final String _targetText;
  bool _canGiveUp = false;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _targetText = _sentences[random.nextInt(_sentences.length)];
    
    _controller.addListener(() {
      if (_controller.text == _targetText) {
        setState(() => _canGiveUp = true);
      } else {
        if (_canGiveUp) setState(() => _canGiveUp = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int penalty = widget.targetMinutes ~/ 2;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('🚨 정말 포기하시겠습니까?', style: TextStyle(color: AppTheme.error)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('지금 포기하면 다음과 같은 페널티가 발생합니다:', style: TextStyle(color: AppTheme.textLight)),
            const SizedBox(height: 8),
            const Text('🍅 애써 키운 연속 수확 기록이 초기화됩니다.', style: TextStyle(color: AppTheme.tomatoRed)),
            const SizedBox(height: 24),
            Text('💰 집중 실패 벌금으로 $penalty분의 자산이 차감됩니다.', style: const TextStyle(color: AppTheme.lightTomato)),
            const SizedBox(height: 8),
            const Text('🤝 파트너에게 실패 알림이 전송됩니다.', style: TextStyle(color: AppTheme.textGrey)),
            const SizedBox(height: 24),
            const Text('그래도 포기하시려면, 아래 문장을 정확히 입력하세요.', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.textGrey),
              ),
              child: Text(
                _targetText,
                style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              style: const TextStyle(color: AppTheme.textLight),
              decoration: const InputDecoration(
                hintText: '위 문장을 그대로 입력하세요',
                hintStyle: TextStyle(color: AppTheme.textGrey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.error)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Continue focus
          child: const Text('계속 집중하기', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: _canGiveUp ? AppTheme.error : AppTheme.textGrey.withOpacity(0.5),
            onPrimary: Colors.white,
          ),
          onPressed: _canGiveUp ? () => Navigator.pop(context, true) : null,
          child: const Text('포기하고 자산 잃기'),
        ),
      ],
    );
  }
}
