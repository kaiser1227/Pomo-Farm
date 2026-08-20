import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/streak_badge.dart';
import '../../../core/widgets/time_bank_card.dart';
import '../widgets/draggable_sticker.dart';

import '../view_models/pact_dashboard_view_model.dart';

enum ImageFilterType { original, sepia, grayscale }

class StickerEditorView extends StatefulWidget {
  final String backgroundImagePath;
  final PactDashboardViewModel viewModel;

  const StickerEditorView({
    Key? key,
    required this.backgroundImagePath,
    required this.viewModel,
  }) : super(key: key);

  @override
  _StickerEditorViewState createState() => _StickerEditorViewState();
}

class _StickerEditorViewState extends State<StickerEditorView> {
  final ScreenshotController _screenshotController = ScreenshotController();
  StickerThemeType _currentTheme = StickerThemeType.glassmorphism;
  ImageFilterType _currentImageFilter = ImageFilterType.sepia;
  bool _isProcessing = false;

  bool _showTitle = true;
  bool _showToday = true;
  bool _showMonth = true;
  bool _showTotal = true;

  int _getMonthlyMinutes(PactDashboardViewModel viewModel) {
    final now = DateTime.now();
    final monthPrefix = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    int total = 0;
    viewModel.focusHistory.dailyRecords.forEach((key, value) {
      if (key.startsWith(monthPrefix)) {
        total += value;
      }
    });
    return total;
  }

  int _getTotalMinutes(PactDashboardViewModel viewModel) {
    int total = 0;
    viewModel.focusHistory.dailyRecords.forEach((key, value) {
      total += value;
    });
    return total;
  }

  Widget _buildStatSticker(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStickerToggle(String label, bool isVisible, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!isVisible),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isVisible ? AppTheme.tomatoRed : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.tomatoRed, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isVisible ? Colors.black : AppTheme.tomatoRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _shareFinalImage() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // 렌더링 대기 시간 증가
      final imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 500),
      );

      if (imageBytes == null) {
        throw Exception('캡처 이미지가 비어 있습니다.');
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imageFile = await File(directory.path + '/focus_share_' + timestamp.toString() + '.png').create(recursive: true);
      await imageFile.writeAsBytes(imageBytes);
      
      await Share.shareXFiles([XFile(imageFile.path, mimeType: 'image/png')], text: '나의 토마토 수확 성과를 확인해보세요! 🍅');
      
    } catch (e) {
      debugPrint('Share failed: \$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('공유 실패: ' + e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('사진 꾸미기', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: _isProcessing ? null : _shareFinalImage,
                    child: _isProcessing 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.tomatoRed))
                        : const Text('공유', style: TextStyle(color: AppTheme.tomatoRed, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            // Editable Area
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(5, 10),
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        // 사진은 지정된 여백 안쪽에 위치
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 80),
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: _buildFilteredImage(),
                          ),
                        ),
                        
                        // Title Sticker
                        if (_showTitle)
                          DraggableSticker(
                            theme: _currentTheme,
                            initialPosition: const Offset(40, 60),
                            child: const Text('🍅 Pomo Farm', style: TextStyle(color: AppTheme.tomatoRed, fontSize: 32, fontWeight: FontWeight.bold)),
                          ),
                        
                        // Today Sticker
                        if (_showToday)
                          DraggableSticker(
                            theme: _currentTheme,
                            initialPosition: const Offset(40, 150),
                            child: _buildStatSticker('오늘 집중시간', '${widget.viewModel.todayFocusMinutes}분'),
                          ),
                        
                        // Monthly Sticker
                        if (_showMonth)
                          DraggableSticker(
                            theme: _currentTheme,
                            initialPosition: const Offset(200, 150),
                            child: _buildStatSticker('이번달 집중시간', '${_getMonthlyMinutes(widget.viewModel)}분'),
                          ),

                        // Total Sticker
                        if (_showTotal)
                          DraggableSticker(
                            theme: _currentTheme,
                            initialPosition: const Offset(40, 300),
                            child: _buildStatSticker('총 집중시간', '${_getTotalMinutes(widget.viewModel)}분'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom Controls Area
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.black,
              child: Column(
                children: [
                  // Sticker Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('스티커:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(width: 12),
                        _buildStickerToggle('타이틀', _showTitle, (val) => setState(() => _showTitle = val)),
                        _buildStickerToggle('오늘', _showToday, (val) => setState(() => _showToday = val)),
                        _buildStickerToggle('월간', _showMonth, (val) => setState(() => _showMonth = val)),
                        _buildStickerToggle('총합', _showTotal, (val) => setState(() => _showTotal = val)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Image Filter Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('사진 느낌:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(width: 12),
                        _buildImageFilterOption(ImageFilterType.original, '원본'),
                        _buildImageFilterOption(ImageFilterType.sepia, '빈티지'),
                        _buildImageFilterOption(ImageFilterType.grayscale, '흑백'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sticker Theme Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('스티커 테마:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(width: 12),
                        _buildThemeOption(StickerThemeType.glassmorphism, 'Glass'),
                        _buildThemeOption(StickerThemeType.neonGlow, 'Neon'),
                        _buildThemeOption(StickerThemeType.solidMinimal, 'Solid'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredImage() {
    // 배경은 폴라로이드 안쪽에 꽉 차지 않을 경우를 대비해 약간 밝은 회색으로 설정
    final image = Container(
      color: const Color(0xFFF0F0F0),
      child: Image.file(
        File(widget.backgroundImagePath), 
        fit: BoxFit.contain, // 사진이 잘리지 않도록 contain 적용
      ),
    );
    
    switch (_currentImageFilter) {
      case ImageFilterType.original:
        return image;
      case ImageFilterType.sepia:
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.393, 0.769, 0.189, 0, 20,
            0.349, 0.686, 0.168, 0, 10,
            0.272, 0.534, 0.131, 0,  0,
            0,     0,     0,     1,  0,
          ]),
          child: image,
        );
      case ImageFilterType.grayscale:
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0,      0,      0,      1, 0,
          ]),
          child: image,
        );
    }
  }

  Widget _buildImageFilterOption(ImageFilterType filter, String label) {
    final isSelected = _currentImageFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentImageFilter = filter;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(StickerThemeType theme, String label) {
    final isSelected = _currentTheme == theme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTheme = theme;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.tomatoRed : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.tomatoRed, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : AppTheme.tomatoRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
