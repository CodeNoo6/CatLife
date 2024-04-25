import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:catage/Modelo/Fundacion.dart';
import 'package:catage/Modelo/GatoxFundacion.dart';
import 'package:catage/NewApp/LocateDoctorPage.dart';
import 'package:catage/NewApp/UtilitiePage.dart';
import 'package:catage/Registro.dart';
import 'package:catage/age.dart';
import 'package:catage/age_human.dart';
import 'package:catage/pets/pet_widgetFundacion.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

import '../Database/Database.dart';
import '../Modelo/Gato.dart';
import '../pets/principal.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showRandomTipDialog();
    });
    setState(() {
      getData();
      _onLoading();
    });
  }

  List<int> shownTipIndexes = [];

  int getRandomIndex(List<Map<String, dynamic>> tips) {
    List<int> availableIndexes = [];

    // Agregar índices no mostrados a la lista de disponibles
    for (int i = 0; i < tips.length; i++) {
      if (!shownTipIndexes.contains(i)) {
        availableIndexes.add(i);
      }
    }

    if (availableIndexes.isEmpty) {
      // Todos los tips han sido mostrados, reiniciar la lista
      shownTipIndexes.clear();
      availableIndexes = List.generate(tips.length, (index) => index);
    }

    // Obtener un índice aleatorio de la lista de disponibles
    int randomIndex =
        availableIndexes[Random().nextInt(availableIndexes.length)];

    // Registrar el índice mostrado
    shownTipIndexes.add(randomIndex);

    return randomIndex;
  }

  Future<List<Map<String, dynamic>>> getLimitedTipsFromFirestore(
      int limit) async {
    List<Map<String, dynamic>> tips = [];

    try {
      // Accede a la instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Obtiene todos los documentos de la colección 'tips'
      QuerySnapshot allDocsSnapshot = await firestore.collection('tips').get();

      // Obtén la lista de todos los documentos
      List<DocumentSnapshot> allDocs = allDocsSnapshot.docs;

      // Verifica si hay suficientes documentos para cumplir con el límite solicitado
      if (allDocs.length < limit) {
        throw Exception('No hay suficientes documentos en la colección.');
      }

      // Selecciona aleatoriamente 'limit' documentos
      List<DocumentSnapshot> randomDocs = [];
      final random = Random();
      while (randomDocs.length < limit) {
        // Selecciona un índice aleatorio dentro del rango de todos los documentos
        int randomIndex = random.nextInt(allDocs.length);
        // Agrega el documento correspondiente al índice aleatorio a la lista de documentos aleatorios
        randomDocs.add(allDocs[randomIndex]);
        // Elimina el documento seleccionado para evitar la selección duplicada
        allDocs.removeAt(randomIndex);
      }

      // Recorre los documentos seleccionados y agrega sus datos a la lista de tips
      randomDocs.forEach((doc) {
        Map<String, dynamic> tipData = doc.data();
        tips.add(tipData);
      });

      return tips;
    } catch (e) {
      print('Error al obtener los tips desde Firestore: $e');
      return [];
    }
  }

  int _currentIndex = 0;

  void showRandomTipDialog() async {
    int limit = 3;
    List<Map<String, dynamic>> tips = await getLimitedTipsFromFirestore(limit);

    if (tips.isEmpty) {
      print('No se encontraron tips en Firestore.');
      return;
    }

    int currentTipIndex = getRandomIndex(tips);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text("", textAlign: TextAlign.center),
          content: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        itemCount: tips.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentTipIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 2, 30),
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
                                  Container(
                                    width: 150,
                                    padding: EdgeInsets.all(3),
                                    child: Column(
                                      children: [
                                        BubbleSpecialOne(
                                          text: 'Tips del día',
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
                              Text(
                                tips[index]['message'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[850],
                                    fontSize: 20,
                                  ),
                                ), // Tamaño de fuente ajustado a 18
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        tips.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentTipIndex == index
                                ? Colors.blue // Resalta el indicador actual
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200], // Color de fondo del botón Cancelar
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "¡Ok!",
                    style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
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
    setState(() {
      buildNewestPet();
    });
  }

  List<Widget> list = [];

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
            Column(
              children: [
                CarouselSlider(
                  items: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: HexColor("#77D7F7"),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                '¡Vacunas al día, \nSalud asegurada!',
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
                                            GuestStartPage()),
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
                                        " Carné digital",
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
                            'images/bannerVacunaMed.png',
                            width: 140,
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                    // Otras imágenes aquí...
                  ],
                  options: CarouselOptions(
                    height: 180.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    viewportFraction: 0.99,
                    onPageChanged: (index, _) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    2, // Número total de banners en el CarouselSlider
                    (index) => buildIndicator(index),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
              Text(
                "Servicios",
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[850],
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
            ]),
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
                : Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          )),
                    ),
                    Text(
                      "¡Adopción cerca a tí!",
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[850],
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          )),
                    ),
                  ]),
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
                          height: 200,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: list,
                          ),
                        ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange[
                            100], // Color similar a los recordatorios de vacunas
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: Colors.orange[
                                700], // Color similar al icono de recordatorio
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No tienes notificaciones pendientes',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
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

  Widget buildIndicator(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
