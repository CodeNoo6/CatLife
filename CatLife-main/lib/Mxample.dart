/*import 'package:catage/AdHelper.dart';
import 'package:catage/NewsDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // TODO: Load an ad
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        // TODO: Adjust itemCount based on the ad load state
        itemCount: 3,
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (_isAdLoaded) {
            return Container(
              child: AdWidget(ad: _ad),
              width: _ad.size.width.toDouble(),
              height: 72.0,
              alignment: Alignment.center,
            );
          } else {}
        },
      ),
    );
  }
}
*/