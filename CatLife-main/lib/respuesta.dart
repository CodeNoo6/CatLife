import 'package:catage/View_home.dart';
import 'package:catage/age.dart';
import 'package:catage/generated/l10n.dart';
import 'package:catage/main.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Respuesta extends StatefulWidget {
  int id;
  Respuesta({this.id});

  @override
  _RespuestaState createState() => _RespuestaState();
}

class _RespuestaState extends State<Respuesta> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
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
                title: Text(
                  'Resultado',
                  style: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 230, 244, 253),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 2, 70),
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
                              text: widget.id == 0
                                  ? S.of(context).home_text_seventeen
                                  : widget.id == 1
                                      ? S.of(context).home_text_eighteen
                                      : widget.id == 2
                                          ? S.of(context).home_text_nineteen
                                          : widget.id == 3
                                              ? S.of(context).home_text_thirty
                                              : widget.id == 4
                                                  ? S
                                                      .of(context)
                                                      .home_text_thirtyone
                                                  : widget.id == 5
                                                      ? S
                                                          .of(context)
                                                          .home_text_thirtytwo
                                                      : widget.id == 6
                                                          ? S
                                                              .of(context)
                                                              .home_text_thirtythree
                                                          : widget.id == 7
                                                              ? S
                                                                  .of(context)
                                                                  .home_text_thirtyfour
                                                              : widget.id == 8
                                                                  ? S
                                                                      .of(
                                                                          context)
                                                                      .home_text_thirtyfive
                                                                  : widget.id ==
                                                                          9
                                                                      ? S
                                                                          .of(
                                                                              context)
                                                                          .home_text_thirtysix
                                                                      : widget.id ==
                                                                              10
                                                                          ? S
                                                                              .of(context)
                                                                              .home_text_thirtyseven
                                                                          : widget.id == 11
                                                                              ? S.of(context).home_text_thirtyeight
                                                                              : S.of(context).home_text_thirtyeight,
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
                ],
              ))),
        );
      },
    );
  }
}
