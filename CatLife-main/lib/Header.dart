import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authenticator/Authenticator.dart';

class Header extends StatefulWidget {
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final controller = Get.put(Authenticator());

  /*String nombre;

  Future<Null> validaNombre() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nombre = prefs.getString("nombre");
  }

  @override
  Future<void> initState() {
    super.initState();
    nombre = "";
    validaNombre();
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SliverList(
        delegate: SliverChildListDelegate(
      [
        Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  height: 25.0.h,
                  decoration: BoxDecoration(
                      color: HexColor("08CAF7"),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(45),
                      ),
                      boxShadow: [BoxShadow(blurRadius: 2)]),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 80),
                              child: CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 35,
                                child: CircleAvatar(
                                  radius: 30,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/logo.png'),
                                    radius: 30,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                /*Text(
                                  S.of(context).home_text_fourtyone ?? "",
                                  style: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),*/
                                Container(
                                    width: 48.0.w,
                                    padding: EdgeInsets.all(3),
                                    child: Column(
                                      children: [
                                        BubbleSpecialOne(
                                          text: '¡Hola!',
                                          isSender: false,
                                          color: Colors.yellow[800],
                                          textStyle: GoogleFonts.aBeeZee(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                        BubbleSpecialOne(
                                          text:
                                              'Ahora tienes un carné virtual de tu gato para registrar sus vacunas y medicinas',
                                          isSender: false,
                                          color: Colors.white,
                                          textStyle: GoogleFonts.aBeeZee(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                /*Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black54),
                                  child: Text("" ?? "",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: queryData.size.width / 30,
                                        ),
                                      )),
                                ),*/
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            /*Positioned(
              bottom: 0,
              child: Container(
                height: 50,
                width: size.width,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "What does your belly want to eat?",
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.only(left: 20)
                    ),
                  ),
                ),
              ),
            )*/
          ],
        ),
      ],
    ));
  }
}
