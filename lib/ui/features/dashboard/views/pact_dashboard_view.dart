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
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_theme.dart';
import '../../../core/widgets/time_bank_card.dart';
import '../widgets/tomato_farm_widget.dart';
import '../widgets/accessory_store_widget.dart';
import 'sticker_editor_view.dart';
import '../view_models/pact_dashboard_view_model.dart';
import '../../focus_timer/views/active_timer_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/utils/ad_helper.dart';

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
        title: Row(
          children: [
            Icon(Icons.eco, color: AppTheme.textLight, size: 24),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.tutorialTitle, style: const TextStyle(color: AppTheme.textLight)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.looks_one, color: AppTheme.tomatoRed, size: 20),
                  const SizedBox(width: 4),
                  Text(AppLocalizations.of(context)!.tutorialStep1Title, style: const TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Icon(Icons.opacity, color: AppTheme.tomatoRed, size: 20),
                ],
              ),
              Text(AppLocalizations.of(context)!.tutorialStep1Desc, style: const TextStyle(color: AppTheme.textGrey)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.looks_two, color: AppTheme.tomatoRed, size: 20),
                  const SizedBox(width: 4),
                  Text(AppLocalizations.of(context)!.tutorialStep2Title, style: const TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Icon(Icons.spa, color: AppTheme.tomatoRed, size: 20),
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: AppLocalizations.of(context)!.tutorialStep2Desc1),
                    const WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.local_fire_department, color: AppTheme.textGrey, size: 14)),
                    TextSpan(text: AppLocalizations.of(context)!.tutorialStep2Desc2),
                  ]
                ),
                style: const TextStyle(color: AppTheme.textGrey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.looks_3, color: AppTheme.tomatoRed, size: 20),
                  const SizedBox(width: 4),
                  Text(AppLocalizations.of(context)!.tutorialStep3Title, style: const TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Icon(Icons.monetization_on, color: AppTheme.tomatoRed, size: 20),
                ],
              ),
              Text(AppLocalizations.of(context)!.tutorialStep3Desc, style: const TextStyle(color: AppTheme.textGrey)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.looks_4, color: AppTheme.tomatoRed, size: 20),
                  const SizedBox(width: 4),
                  Text(AppLocalizations.of(context)!.tutorialStep4Title, style: const TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Icon(Icons.checkroom, color: AppTheme.tomatoRed, size: 20),
                ],
              ),
              Text(AppLocalizations.of(context)!.tutorialStep4Desc, style: const TextStyle(color: AppTheme.textGrey)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (isInitial) vm.markTutorialAsSeen();
              Navigator.pop(context);
            },
            child: Text(isInitial ? AppLocalizations.of(context)!.tutorialStart : AppLocalizations.of(context)!.confirm, style: const TextStyle(color: AppTheme.tomatoRed)),
          ),
        ],
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
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
                  title: Text(AppLocalizations.of(context)!.imageGallery, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: AppTheme.tomatoRed),
                  title: Text(AppLocalizations.of(context)!.imageCamera, style: const TextStyle(color: Colors.white, fontSize: 18)),
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
          SnackBar(content: Text(AppLocalizations.of(context)!.shareFailedMessage)),
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
              SnackBar(content: Text(AppLocalizations.of(context)!.webShareNotSupported)),
            );
          }
        } else {
          final directory = await getTemporaryDirectory();
          final imagePath = await File('${directory.path}/pomo_farm_share.png').create();
          await imagePath.writeAsBytes(imageBytes);
          await Share.shareXFiles([XFile(imagePath.path, mimeType: 'image/png')], text: AppLocalizations.of(context)!.shareDefaultText);
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
          title: Row(
            children: [
              const Icon(Icons.star, color: AppTheme.tomatoRed, size: 24),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.premiumTitle, style: const TextStyle(color: AppTheme.tomatoRed)),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.premiumComingSoonText,
            style: const TextStyle(color: AppTheme.textLight, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(context)!.confirm, style: const TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
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
        title: Row(
          children: [
            const Icon(Icons.star, color: AppTheme.textLight, size: 24),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.premiumTestTitle, style: const TextStyle(color: AppTheme.textLight)),
          ],
        ),
        content: Text(
          isPrem ? AppLocalizations.of(context)!.premiumTestDeactivateDesc : AppLocalizations.of(context)!.premiumTestActivateDesc,
          style: const TextStyle(color: AppTheme.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppTheme.textGrey)),
          ),
          TextButton(
            onPressed: () {
              viewModel.togglePremium();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      if (viewModel.isPremium) const Icon(Icons.star, color: Colors.amber, size: 18),
                      if (viewModel.isPremium) const SizedBox(width: 4),
                      Text(viewModel.isPremium ? AppLocalizations.of(context)!.premiumActivatedMessage : AppLocalizations.of(context)!.premiumDeactivatedMessage),
                    ],
                  ),
                ),
              );
            },
            child: Text(isPrem ? AppLocalizations.of(context)!.deactivatePremium : AppLocalizations.of(context)!.buyPremium, style: const TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
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
                      SnackBar(content: Text(AppLocalizations.of(context)!.devModeActivated)),
                    );
                  }
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.settings, color: AppTheme.textLight, size: 24),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.settingsTitle, style: const TextStyle(color: AppTheme.textLight)),
                ],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.settingsWarningDesc,
                  style: const TextStyle(color: AppTheme.textGrey, height: 1.5),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.privacy_tip, color: AppTheme.textGrey, size: 20),
                  title: const Text('개인정보 처리방침', style: TextStyle(color: AppTheme.textLight, fontSize: 14)),
                  trailing: const Icon(Icons.open_in_new, color: AppTheme.textGrey, size: 16),
                  onTap: () async {
                    const url = 'https://raw.githubusercontent.com/kaiser1227/Pomo-Farm/main/PRIVACY_POLICY.md';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    }
                  },
                ),
                if (isSecretUnlocked) ...[
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.tomatoRed,
                    title: Text(AppLocalizations.of(context)!.adminModeTitle, style: const TextStyle(color: AppTheme.textLight)),
                    subtitle: Text(AppLocalizations.of(context)!.adminModeDesc, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
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
                child: Text(AppLocalizations.of(context)!.resetDataBtn, style: const TextStyle(color: AppTheme.error)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppLocalizations.of(context)!.confirm, style: const TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
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
        title: Row(
          children: [
            const Icon(Icons.warning, color: AppTheme.error, size: 24),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.resetDataTitle, style: const TextStyle(color: AppTheme.error)),
          ],
        ),
        content: Text(AppLocalizations.of(context)!.resetDataWarning, style: const TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppTheme.textGrey)),
          ),
          TextButton(
            onPressed: () {
              vm.resetData();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.dataResetSuccess)),
              );
            },
            child: Text(AppLocalizations.of(context)!.resetAction, style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold)),
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
              children: [
                Image.asset('assets/images/tomato_stage_6.png', height: 28),
                const SizedBox(width: 8),
                const Text(
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
                    tooltip: AppLocalizations.of(context)!.premiumSettingsTooltip,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.share, color: Colors.white, size: 22),
                    onPressed: () => _takeScreenshotAndShare(viewModel),
                    tooltip: AppLocalizations.of(context)!.shareTooltip,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.settings, color: Colors.white, size: 22),
                    onPressed: _showSettingsDialog,
                    tooltip: AppLocalizations.of(context)!.settingsTooltip,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
          body: Screenshot(
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/tomato_stage_6.png', width: 24, height: 24),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.startPomodoroTimer,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
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
          bottomNavigationBar: (!kIsWeb && !viewModel.isPremium && _isBannerAdLoaded && _bannerAd != null)
              ? Container(
                  color: AppTheme.backgroundDark,
                  child: SafeArea(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: _bannerAd!.size.height.toDouble(),
                      child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
