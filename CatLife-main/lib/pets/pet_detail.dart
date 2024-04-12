import 'dart:convert';

import 'package:catage/Modelo/Gato.dart';
import 'package:catage/Modelo/Propietario.dart';
import 'package:catage/pets/AllVacunaView.dart';
import 'package:catage/pets/principal.dart';
import 'package:catage/pets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Database/Database.dart';
import '../NewApp/BuildingPage.dart';
import 'VacunaView.dart';

class PetDetail extends StatefulWidget {
  final Gato pet;
  final Propietario objPropietario;

  PetDetail({@required this.pet, @required this.objPropietario});

  @override
  State<PetDetail> createState() => _PetDetailState();
}

String getAgeText(String ageString) {
  final ageParts = ageString.split(' ');
  final ageValue = int.tryParse(ageParts[0]);
  final unit = ageParts.length > 1 ? ageParts[1] : '';

  if (ageValue == null) {
    return ''; // Manejar el caso en que el formato de la cadena de edad no sea válido
  }

  if (ageValue == 1 && unit == 'años') {
    return '1 año';
  } else if (ageValue == 1 && unit == 'meses') {
    return '1 mes';
  } else {
    return ageString; // No hacer ningún cambio si la cadena ya tiene el formato adecuado
  }
}

enum Options { search, upload, copy, exit }

class _PetDetailState extends State<PetDetail> {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 8.0), // Ajusta el espaciado según sea necesario
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: IconButton(
                onPressed: () async {
                  await Database.eliminarFelino(widget.pet.nombre);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Principal(),
                    ),
                  );
                },
                icon: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
        ],
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
                                  fontSize: 25),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                widget.objPropietario.direccion,
                                style: TextStyle(
                                  color: Colors.grey[600],
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
                      buildPetFeature(
                          getAgeText(widget.pet.edadMeses.toString()), "Edad"),
                      buildPetFeature(widget.pet.color, "Color"),
                      buildPetFeature(widget.pet.peso + " Kg", "Peso"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            child: Text(
                              'Carné de vacunación',
                              textAlign: TextAlign.center,
                            ),
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
                            onPressed: () {
                              if (data == null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        VacunaView(
                                      pet: widget.pet,
                                      objPropietario: widget.objPropietario,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AllVAcunasView(
                                      pet: widget.pet,
                                      objPropietario: widget.objPropietario,
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      /*Expanded(
                        child: ElevatedButton(
                          child: Text(
                            'Tratamientos',
                            textAlign: TextAlign.center,
                          ),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BuildingPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          child: Text(
                            'Consultas',
                            textAlign: TextAlign.center,
                          ),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BuildingPage(),
                              ),
                            );
                          },
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
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage: Image.memory(
                                    base64Decode(widget.objPropietario.foto))
                                .image,
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Propietario (a)",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                widget.objPropietario.nombreApellido,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
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
        height: 70,
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
