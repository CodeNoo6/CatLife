import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class BuildingPage extends StatefulWidget {
  const BuildingPage({Key key}) : super(key: key);

  @override
  State<BuildingPage> createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 244, 253),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.grey[900],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'En construcción',
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Desactiva la flecha de devolución
      ),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 2, 120),
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
                  width: 250,
                  padding: EdgeInsets.all(3),
                  child: Column(
                    children: [
                      BubbleSpecialOne(
                        text: '¡Lo siento!',
                        isSender: false,
                        color: HexColor("08CAF7"),
                        textStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      BubbleSpecialOne(
                        text: 'Estamos en construcción de esta funcionalidad',
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
                        text: '¡Muy pronto estará disponible!',
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
          ])),
    );
  }
}
