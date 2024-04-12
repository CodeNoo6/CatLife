import 'package:catage/age.dart';
import 'package:catage/age_human.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class UtilitiePage extends StatefulWidget {
  const UtilitiePage({Key key}) : super(key: key);

  @override
  State<UtilitiePage> createState() => _UtilitiePageState();
}

class _UtilitiePageState extends State<UtilitiePage> {
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
          'Utilidades',
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
                  padding: EdgeInsets.fromLTRB(10, 10, 2, 80),
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
                        text: '¡Bienvenido a Utilidades!',
                        isSender: false,
                        color: Colors.yellow[800],
                        textStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      BubbleSpecialOne(
                        text: 'Aquí podras realizar calculos de edades',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Calculo de edades",
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 2, 90),
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
                        text:
                            'Edad Felina: es el calculo de los años de tu amigo peludo',
                        isSender: false,
                        color: Colors.deepOrange,
                        textStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      BubbleSpecialOne(
                        text:
                            'Edad Humana: es el calculo de los años de tu amigo peludo en edad humana',
                        isSender: false,
                        color: Colors.green,
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
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Age(),
                          ),
                        );
                      },
                      icon: Column(
                        children: [
                          Icon(
                            Icons.pets,
                            color: Colors.deepOrange,
                            size: 30,
                          ),
                          Text(
                            'Edad Felina',
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      label: Text(
                        '', //'Label',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Age_Human(),
                          ),
                        );
                      },
                      icon: Column(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text(
                            'Edad Humana',
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      label: Text(
                        '', //'Label',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
