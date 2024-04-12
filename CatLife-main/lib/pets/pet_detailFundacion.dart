import 'dart:convert';

import 'package:catage/Modelo/Fundacion.dart';
import 'package:catage/Modelo/Gato.dart';
import 'package:catage/Modelo/Propietario.dart';
import 'package:catage/NewApp/DetailsAdoptionPage.dart';
import 'package:catage/pets/AllVacunaView.dart';
import 'package:catage/pets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

import '../Database/Database.dart';
import '../NewApp/BuildingPage.dart';
import 'VacunaView.dart';

class PetDetailFundacion extends StatefulWidget {
  final Gato pet;
  final Fundacion objFundacion;

  PetDetailFundacion({@required this.pet, @required this.objFundacion});

  @override
  State<PetDetailFundacion> createState() => _PetDetailFundacionState();
}

enum Options { search, upload, copy, exit }

class _PetDetailFundacionState extends State<PetDetailFundacion> {
  var _popupMenuItemIndex = 0;

  var data;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    data = (await Database.obtenerVacunas());
    setState(() {});
  }

  Color _changeColorAccordingToMenuItem = Colors.red;

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: HexColor("08CAF7"),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) {
    setState(() {
      _popupMenuItemIndex = value;
    });

    if (value == Options.search.index) {
      _changeColorAccordingToMenuItem = Colors.red;
    } else if (value == Options.upload.index) {
      _changeColorAccordingToMenuItem = Colors.green;
    } else if (value == Options.copy.index) {
      _changeColorAccordingToMenuItem = Colors.blue;
    } else {
      _changeColorAccordingToMenuItem = Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Hero(
                  tag: widget.pet.nombre,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            Image.memory(base64Decode(widget.pet.foto)).image,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.pet.nombre,
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                IcoFontIcons.nurse,
                                color: HexColor("08CAF7"),
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Fundación: " + widget.objFundacion.nombre,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      buildPetFeature(widget.pet.edadMeses.toString(), "Edad"),
                      buildPetFeature(widget.pet.color, "Color"),
                      buildPetFeature(widget.pet.peso + " Kg", "Peso"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      /*Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsAdoptionPage(
                                        objFundacion: widget.objFundacion,
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: HexColor("08CAF7"),
                            textStyle: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pets), // Icono al lado del texto
                              SizedBox(
                                  width:
                                      5), // Espacio entre el icono y el texto
                              Text(
                                'Adoptar',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BuildingPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: HexColor("08CAF7"),
                            textStyle: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons
                                  .monetization_on), // Icono al lado del texto
                              SizedBox(
                                  width:
                                      5), // Espacio entre el icono y el texto
                              Text(
                                'Donar',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: 16, left: 16, top: 161, bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          /*CircleAvatar(
                            radius: 30.0,
                            backgroundImage: Image.memory(
                                    base64Decode(widget.objPropietario.foto))
                                .image,
                            backgroundColor: Colors.transparent,
                          ),*/
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildPetFeature(String value, String feature) {
    return Expanded(
      child: Container(
        height: 100,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              feature,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
