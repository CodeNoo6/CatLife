import 'dart:convert';

import 'package:catage/Database/Database.dart';
import 'package:catage/Modelo/Gato.dart';
import 'package:catage/Modelo/Propietario.dart';
import 'package:catage/pets/pet_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class PetWidget extends StatefulWidget {
  final Gato pet;
  final Propietario objPropietario;
  final int index;

  PetWidget(
      {@required this.pet,
      @required this.index,
      @required this.objPropietario});

  @override
  State<PetWidget> createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PetDetail(
                    pet: widget.pet,
                    objPropietario: widget.objPropietario,
                  )),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
        ),
        margin: EdgeInsets.only(right: 8, left: 8, bottom: 10),
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor("08CAF7"),
                        ),
                        child: InkWell(
                          /*onTap: () {
                            Database.eliminarFelino(widget.pet.nombre);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PetDetail(
                                        pet: widget.pet,
                                        objPropietario: widget.objPropietario,
                                      )),
                            );
                          },*/
                          child: Icon(
                            Icons.pets,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
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
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: HexColor("08CAF7"),
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.objPropietario.direccion,
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person_4_rounded,
                        color: Colors.deepOrange,
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.objPropietario.nombreApellido,
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                              fontSize: 12),
                        ),
                      ),
                    ],
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
