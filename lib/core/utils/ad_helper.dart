import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  /// 배너 광고 단위 ID (Banner Ad Unit ID)
  static String get bannerAdUnitId {
    if (kDebugMode) {
      // 개발 및 디버그 모드에서는 Google 공식 테스트 배너 ID 사용
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }

    // 릴리즈/프로덕션 빌드 시 실제 배너 광고 ID 사용
    if (Platform.isAndroid) {
      return 'ca-app-pub-7996508643839776/4888850193';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7996508643839776/4888850193';
    } else {
      throw UnsupportedError('지원하지 않는 플랫폼입니다.');
    }
  }

  /// 전면 광고 단위 ID (Interstitial Ad Unit ID)
  static String get interstitialAdUnitId {
    if (kDebugMode) {
      // 개발 및 디버그 모드에서는 Google 공식 테스트 전면 광고 ID 사용
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910';
      }
    }

    // 릴리즈/프로덕션 빌드 시 실제 전면 광고 ID 사용
    if (Platform.isAndroid) {
      return 'ca-app-pub-7996508643839776/2346447337';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7996508643839776/2346447337';
    } else {
      throw UnsupportedError('지원하지 않는 플랫폼입니다.');
    }
  }

  /// 전면 광고 로드 및 표시 유틸리티 함수
  static void loadAndShowInterstitialAd({
    required VoidCallback onAdClosed,
  }) {
    if (kIsWeb) {
      onAdClosed();
      return;
    }

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              onAdClosed();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              ad.dispose();
              onAdClosed();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          onAdClosed();
        },
      ),
    );
  }
}
