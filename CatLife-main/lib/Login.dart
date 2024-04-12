import 'package:catage/Authenticator/Authenticator.dart';
import 'package:catage/Database/Database.dart';
import 'package:catage/NewApp/MenuPage.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utilities/Utilities.dart';
import 'View_home.dart';
import 'generated/l10n.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.put(Authenticator());
  final Color primaryColor = HexColor("08CAF7");
  final Color secondaryColor = HexColor("08CAF7");

  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: primaryColor,
          body: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'images/logo.svg',
                    height: 180.0,
                    width: 180.0,
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("Cat Life",
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      )),
                  SizedBox(height: 20),
                  Text(
                    'Con el fin de brindarte la mejor experiencia puedes iniciar sesión',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    elevation: 0,
                    minWidth: double.maxFinite,
                    height: 50,
                    onPressed: () async {
                      await controller.login();
                      await Utilities.guardaCorreo(
                          controller.googleAccount.value.email);
                      //Database.crearUsuario();
                      Database.validaRegistro();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MenuPage(),
                        ),
                      );
                    },
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.google),
                        SizedBox(width: 10),
                        Text(
                          'Ingresar con Google',
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    textColor: Colors.white,
                  ),
                  //Text(controller.googleAccount.value?.email ?? ""),
                ],
              ),
            ),
          )),
    );
  }
}
