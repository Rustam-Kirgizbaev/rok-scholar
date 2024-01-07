import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends StatefulWidget {
  @override
  _AdServiceState createState() => _AdServiceState();
}

class _AdServiceState extends State<AdService> {
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  String androidAdUnitID = "ca-app-pub-7684283652391826/8739617298";
  String iOSAdUnitID = "ca-app-pub-7684283652391826/5155595504";

  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
  }

  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isIOS ? iOSAdUnitID : androidAdUnitID,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(error);
          },
        ),
        request: const AdRequest());

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return isAdLoaded
        ? SizedBox(
            height: bannerAd.size.height.toDouble(),
            width: bannerAd.size.width.toDouble(),
            child: AdWidget(ad: bannerAd),
          )
        : const SizedBox();
  }
}
