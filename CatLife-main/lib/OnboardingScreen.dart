import 'package:catage/Login.dart';
import 'package:catage/age.dart';
import 'package:catage/View_home.dart';
import 'package:catage/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: Adaptive.h(1.0),
      width: isActive ? Adaptive.w(5.0) : Adaptive.w(3.0),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.deepOrange,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Future<void> guardaValidaOnBoarding(validacion) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('valida', validacion);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.4, 0.7, 0.9],
                  colors: [
                    HexColor("08CAF7"),
                    HexColor("08CAF7"),
                    HexColor("08CAF7"),
                    HexColor("08CAF7"),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: Adaptive.h(80.0),
                      child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: Adaptive.h(5.0),
                                ),
                                Center(
                                  child: SvgPicture.asset(
                                    'images/banner-1.svg',
                                    height: Adaptive.h(40.0),
                                    width: Adaptive.w(40.0),
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      S.of(context).onboardings_text_one,
                                      style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40.0),
                                        child: Text(
                                          S.of(context).onboardings_text_two,
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: Adaptive.h(5.0),
                                ),
                                Center(
                                  child: SvgPicture.asset(
                                    'images/banner-2.svg',
                                    height: Adaptive.h(40.0),
                                    width: Adaptive.w(40.0),
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      S.of(context).onboardings_text_three,
                                      style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40.0),
                                        child: Text(
                                          S.of(context).onboardings_text_four,
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: Adaptive.h(5.0),
                                ),
                                Center(
                                  child: SvgPicture.asset(
                                    'images/banner-3.svg',
                                    height: Adaptive.h(40.0),
                                    width: Adaptive.w(40.0),
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      S.of(context).onboardings_text_five,
                                      style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40.0),
                                        child: Text(
                                          S.of(context).onboardings_text_six,
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                    _currentPage != _numPages - 1 ? Text("") : Text(''),
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: _currentPage == _numPages - 1
              ? Container(
                  height: Adaptive.h(15.0),
                  width: double.infinity,
                  color: HexColor("08CAF7"),
                  child: GestureDetector(
                    onTap: () {
                      guardaValidaOnBoarding('valida');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Home(),
                        ),
                      );
                    },
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            guardaValidaOnBoarding('valida');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(S.of(context).onboardings_text_seven)),
                    ),
                  ),
                )
              : Text(''),
        ),
      );
    });
  }
}
