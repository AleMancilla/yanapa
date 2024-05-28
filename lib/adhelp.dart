import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:yanapa/core/utils/admob_controller.dart';
// class AdHelper {
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/6300978111";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-2515797554946271/3073592140";
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/1033173712";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/5135589800";
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }
// }

class AdHelper {
  static String get bannerAdUnitId => 'ca-app-pub-3940256099942544/6300978111';
  static String get interstitialAdUnitId =>
      'ca-app-pub-3940256099942544/1033173712';
}

class MyAdWidget extends StatelessWidget {
  final BannerAd bannerAd;

  MyAdWidget({Key? key})
      : bannerAd = AdMobController().createBannerAd(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdWidget(ad: bannerAd);
  }
}
