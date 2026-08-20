import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/app_theme.dart';
import '../../../core/widgets/time_bank_card.dart';
import '../widgets/tomato_farm_widget.dart';
import '../widgets/inventory_store_widget.dart';
import '../widgets/accessory_store_widget.dart';
import 'sticker_editor_view.dart';
import '../view_models/pact_dashboard_view_model.dart';
import '../../focus_timer/views/active_timer_view.dart';

class PactDashboardView extends StatefulWidget {
  const PactDashboardView({Key? key}) : super(key: key);

  @override
  State<PactDashboardView> createState() => _PactDashboardViewState();
}

class _PactDashboardViewState extends State<PactDashboardView> with WidgetsBindingObserver {
  final ScreenshotController _screenshotController = ScreenshotController();
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    if (!kIsWeb) {
      _loadBannerAd();
    }
    
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final vm = context.read<PactDashboardViewModel>();
      if (!vm.hasSeenTutorial) {
        _showTutorialDialog(vm, isInitial: true);
      }
    });
  }

  void _showTutorialDialog(PactDashboardViewModel vm, {bool isInitial = false}) {
    showDialog(
      context: context,
      barrierDismissible: !isInitial,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('농장 이용 가이드 🍅', style: TextStyle(color: AppTheme.textLight)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('1️⃣ 집중해서 물방울 얻기 💧', style: TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
              Text('타이머를 설정하고 끝까지 완주하면 1분당 1개의 물방울을 얻습니다.', style: TextStyle(color: AppTheme.textGrey)),
              SizedBox(height: 12),
              Text('2️⃣ 물로 토마토 키우기 🌱', style: TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
              Text('모은 물방울을 주면 토마토가 쑥쑥 자라납니다.\n(🔥 연속 출석 일수가 높을수록 성장이 빨라집니다!)', style: TextStyle(color: AppTheme.textGrey)),
              SizedBox(height: 12),
              Text('3️⃣ 토마토 수확 후 자산 획득 💰', style: TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
              Text('토마토를 상점에 판매하면 1개당 1,000원의 자산(돈)을 획득합니다.', style: TextStyle(color: AppTheme.textGrey)),
              SizedBox(height: 12),
              Text('4️⃣ 자산으로 아이템 장착 🕶️', style: TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
              Text('모은 자산으로 귀여운 상점 아이템을 구매해 나만의 토마토를 꾸며보세요!', style: TextStyle(color: AppTheme.textGrey)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (isInitial) vm.markTutorialAsSeen();
              Navigator.pop(context);
            },
            child: Text(isInitial ? '시작하기' : '확인', style: const TextStyle(color: AppTheme.tomatoRed)),
          ),
        ],
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test Banner Ad Unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<PactDashboardViewModel>().refreshData();
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppTheme.tomatoRed),
                  title: const Text('갤러리에서 선택', style: TextStyle(color: Colors.white, fontSize: 18)),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: AppTheme.tomatoRed),
                  title: const Text('카메라로 촬영', style: TextStyle(color: Colors.white, fontSize: 18)),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _takeScreenshotAndShare(PactDashboardViewModel viewModel) async {
    try {
      final ImageSource? source = await _showImageSourceDialog();
      if (source == null) return; // User cancelled

      final ImagePicker picker = ImagePicker();
      // 카메라/갤러리 이미지 용량과 해상도를 줄여 디코딩 속도 향상
      final XFile? photo = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        imageQuality: 85,
      );
      
      if (photo != null) {
        // Use path instead of reading all bytes into memory to prevent OOM crashes
        final String photoPath = photo.path;
        
        // Navigate to the sticker editor view
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StickerEditorView(
              backgroundImagePath: photoPath,
              viewModel: viewModel,
            ),
          ),
        );

      } else {
        // Fallback to dashboard screenshot if no photo taken
        final imageBytes = await _screenshotController.capture();
        await _shareImageBytes(imageBytes);
      }
    } catch (e) {
      debugPrint('Screenshot or Share failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('공유하기에 실패했습니다. (카메라 권한 또는 환경 문제)')),
        );
      }
    }
  }

  Future<void> _shareImageBytes(dynamic imageBytes) async {
    try {
      if (imageBytes != null) {
        if (kIsWeb) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('웹 브라우저에서는 이미지 공유 기능이 지원되지 않습니다.')),
            );
          }
        } else {
          final directory = await getTemporaryDirectory();
          final imagePath = await File('${directory.path}/focus_pact_share.png').create();
          await imagePath.writeAsBytes(imageBytes);
          await Share.shareXFiles([XFile(imagePath.path, mimeType: 'image/png')], text: '나의 토마토 수확 성과를 확인해보세요! 🍅');
        }
      }
    } catch (e) {
      debugPrint('Share bytes failed: $e');
    }
  }

  void _showPremiumDialog(BuildContext context, PactDashboardViewModel viewModel) {
    final isPrem = viewModel.isPremium;
    
    // 일반 사용자에게는 출시 준비 중 알림 표시
    if (!viewModel.isAdminMode) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text('👑 프리미엄 (광고 제거)', style: TextStyle(color: AppTheme.tomatoRed)),
          content: const Text(
            '프리미엄 광고 제거 기능은 현재 열심히 준비 중입니다!\n\n다음 업데이트(V1.1)에서 정식으로 찾아뵙겠습니다. 조금만 기다려주세요 😊',
            style: TextStyle(color: AppTheme.textLight, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('확인', style: TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

    // 관리자 모드일 때는 기능 테스트용 토글 허용
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('👑 프리미엄 구매 (테스트)', style: TextStyle(color: AppTheme.textLight)),
        content: Text(
          isPrem ? '프리미엄을 해제하시겠습니까?' : '광고 없는 쾌적한 몰입을 원하시나요?\n(관리자 전용 테스트)',
          style: const TextStyle(color: AppTheme.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소', style: TextStyle(color: AppTheme.textGrey)),
          ),
          TextButton(
            onPressed: () {
              viewModel.togglePremium();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(viewModel.isPremium ? '👑 프리미엄 모드가 활성화되었습니다! (광고 제거)' : '프리미엄 모드가 해제되어 다시 광고가 표시됩니다.')),
              );
            },
            child: Text(isPrem ? '해제하기' : '구매하기', style: const TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    final vm = context.read<PactDashboardViewModel>();
    int tapCount = 0;
    bool isSecretUnlocked = vm.isAdminMode;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppTheme.surfaceDark,
            title: GestureDetector(
              onTap: () {
                if (!isSecretUnlocked) {
                  tapCount++;
                  if (tapCount >= 7) {
                    setState(() {
                      isSecretUnlocked = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('개발자 모드가 활성화되었습니다.')),
                    );
                  }
                }
              },
              child: const Text('⚙️ 설정 및 안내', style: TextStyle(color: AppTheme.textLight)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pomo Farm은 기기 내부에 데이터를 안전하게 저장합니다.\n\n'
                  '⚠️ 앱을 삭제하시면 소중하게 키운 토마토 농장과 보상 데이터가 모두 초기화되니 주의해주세요!',
                  style: TextStyle(color: AppTheme.textGrey, height: 1.5),
                ),
                if (isSecretUnlocked) ...[
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.tomatoRed,
                    title: const Text('관리자 모드 (테스트용)', style: TextStyle(color: AppTheme.textLight)),
                    subtitle: const Text('ON: 데이터 만땅, OFF: 초기화', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                    value: vm.isAdminMode,
                    onChanged: (val) {
                      setState(() {
                        vm.toggleAdminMode(val);
                      });
                    },
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showResetConfirmDialog(vm);
                },
                child: const Text('데이터 초기화', style: TextStyle(color: AppTheme.error)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('확인', style: TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showResetConfirmDialog(PactDashboardViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('🚨 데이터 초기화', style: TextStyle(color: AppTheme.error)),
        content: const Text('모든 농장 데이터와 보상이 사라집니다.\n정말 초기화 하시겠습니까?', style: TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소', style: TextStyle(color: AppTheme.textGrey)),
          ),
          TextButton(
            onPressed: () {
              vm.resetData();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('데이터가 초기화되었습니다.')),
              );
            },
            child: const Text('초기화', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<PactDashboardViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.help_outline, color: AppTheme.textGrey),
              onPressed: () => _showTutorialDialog(viewModel),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('🍅', style: TextStyle(fontSize: 24)),
                SizedBox(width: 8),
                Text(
                  'Pomo Farm',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: AppTheme.tomatoRed,
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.star, color: viewModel.isPremium ? AppTheme.tomatoRed : Colors.grey, size: 22),
                    onPressed: () => _showPremiumDialog(context, viewModel),
                    tooltip: '프리미엄 설정',
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.share, color: Colors.white, size: 22),
                    onPressed: () => _takeScreenshotAndShare(viewModel),
                    tooltip: '자랑하기',
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.settings, color: Colors.white, size: 22),
                    onPressed: _showSettingsDialog,
                    tooltip: '설정',
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    color: AppTheme.backgroundDark, // For screenshot background
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [

                                    const SizedBox(height: 16),
                                    TimeBankCard(viewModel: viewModel),
                                    const SizedBox(height: 16),
                                    TomatoFarmWidget(viewModel: viewModel),
                                    const Spacer(),
                                    InventoryStoreWidget(viewModel: viewModel),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppTheme.tomatoRed,
                                        onPrimary: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const ActiveTimerView(targetMinutes: 25)),
                                        );
                                      },
                                      child: const Text(
                                        '🍅 뽀모도로 타이머 시작하기',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    AccessoryStoreWidget(viewModel: viewModel),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (!kIsWeb && !viewModel.isPremium && _isBannerAdLoaded && _bannerAd != null)
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
        );
      },
    );
  }
}
