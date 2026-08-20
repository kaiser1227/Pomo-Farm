import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

enum StickerThemeType {
  glassmorphism,
  neonGlow,
  solidMinimal,
}

class DraggableSticker extends StatefulWidget {
  final Widget child;
  final StickerThemeType theme;
  final Offset initialPosition;

  const DraggableSticker({
    Key? key,
    required this.child,
    required this.theme,
    required this.initialPosition,
  }) : super(key: key);

  @override
  _DraggableStickerState createState() => _DraggableStickerState();
}

class _DraggableStickerState extends State<DraggableSticker> {
  late Offset _position;
  double _scale = 1.0;
  double _baseScale = 1.0;
  double _rotation = 0.0;
  double _baseRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  Widget _buildThemedSticker() {
    switch (widget.theme) {
      case StickerThemeType.glassmorphism:
        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.tomatoRed.withOpacity(0.8), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(2, 5),
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        );

      case StickerThemeType.neonGlow:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.tomatoRed, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.tomatoRed.withOpacity(0.8),
                blurRadius: 15,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: -2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: widget.child,
        );

      case StickerThemeType.solidMinimal:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 8,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: widget.child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onScaleStart: (details) {
          _baseScale = _scale;
          _baseRotation = _rotation;
        },
        onScaleUpdate: (details) {
          setState(() {
            _position += details.focalPointDelta;
            _scale = _baseScale * details.scale;
            _rotation = _baseRotation + details.rotation;
          });
        },
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(_scale)
            ..rotateZ(_rotation),
          child: _buildThemedSticker(),
        ),
      ),
    );
  }
}
