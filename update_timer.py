import re

with open('lib/ui/features/focus_timer/views/active_timer_view.dart', 'r') as f:
    content = f.read()

# 1. Imports
content = re.sub(
    r"import 'dart:math' as math;",
    "import 'dart:math' as math;\nimport 'dart:ui' as ui;\nimport 'package:flutter/services.dart';",
    content
)

# 2. State vars & initState
init_state_new = """  late int _targetMinutes;
  bool _isSetupMode = true;
  ui.Image? _tomatoImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    _targetMinutes = widget.targetMinutes;
    _remainingSeconds = _targetMinutes * 60;
    _loadTomatoImage();
  }

  Future<void> _loadTomatoImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/tomato_body.png');
      final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 300, targetHeight: 300);
      final ui.FrameInfo fi = await codec.getNextFrame();
      if (mounted) {
        setState(() {
          _tomatoImage = fi.image;
        });
      }
    } catch (e) {
      debugPrint('Failed to load tomato image: $e');
    }
  }"""
content = re.sub(
    r'  late int _targetMinutes;\n  bool _isSetupMode = true;\n\n  @override\n  void initState\(\) \{[\s\S]*?_remainingSeconds = _targetMinutes \* 60;\n  \}',
    init_state_new,
    content
)

# 3. CustomPaint constructor
content = re.sub(
    r'isSetupMode: _isSetupMode,\n\s*\),',
    r'isSetupMode: _isSetupMode,\n                              tomatoImage: _tomatoImage,\n                            ),',
    content
)

# 4. TomatoPiePainter
painter_class_old = """class TomatoPiePainter extends CustomPainter {
  final double percentage;
  final bool isSetupMode;

  TomatoPiePainter({
    required this.percentage,
    required this.isSetupMode,
  });"""
painter_class_new = """class TomatoPiePainter extends CustomPainter {
  final double percentage;
  final bool isSetupMode;
  final ui.Image? tomatoImage;

  TomatoPiePainter({
    required this.percentage,
    required this.isSetupMode,
    this.tomatoImage,
  });"""
content = content.replace(painter_class_old, painter_class_new)

# 5. paint method piePaint
paint_old = """    // 2. 빨간색 파이 조각 (입체 그라데이션)
    final piePaint = Paint()
      ..shader = RadialGradient(
        colors: [AppTheme.lightTomato, AppTheme.darkTomato],
        center: const Alignment(-0.2, -0.3),
        radius: 0.8,
      ).createShader(rect)
      ..style = PaintingStyle.fill;"""
paint_new = """    // 2. 빨간색 파이 조각 (실제 이미지 텍스쳐 또는 그라데이션)
    final piePaint = Paint()..style = PaintingStyle.fill;
    
    if (tomatoImage != null) {
      final Float64List matrix = (Matrix4.identity()
        ..scale(size.width / tomatoImage!.width, size.height / tomatoImage!.height)
      ).storage;
      
      piePaint.shader = ImageShader(
        tomatoImage!,
        TileMode.clamp,
        TileMode.clamp,
        matrix,
      );
    } else {
      piePaint.shader = RadialGradient(
        colors: [AppTheme.lightTomato, AppTheme.darkTomato],
        center: const Alignment(-0.2, -0.3),
        radius: 0.8,
      ).createShader(rect);
    }"""
content = content.replace(paint_old, paint_new)

with open('lib/ui/features/focus_timer/views/active_timer_view.dart', 'w') as f:
    f.write(content)
