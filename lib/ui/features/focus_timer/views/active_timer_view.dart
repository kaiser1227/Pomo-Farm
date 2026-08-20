import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../dashboard/widgets/accessory_store_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../dashboard/view_models/pact_dashboard_view_model.dart';
import 'triple_warning_dialog.dart';

const platformKiosk = MethodChannel('com.example.focus_pact/kiosk');

class ActiveTimerView extends StatefulWidget {
  final int targetMinutes;

  const ActiveTimerView({Key? key, required this.targetMinutes}) : super(key: key);

  @override
  State<ActiveTimerView> createState() => _ActiveTimerViewState();
}

class _ActiveTimerViewState extends State<ActiveTimerView> with WidgetsBindingObserver {
  late int _remainingSeconds;
  late int _targetMinutes;
  bool _isSetupMode = true;
  Timer? _timer;
  bool _isShowingDialog = false;
  DateTime? _pausedTime;
  bool _isCompleted = false;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    Wakelock.enable();

    _targetMinutes = widget.targetMinutes;
    _remainingSeconds = _targetMinutes * 60;
    
    _initNotifications();
  }

  void _initNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleCompletionNotification() async {
    final Int32List additionalFlags = Int32List.fromList(<int>[4]);
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'timer_channel_id',
      'Timer Completion',
      channelDescription: 'Alarm for when the timer completes',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      additionalFlags: additionalFlags, // FLAG_INSISTENT
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const IOSNotificationDetails(presentSound: true),
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '집중 완료! 🍅',
      '약속한 시간이 지났습니다. 앱으로 돌아와서 보상을 획득하세요!',
      tz.TZDateTime.now(tz.local).add(Duration(minutes: _targetMinutes)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }

  void _startTimerAndKiosk() {
    setState(() {
      _isSetupMode = false;
      _isCompleted = false;
    });
    _startTimer();
    _scheduleCompletionNotification();

    // 타이머 진입 시 하드코어 화면 고정(Kiosk Mode) 무조건 발동
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (!kIsWeb) {
        try {
          await platformKiosk.invokeMethod('startKioskMode');
        } catch (e) {
          debugPrint('Failed to start kiosk mode: $e');
        }
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _onComplete();
      }
    });
  }

  void _onComplete() async {
    if (_isCompleted) return;
    _isCompleted = true;
    _timer?.cancel();
    _cancelNotification();
    
    FlutterRingtonePlayer.playNotification();
    
    bool isPinned = false;
    if (!kIsWeb) {
      try {
        isPinned = await platformKiosk.invokeMethod('isKioskModeActive') ?? false;
      } catch (e) {
        debugPrint('kiosk check failed');
      }
    } else {
      isPinned = true;
    }

    final vm = context.read<PactDashboardViewModel>();
    
    // 알람 소리 (asAlarm: false로 설정하여 기기의 무음/진동 모드를 존중하도록 함)
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.alarm,
      looping: true,
      asAlarm: false,
    );

    // 실제 진동 발생 (vibration 패키지)
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator == true) {
        Vibration.vibrate(pattern: [500, 1000, 500, 1000, 500, 1000, 500, 1000], repeat: 1);
      }
    });
    
    String message = isPinned 
        ? '토마토 수확을 성공적으로 마쳤습니다 🍅\n보상: 💦 물 $_targetMinutes개'
        : '타이머를 완료했지만 화면 잠금을 허용하지 않아\n보상을 받을 수 없습니다.';

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('수확 완료!', style: TextStyle(color: AppTheme.tomatoRed)),
        content: Text(message, style: const TextStyle(color: AppTheme.textLight)),
        actions: [
          TextButton(
            onPressed: () {
              FlutterRingtonePlayer.stop();
              Vibration.cancel();
              Navigator.pop(context);
            },
            child: const Text('확인', style: TextStyle(color: AppTheme.tomatoRed)),
          ),
        ],
      ),
    );

    vm.completeFocusSession(_targetMinutes, isKioskActive: isPinned);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isPinned ? '🎉 토마토 수확 성공! 💦 물이 추가되었습니다.' : '시간은 채웠지만 화면 잠금 거부로 보상 획득 실패 😢')),
      );
    }
  }

  void _failSession() async {
    _timer?.cancel();
    final vm = context.read<PactDashboardViewModel>();
    
    String consequenceMessage = '⚠️ 몰입 실패. 토마토가 상해버렸어요 🍅💦';
    
    final remainingMinutes = (_remainingSeconds / 60).ceil();
    final penaltyMinutes = remainingMinutes > 0 ? remainingMinutes : 1;
    vm.failFocusSession(penaltyMinutes);
    
    if (!mounted) return;
    
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('약속 위반', style: TextStyle(color: AppTheme.error)),
        content: Text(consequenceMessage, style: const TextStyle(color: AppTheme.textLight)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('확인', style: TextStyle(color: AppTheme.tomatoRed)),
          ),
        ],
      )
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _onGiveUp() async {
    if (_isSetupMode) {
      Navigator.pop(context);
      return;
    }
    _cancelNotification();
    if (_isShowingDialog) return;
    _isShowingDialog = true;
    _timer?.cancel(); // 타이머 잠시 멈춤

    final bool? result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TripleWarningDialog(targetMinutes: _targetMinutes),
    );

    _isShowingDialog = false;

    if (result == true) {
      final vm = context.read<PactDashboardViewModel>();
      if (!kIsWeb && !vm.isPremium) {
        // Load Interstitial Ad before failing
        InterstitialAd.load(
          adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test Interstitial Ad Unit ID
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  _failSession();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  _failSession();
                },
              );
              ad.show();
            },
            onAdFailedToLoad: (err) {
              _failSession();
            },
          ),
        );
      } else {
        _failSession();
      }
    } else {
      // 팝업에서 계속하기(포기 안 함)를 선택한 경우 다시 화면 고정 및 타이머 재개
      _startTimer();
      if (!kIsWeb) {
        try {
          platformKiosk.invokeMethod('startKioskMode');
        } catch (e) {
          debugPrint('Failed to restart kiosk mode: $e');
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isSetupMode) return;
    if (state == AppLifecycleState.paused) {
      if (_remainingSeconds > 0 && _timer?.isActive == true) {
        // 화면이 꺼지는 등 백그라운드로 가면 시간 기록만 남김
        _pausedTime = DateTime.now();
        _timer?.cancel(); // 타이머 중복 실행 방지
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_pausedTime != null) {
        final diffSeconds = DateTime.now().difference(_pausedTime!).inSeconds;
        setState(() {
          _remainingSeconds -= diffSeconds;
        });
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          _onComplete();
        } else {
          _startTimer(); // 타이머 재시작
          // 남은 시간이 있는 채로 돌아왔을 때, 고정이 풀려있다면 나갔다 온 것으로 간주하여 팝업 띄움
          if (!kIsWeb && !_isShowingDialog) {
            platformKiosk.invokeMethod('isKioskModeActive').then((isActive) {
              if (isActive == false) {
                _onGiveUp();
              }
            }).catchError((_) {});
          }
        }
        _pausedTime = null;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    FlutterRingtonePlayer.stop();
    Vibration.cancel();
    Wakelock.disable();
    WidgetsBinding.instance!.removeObserver(this);
    if (!kIsWeb) {
      try {
        platformKiosk.invokeMethod('stopKioskMode');
      } catch (e) {
        debugPrint('Failed to stop kiosk mode: $e');
      }
    }
    // 대시보드로 돌아갈 때 세로 모드로 강제 복구
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _updateTimeFromLocalPosition(Offset local) {
    const double cx = 150;
    const double cy = 150;
    
    final double dx = local.dx - cx;
    final double dy = local.dy - cy;
    
    // Parametric angle for circle (r=150)
    double tAngle = math.atan2(dy, dx);
    double adjustedAngle = tAngle + (math.pi / 2);
    if (adjustedAngle < 0) adjustedAngle += 2 * math.pi;
    
    double percentage = adjustedAngle / (2 * math.pi);
    int mins = (percentage * 120).round();
    if (mins < 1) mins = 1;
    if (mins > 120) mins = 120;
    
    if (mins != _targetMinutes) {
      Vibration.vibrate(duration: 15, amplitude: 60);
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
  }

  void _toggleOrientation(BuildContext context) {
    final current = MediaQuery.of(context).orientation;
    if (current == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onGiveUp();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              final isLandscape = orientation == Orientation.landscape;

              final timeText = Text(
                _isSetupMode 
                  ? '$_targetMinutes:00'
                  : '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontFamily: 'DSEG7',
                  fontSize: isLandscape ? 80 : 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  shadows: const [
                    Shadow(blurRadius: 10.0, color: Colors.cyanAccent, offset: Offset(0, 0)),
                    Shadow(blurRadius: 20.0, color: Colors.cyanAccent, offset: Offset(0, 0)),
                  ],
                ),
              );

              final timerWidget = GestureDetector(
                onPanUpdate: _handlePanUpdate,
                onPanDown: _handlePanDown,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: TomatoPiePainter(
                    percentage: _isSetupMode ? (_targetMinutes / 120.0) : (_remainingSeconds / (_targetMinutes * 60)),
                    isSetupMode: _isSetupMode,
                    equippedAccessory: context.watch<PactDashboardViewModel>().tomatoFarm.equippedAccessory,
                  ),
                ),
              );

              final textAndButtons = Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  timeText,
                  if (_isSetupMode) ...[
                    const SizedBox(height: 8),
                    Text(
                      '예상 획득 물방울: $_targetMinutes개 💧',
                      style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    _isSetupMode ? '시간을 설정해주세요' : '앱을 벗어나면 약속이 깨집니다',
                    style: const TextStyle(color: AppTheme.textGrey, fontSize: 16),
                  ),
                  SizedBox(height: isLandscape ? 24 : 40),
                  _isSetupMode
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소', style: TextStyle(color: AppTheme.textGrey, fontSize: 18)),
                            ),
                            const SizedBox(width: 24),
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
                ],
              );

              return Stack(
                children: [
                  if (isLandscape)
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: timerWidget,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: textAndButtons),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                timerWidget,
                                const SizedBox(height: 32),
                                textAndButtons,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Orientation Toggle Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.screen_rotation, color: Colors.white54, size: 28),
                      onPressed: () => _toggleOrientation(context),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TomatoPiePainter extends CustomPainter {
  final double percentage;
  final bool isSetupMode;
  final String? equippedAccessory;

  TomatoPiePainter({
    required this.percentage,
    required this.isSetupMode,
    this.equippedAccessory,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // 1. 배경 토마토 (그림자 포함)
    Path bgPath = Path()..addOval(rect);
    canvas.drawShadow(bgPath, Colors.black, 15.0, true);
    
    final bgPaint = Paint()..color = const Color(0xFF2A2A2A); // 살짝 밝은 어두운 회색으로 빈 그릇 표현
    canvas.drawPath(bgPath, bgPaint);

    double startAngle = -math.pi / 2;
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

      // 1. 완벽한 원형의 토마토 몸통 그리기
      final tomatoPaint = Paint()..color = AppTheme.tomatoRed;
      // 패딩을 살짝 주어 화면 밖으로 나가지 않게 함
      final radius = (rect.width / 2) - 10;
      canvas.drawCircle(rect.center, radius, tomatoPaint);

      // 1.5. 아날로그 시계 눈금 그리기 (토마토 테두리)
      final tickPaint = Paint()..strokeCap = StrokeCap.round;
      for (int i = 0; i < 60; i++) {
        final angle = (i * 6 * math.pi / 180) - (math.pi / 2);
        final isHour = i % 5 == 0;
        final tickLength = isHour ? 12.0 : 6.0;
        final innerRadius = radius - tickLength;
        
        tickPaint.strokeWidth = isHour ? 3 : 1.5;
        tickPaint.color = isHour ? Colors.white : Colors.white54;
        
        final startPoint = Offset(
          rect.center.dx + innerRadius * math.cos(angle),
          rect.center.dy + innerRadius * math.sin(angle),
        );
        final endPoint = Offset(
          rect.center.dx + radius * math.cos(angle),
          rect.center.dy + radius * math.sin(angle),
        );
        canvas.drawLine(startPoint, endPoint, tickPaint);
      }

      // 2. 토마토 꼭지(잎사귀)
      final leafPaint = Paint()..color = Colors.green[600]!;
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy - radius + 5);
      canvas.rotate(-0.4);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: radius * 0.5, height: 20), leafPaint);
      canvas.rotate(0.8);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: radius * 0.5, height: 20), leafPaint);
      canvas.restore();
      // 꼭지 중앙 덮기
      canvas.drawCircle(Offset(rect.center.dx, rect.center.dy - radius + 10), 10, leafPaint);

      // 3. 기본 얼굴 (눈과 입)
      final facePaint = Paint()..color = Colors.black87;
      // 왼쪽 눈
      canvas.drawCircle(Offset(rect.center.dx - 30, rect.center.dy - 10), 6, facePaint);
      // 오른쪽 눈
      canvas.drawCircle(Offset(rect.center.dx + 30, rect.center.dy - 10), 6, facePaint);
      // 입
      final mouthPath = Path();
      mouthPath.moveTo(rect.center.dx - 15, rect.center.dy + 20);
      mouthPath.quadraticBezierTo(rect.center.dx, rect.center.dy + 35, rect.center.dx + 15, rect.center.dy + 20);
      final mouthStroke = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(mouthPath, mouthStroke);

      // 3. 액세서리 렌더링 (장착된 경우)
      if (equippedAccessory != null) {
        if (equippedAccessory == 'headband') {
          final headbandCenterY = rect.center.dy - 65;
          final headbandRect = RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(rect.center.dx, headbandCenterY), width: 180, height: 40),
            const Radius.circular(6),
          );
          
          // Draw headband background (white with red border)
          canvas.drawRRect(headbandRect, Paint()..color = Colors.white);
          canvas.drawRRect(headbandRect, Paint()..color = Colors.red..style = PaintingStyle.stroke..strokeWidth = 3);
          
          // Draw "🔥 열공 🔥" text
          const textSpan = TextSpan(
            text: '🔥 열공 🔥',
            style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(rect.center.dx - (textPainter.width / 2), headbandCenterY - (textPainter.height / 2)),
          );
        } else {
          String emoji = '';
          double scale = 1.0;
          double offsetY = 0.0;
          double offsetX = 0.0;
          
          final accessory = AccessoryStoreWidget.accessories.firstWhere((acc) => acc['id'] == equippedAccessory, orElse: () => {});
          if (accessory.isNotEmpty) {
            emoji = accessory['emoji'] as String;
            scale = (accessory['scale'] as num).toDouble();
            offsetY = (accessory['offsetY'] as num).toDouble();
            offsetX = (accessory['offsetX'] as num?)?.toDouble() ?? 0.0;
          }
          
          final accSpan = TextSpan(
            text: emoji,
            style: TextStyle(fontSize: 120 * scale),
          );
          final accPainter = TextPainter(
            text: accSpan,
            textDirection: TextDirection.ltr,
          );
          accPainter.layout();
          
          final accOffset = Offset(
            rect.center.dx - (accPainter.width / 2) + offsetX,
            rect.center.dy - (accPainter.height / 2) + offsetY,
          );
          accPainter.paint(canvas, accOffset);
        }
      }

      canvas.restore();
    }

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

  @override
  bool shouldRepaint(covariant TomatoPiePainter oldDelegate) {
    return oldDelegate.percentage != percentage || 
           oldDelegate.isSetupMode != isSetupMode ||
           oldDelegate.equippedAccessory != equippedAccessory;
  }
}
