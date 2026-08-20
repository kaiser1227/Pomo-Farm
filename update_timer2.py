import re

with open('lib/ui/features/focus_timer/views/active_timer_view.dart', 'r') as f:
    content = f.read()

# 1. Remove ui.Image? _tomatoImage; and _loadTomatoImage
content = re.sub(r'  ui\.Image\? _tomatoImage;\n', '', content)
content = re.sub(r'    _loadTomatoImage\(\);\n', '', content)

load_tomato_func = r"""  Future<void> _loadTomatoImage\(\) async \{
    try \{
      final ByteData data = await rootBundle\.load\('assets/images/tomato_body\.png'\);
      final ui\.Codec codec = await ui\.instantiateImageCodec\(data\.buffer\.asUint8List\(\), targetWidth: 300, targetHeight: 300\);
      final ui\.FrameInfo fi = await codec\.getNextFrame\(\);
      if \(mounted\) \{
        setState\(\(\) \{
          _tomatoImage = fi\.image;
        \}\);
      \}
    \} catch \(e\) \{
      debugPrint\('Failed to load tomato image: \$e'\);
    \}
  \}"""
content = re.sub(load_tomato_func, '', content)

# 2. Update CustomPaint constructor
content = re.sub(r'                              tomatoImage: _tomatoImage,\n', '', content)

# 3. Update TomatoPiePainter class definition
painter_def_old = r"""class TomatoPiePainter extends CustomPainter \{
  final double percentage;
  final bool isSetupMode;
  final ui\.Image\? tomatoImage;

  TomatoPiePainter\(\{
    required this\.percentage,
    required this\.isSetupMode,
    this\.tomatoImage,
  \}\);"""
painter_def_new = """class TomatoPiePainter extends CustomPainter {
  final double percentage;
  final bool isSetupMode;

  TomatoPiePainter({
    required this.percentage,
    required this.isSetupMode,
  });"""
content = re.sub(painter_def_old, painter_def_new, content)

# 4. Update paint method
paint_old = r"""    // 2. 빨간색 파이 조각 \(실제 이미지 텍스쳐 또는 그라데이션\)
    final piePaint = Paint\(\)\.\.style = PaintingStyle\.fill;
    
    if \(tomatoImage != null\) \{
      final Float64List matrix = \(Matrix4\.identity\(\)
        \.\.scale\(size\.width / tomatoImage!\.width, size\.height / tomatoImage!\.height\)
      \)\.storage;
      
      piePaint\.shader = ImageShader\(
        tomatoImage!,
        TileMode\.clamp,
        TileMode\.clamp,
        matrix,
      \);
    \} else \{
      piePaint\.shader = RadialGradient\(
        colors: \[AppTheme\.lightTomato, AppTheme\.darkTomato\],
        center: const Alignment\(-0\.2, -0\.3\),
        radius: 0\.8,
      \)\.createShader\(rect\);
    \}
    
    double startAngle = -math\.pi / 2;
    double sweepAngle = 2 \* math\.pi \* percentage;
    
    if \(percentage >= 0\.999\) \{
      canvas\.drawPath\(bgPath, piePaint\);
    \} else if \(percentage > 0\.0\) \{
      canvas\.drawArc\(rect, startAngle, sweepAngle, true, piePaint\);
    \}

    // 3. 커스텀 꼭지 \(잎사귀\) 그리기
    _drawStem\(canvas, size\.width / 2, 0\);"""

paint_new = """    double startAngle = -math.pi / 2;
    double sweepAngle = 2 * math.pi * percentage;

    // 2. 파이 조각 모양의 클리핑 영역 생성 및 이모지 렌더링
    if (percentage > 0.0) {
      Path piePath = Path();
      if (percentage >= 0.999) {
        piePath.addOval(rect);
      } else {
        piePath.moveTo(rect.center.dx, rect.center.dy);
        piePath.arcTo(rect, startAngle, sweepAngle, false);
        piePath.close();
      }

      canvas.save();
      canvas.clipPath(piePath);

      // 토마토 농장과 동일한 🍅 이모지 사용 및 크게 렌더링
      final textSpan = TextSpan(
        text: '🍅',
        style: TextStyle(fontSize: 260),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final offset = Offset(
        rect.center.dx - (textPainter.width / 2),
        rect.center.dy - (textPainter.height / 2) + 15,
      );
      textPainter.paint(canvas, offset);

      canvas.restore();
    }"""
content = re.sub(paint_old, paint_new, content)

with open('lib/ui/features/focus_timer/views/active_timer_view.dart', 'w') as f:
    f.write(content)
