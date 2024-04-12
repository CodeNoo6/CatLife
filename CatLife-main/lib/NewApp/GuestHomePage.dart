import 'dart:convert';

import 'package:catage/Modelo/Fundacion.dart';
import 'package:catage/Modelo/GatoxFundacion.dart';
import 'package:catage/NewApp/LocateDoctorPage.dart';
import 'package:catage/NewApp/UtilitiePage.dart';
import 'package:catage/Registro.dart';
import 'package:catage/age.dart';
import 'package:catage/age_human.dart';
import 'package:catage/pets/pet_widgetFundacion.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

import '../Database/Database.dart';
import '../Modelo/Gato.dart';
import 'GuestStart.dart';

class GuestHomePage extends StatefulWidget {
  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  List<GatoxFundacion> gatosxFundaciones = new List();
  bool hayNotificaciones = false;
  Map<String, dynamic> data;
  String propietario;
  bool _loading = false;
  bool newPet = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
      _onLoading();
    });
  }

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(seconds: 2), _login);
    });
  }

  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  void getData() async {
    data = await Database.obtenerTodosLosFelinosAdoptados();
    setState(() {});
  }

  List<Widget> buildNewestPet() {
    Fundacion objFundacion = new Fundacion();
    objFundacion.nombre = data['fundacion']['Nombre'];
    objFundacion.descripcion = data['fundacion']['Descripción'];
    objFundacion.latitud = data['fundacion']['Latitud'];
    objFundacion.longitud = data['fundacion']['Longitud'];
    objFundacion.celular = data['fundacion']['Celular'];
    for (var felino in data['felinos']) {
      Gato objGato = new Gato();
      GatoxFundacion objGatoxFundacion = new GatoxFundacion();
      objGato.foto = felino['Foto'];
      objGato.nombre = felino['Nombre'];
      objGato.especie = felino['Especie'];
      objGato.fechaNacimiento = felino['FechaNacimiento'];
      objGato.raza = felino['Raza'];
      objGato.color = felino['Color'];
      objGato.genero = felino['Genero'];
      objGato.microchip = felino['Microchip'];
      objGato.peso = felino['Peso'];
      objGato.esterilizado = felino['Esterilizado'];
      objGato.edadMeses = felino['EdadMeses'];
      objGatoxFundacion.objGato = objGato;
      objGatoxFundacion.objFundacion = objFundacion;
      gatosxFundaciones.add(objGatoxFundacion);
    }
    List<Widget> list = [];
    for (var i = 0; i < gatosxFundaciones.length; i++) {
      list.add(
        PetWidgetFundacion(
          pet: gatosxFundaciones[i].objGato,
          index: i,
          objFundacion: gatosxFundaciones[i].objFundacion,
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 244, 253),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cat Life',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        actions: [
          Row(
            children: [
              SizedBox(width: 20),
              /*CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    MemoryImage(base64Decode(widget.objPropietario.foto)),
              ),*/
              SizedBox(width: 20), // Espacio después del CircleAvatar
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: HexColor("08CAF7"),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        '¿Tu gato enfermó?',
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LocateDoctorPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor("EC6337"),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " Ubicar médico",
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
                  SizedBox(width: 10),
                  Image.asset(
                    'images/bannerDoctor.png',
                    width: 127,
                    height: 150,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Servicios",
                    style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Age(),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: HexColor("08CAF7"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            IcoFontIcons.cat,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Edad Felina',
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Age_Human(),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: HexColor("08CAF7"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.person_4,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Edad Humana',
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => GuestStartPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: HexColor("08CAF7"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.pets,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Mis Mascotas',
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                /*GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => GuestStartPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: HexColor("08CAF7"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            IcoFontIcons.injectionSyringe,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Vacunas',
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
            /*Row(
              children: [
                SizedBox(
                  width: 250,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => GuestStartPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: HexColor("EC6337"),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "  Ver más",
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),*/
            SizedBox(
              height: 10,
            ),
            newPet
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Felinos registrados ",
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Registro(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Registrar nuevo',
                              style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Adopción ",
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _loading
                      ? Container(
                          child: new Stack(
                            children: <Widget>[
                              new Container(
                                alignment: AlignmentDirectional.center,
                                decoration: new BoxDecoration(
                                  color: Color.fromARGB(255, 230, 244, 253),
                                ),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Color.fromARGB(255, 230, 244, 253),
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  width: 300.0,
                                  height: 200.0,
                                  alignment: AlignmentDirectional.center,
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Center(
                                        child: new SizedBox(
                                          height: 50.0,
                                          width: 50.0,
                                          child: new CircularProgressIndicator(
                                            color: HexColor("08CAF7"),
                                            value: null,
                                            strokeWidth: 7.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 250,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: buildNewestPet(),
                          ),
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
