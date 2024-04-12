import 'package:catage/Login.dart';
import 'package:catage/Login/IntroLoginView.dart';
import 'package:catage/NewApp/MenuPage.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

Future<void> guardaValidaOnBoarding(validacion) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString('valida', validacion);
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("08CAF7"),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 2, 100),
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
                        text: '¡Hola!, Soy tu asistente felino',
                        isSender: false,
                        color: Colors.white,
                        textStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      BubbleSpecialOne(
                        text: 'Te ayudaré en el bienestar de tu amigo peludo',
                        isSender: false,
                        color: Colors.white,
                        textStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                guardaValidaOnBoarding('valida');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => IntroLoginView(),
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
                      "Comenzar ahora",
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
