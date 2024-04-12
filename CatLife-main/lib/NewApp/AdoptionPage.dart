import 'package:catage/NewApp/BuildingPage.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../age.dart';
import '../age_human.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({Key key}) : super(key: key);

  @override
  State<AdoptionPage> createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
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
          'Red de Apoyo',
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
                        text: 'Amigos peludos que no tienen un hogar',
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
                        text: 'Han sido lastimados por humanos sin corazón',
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Servicios de apoyo",
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
                  width: 250,
                  padding: EdgeInsets.all(3),
                  child: Column(
                    children: [
                      BubbleSpecialOne(
                        text:
                            'Una serie de ayudas que ponemos al servicio de nuestros amigos peludos más vulnerables',
                        isSender: false,
                        color: Colors.deepOrange,
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
                            builder: (BuildContext context) => BuildingPage(),
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
                            'Felinos en Adopcion',
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
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => BuildingPage(),
                          ),
                        );
                      },
                      icon: Column(
                        children: [
                          Icon(
                            Icons.wifi_tethering_error_rounded_sharp,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text(
                            'Reportar Maltrato',
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
                  width: 250,
                  padding: EdgeInsets.all(3),
                  child: Column(
                    children: [
                      BubbleSpecialOne(
                        text:
                            'Puedes realizar una donación directamente a las fundaciones que tenemos registradas',
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
            Container(
              decoration: BoxDecoration(
                  color: HexColor("08CAF7"),
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.symmetric(horizontal: 45),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "¡Ayudalos!",
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => BuildingPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Donar",
                                style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
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
                  Icon(
                    Icons.medication_liquid_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
