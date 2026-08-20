import re

with open('lib/ui/features/focus_timer/views/active_timer_view.dart', 'r') as f:
    content = f.read()

# 1. Replace imports (add dart:math, remove sleek_circular_slider)
content = re.sub(
    r"import 'package:sleek_circular_slider/sleek_circular_slider.dart';\n",
    "import 'dart:math' as math;\n",
    content
)

# 2. Update state methods for panning
pan_methods = """  void _updateTimeFromLocalPosition(Offset local) {
    final double cx = 150;
    final double cy = 130;
    
    final double dx = local.dx - cx;
    final double dy = local.dy - cy;
    
    // Parametric angle for ellipse (rx=150, ry=130)
    double tAngle = math.atan2(dy / 130, dx / 150);
    double adjustedAngle = tAngle + (math.pi / 2);
    if (adjustedAngle < 0) adjustedAngle += 2 * math.pi;
    
    double percentage = adjustedAngle / (2 * math.pi);
    int mins = (percentage * 120).round();
    if (mins < 1) mins = 1;
    if (mins > 120) mins = 120;
    
    if (mins != _targetMinutes) {
      setState(() {
        _targetMinutes = mins;
        _remainingSeconds = _targetMinutes * 60;
      });
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isSetupMode) return;
    _updateTimeFromLocalPosition(details.localPosition);
  }
  
  void _handlePanDown(DragDownDetails details) {
    if (!_isSetupMode) return;
    _updateTimeFromLocalPosition(details.localPosition);
  }"""

content = re.sub(
    r'  @override\n  Widget build',
    pan_methods + '\n\n  @override\n  Widget build',
    content
)

# 3. Replace build method and CustomPainter
build_and_painter = """  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        _onGiveUp();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onPanUpdate: _handlePanUpdate,
                          onPanDown: _handlePanDown,
                          child: CustomPaint(
                            size: const Size(300, 260),
                            painter: TomatoPiePainter(
                              percentage: _isSetupMode ? (_targetMinutes / 120.0) : (_remainingSeconds / (_targetMinutes * 60)),
                              isSetupMode: _isSetupMode,
                            ),
                          ),
                        ),
                        // Center Text
                        IgnorePointer(
                          child: Text(
                            _isSetupMode 
                              ? '$_targetMinutes분'
                              : '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _isSetupMode ? '시간을 설정해주세요' : '앱을 벗어나면 약속이 깨집니다',
                      style: const TextStyle(color: AppTheme.textGrey, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: _isSetupMode
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('취소', style: TextStyle(color: AppTheme.textGrey, fontSize: 18)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.tomatoRed,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            ),
                            onPressed: _startTimerAndKiosk,
                            child: const Text('시작', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: _onGiveUp,
                        child: const Text('포기하기', style: TextStyle(color: AppTheme.textGrey, decoration: TextDecoration.underline)),
                      ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class TomatoPiePainter extends CustomPainter {
  final double percentage;
  final bool isSetupMode;

  TomatoPiePainter({
    required this.percentage,
    required this.isSetupMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // 1. 배경 토마토 (그림자 포함)
    Path bgPath = Path()..addOval(rect);
    canvas.drawShadow(bgPath, Colors.black, 15.0, true);
    
    final bgPaint = Paint()..color = const Color(0xFF2A2A2A); // 살짝 밝은 어두운 회색으로 빈 그릇 표현
    canvas.drawPath(bgPath, bgPaint);

    // 2. 빨간색 파이 조각 (입체 그라데이션)
    final piePaint = Paint()
      ..shader = RadialGradient(
        colors: [AppTheme.lightTomato, AppTheme.darkTomato],
        center: const Alignment(-0.2, -0.3),
        radius: 0.8,
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    
    double startAngle = -math.pi / 2;
    double sweepAngle = 2 * math.pi * percentage;
    
    if (percentage >= 0.999) {
      canvas.drawPath(bgPath, piePaint);
    } else if (percentage > 0.0) {
      canvas.drawArc(rect, startAngle, sweepAngle, true, piePaint);
    }

    // 3. 커스텀 꼭지 (잎사귀) 그리기
    _drawStem(canvas, size.width / 2, 0);

    // 4. 슬라이더 핸들 (설정 모드일 때만)
    if (isSetupMode) {
      // 파라메트릭 각도로 핸들 위치 계산
      double tAngle = (percentage * 2 * math.pi) - (math.pi / 2);
      double hx = (size.width / 2) + (size.width / 2) * math.cos(tAngle);
      double hy = (size.height / 2) + (size.height / 2) * math.sin(tAngle);

      final handlePaint = Paint()..color = Colors.white;
      canvas.drawShadow(Path()..addOval(Rect.fromCircle(center: Offset(hx, hy), radius: 10)), Colors.black, 6.0, true);
      canvas.drawCircle(Offset(hx, hy), 12.0, handlePaint);
      
      // 핸들 안쪽에 빨간 점 추가 (토마토 느낌)
      canvas.drawCircle(Offset(hx, hy), 4.0, Paint()..color = AppTheme.tomatoRed);
    }
  }

  void _drawStem(Canvas canvas, double cx, double cy) {
    // 꼭지잎 그림자
    final stemPath = Path();
    stemPath.moveTo(cx, cy + 15);
    // 왼쪽 잎
    stemPath.quadraticBezierTo(cx - 20, cy - 5, cx - 35, cy + 15);
    stemPath.quadraticBezierTo(cx - 20, cy + 20, cx - 10, cy + 10);
    // 위쪽 잎
    stemPath.quadraticBezierTo(cx, cy - 15, cx + 5, cy + 5);
    // 오른쪽 잎
    stemPath.quadraticBezierTo(cx + 25, cy + 25, cx + 35, cy + 10);
    stemPath.quadraticBezierTo(cx + 20, cy - 5, cx, cy + 15);
    
    canvas.drawShadow(stemPath, Colors.black, 8.0, true);

    // 꼭지잎 색상
    final stemPaint = Paint()
      ..color = AppTheme.primaryGreen
      ..style = PaintingStyle.fill;
    canvas.drawPath(stemPath, stemPaint);
    
    // 중앙 줄기
    final stalkPath = Path();
    stalkPath.moveTo(cx - 2, cy + 10);
    stalkPath.quadraticBezierTo(cx - 5, cy - 10, cx + 5, cy - 15);
    stalkPath.quadraticBezierTo(cx + 5, cy - 5, cx + 3, cy + 10);
    stalkPath.close();
    
    canvas.drawPath(stalkPath, Paint()..color = AppTheme.darkGreen);
  }

  @override
  bool shouldRepaint(covariant TomatoPiePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.isSetupMode != isSetupMode;
  }
}"""

content = re.sub(
    r'  @override\n  Widget build\(BuildContext context\) \{[\s\S]*\}\n\}\n',
    build_and_painter + '\n',
    content
)

with open('lib/ui/features/focus_timer/views/active_timer_view.dart', 'w') as f:
    f.write(content)
