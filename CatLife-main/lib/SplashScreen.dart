import 'dart:async';
import 'package:catage/Login.dart';
import 'package:catage/NewApp/IntroPage.dart';
import 'package:catage/NewApp/MenuPage.dart';
import 'package:catage/OnboardingScreen.dart';
import 'package:catage/View_home.dart';
import 'package:catage/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

String valida;

validaOnBoarding() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  valida = pref.getString('valida');
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Future<void> initState() {
    validaOnBoarding();
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    valida == null ? IntroPage() : MenuPage(),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          backgroundColor: HexColor("08CAF7"),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'images/logo.svg',
                            height: Adaptive.h(30.0),
                            width: Adaptive.w(30.0),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Text("Cat Life",
                              style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
