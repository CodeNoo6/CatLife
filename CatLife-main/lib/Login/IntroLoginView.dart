import 'package:catage/Login/LoginView.dart';
import 'package:catage/Login/RegistryView.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../NewApp/GuestHomePage.dart';

class IntroLoginView extends StatefulWidget {
  const IntroLoginView({Key key}) : super(key: key);

  @override
  State<IntroLoginView> createState() => _IntroLoginViewState();
}

class _IntroLoginViewState extends State<IntroLoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 244, 253),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 2, 60),
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 35,
                    child: CircleAvatar(
                      radius: 30,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/logo.png'),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  padding: EdgeInsets.all(3),
                  child: Column(
                    children: [
                      BubbleSpecialOne(
                        text:
                            'Para tu comienzo en mi app puedes hacer lo siguiente:',
                        isSender: false,
                        color: HexColor("08CAF7"),
                        textStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginView(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("EC6337"),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Iniciar Sesión",
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => RegistryView(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: HexColor("EC6337")), // Agrega un borde
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Registrarse",
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor(
                              "EC6337"), // Cambia el color del texto al color del borde
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => GuestHomePage(),
                      ),
                    );
                  },
                  child: Text(
                    "Continuar como invitado",
                    style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .blue, // Cambia el color del texto al color del borde
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
