/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'package:catage/Login/IntroLoginView.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrVaccineGView extends StatefulWidget {
  final String data;

  QrVaccineGView({@required this.data});

  @override
  State<QrVaccineGView> createState() => _QrVaccineGViewState();
}

class _QrVaccineGViewState extends State<QrVaccineGView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          automaticallyImplyLeading: false, // Desactiva la flecha de devolución
        ),
        backgroundColor: Color.fromARGB(255, 230, 244, 253),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                          text: '¡Compartelo con tu veterinario!',
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
                          text: 'QR de vacunación',
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
              Center(
                child: QrImageView(
                  data: "https://gimomagic.com.co/deep.php/?id=" + widget.data,
                  backgroundColor: Colors.white,
                  version: QrVersions.auto,
                  size: 300.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
