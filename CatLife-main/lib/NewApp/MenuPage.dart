import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:catage/Modelo/Fundacion.dart';
import 'package:catage/Modelo/GatoxFundacion.dart';
import 'package:catage/NewApp/LocateDoctorPage.dart';
import 'package:catage/NewApp/UtilitiePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math' show Random, asin, cos, sqrt;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Mapas/model/nearby_response.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:catage/Registro.dart';
import 'package:catage/age.dart';
import 'package:catage/age_human.dart';
import 'package:catage/pets/pet_widgetFundacion.dart';
import 'package:catage/pets/principal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

import '../Database/Database.dart';
import '../Messages/Dialogs.dart';
import '../Messages/widgets/buttons/icon_button.dart';
import '../Messages/widgets/buttons/icon_outline_button.dart';
import '../Modelo/Gato.dart';
import '../Modelo/GatoxPropietario.dart';
import '../Modelo/Propietario.dart';
import '../Utilities/Utilities.dart';
import '../pets/pet_widget.dart';
import 'AdoptionPage.dart';
import 'AllVacinesPets.dart';
import 'BuildingPage.dart';

class MenuPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> data;
  const MenuPage({Key key, this.data}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<GatoxFundacion> gatosxFundaciones = new List();
  bool hayNotificaciones = false;
  bool _loading = false;
  bool newPet = false;
  double latitude;
  double longitude;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  void _getCurrentLocationAndCenterMap() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      // Llamar al método para obtener lugares cercanos después de actualizar la posición
      //getNearbyPlaces();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTipsFromFirestore() async {
    List<Map<String, dynamic>> tips = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('tips').get();

      querySnapshot.docs.forEach((doc) {
        tips.add({
          'title': doc['title'],
          'message': doc['message'],
        });
      });

      return tips;
    } catch (e) {
      print('Error al obtener los tips desde Firestore: $e');
      return [];
    }
  }

  void insertTipsData() async {
    try {
      // Accede a la instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Datos de los tips
      List<Map<String, dynamic>> tips = [
        {
          'title': 'Tip 1',
          'message':
              '¡Los gatos pueden tener hasta 5 dedos en las patitas delanteras, pero solo 4 en las traseras! 🐾'
        }
      ];

      // Inserta cada tip en Firestore
      for (var tip in tips) {
        await firestore.collection('tips').add(tip);
      }

      print('Datos de los tips insertados correctamente en Firestore.');
    } catch (e) {
      print('Error al insertar los datos de los tips: $e');
    }
  }

// Lista para almacenar los índices de los tips ya mostrados
  List<int> shownTipIndexes = [];

// Método para obtener un índice aleatorio no mostrado previamente
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
                  onPressed: () async {
                    await Utilities.guardaTips("Ok");
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

  int currentTipIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _initializeState();
    });
  }

  void showTipDialog() async {
    List<Map<String, dynamic>> tips = await getTipsFromFirestore();

    if (tips.isEmpty) {
      print('No se encontraron tips en Firestore.');
      return;
    }

    int currentTipIndex = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Curiosidades", textAlign: TextAlign.center),
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
                              Text(
                                tips[index]['message'],
                                textAlign: TextAlign.center,
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
              // Añade Center para centrar el botón Cancelar
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
                    "Cancelar",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _initializeState() async {
    //await insertTipsData();
    String tips = await Utilities.obtenerTips();
    if (tips == "") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showRandomTipDialog();
      });
    }
    _loading = true;
    await _getCurrentLocationAndCenterMap();
    getFundaciones();
  }

  List<Map<String, dynamic>> fundaciones;
  Map<Fundacion, double> distancias = {};

  double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Map<String, List<Map<String, dynamic>>> datos;
  void getFundaciones() async {
    if (widget.data == null) {
      datos = await Database.obtenerFundacionesYFelinos();
    } else {
      datos = widget.data;
    }

    if (datos.isNotEmpty) {
      // Limpiar la lista de gatosxFundaciones
      gatosxFundaciones.clear();

      // Ordenar las fundaciones por distancia
      List<String> nombresFundaciones = datos.keys.toList();
      nombresFundaciones.sort((a, b) {
        double distanciaA = calcularDistancia(
            latitude,
            longitude,
            double.parse(datos[a][0]['fundacion']['Latitud']),
            double.parse(datos[a][0]['fundacion']['Longitud']));
        double distanciaB = calcularDistancia(
            latitude,
            longitude,
            double.parse(datos[b][0]['fundacion']['Latitud']),
            double.parse(datos[b][0]['fundacion']['Longitud']));
        return distanciaA.compareTo(distanciaB);
      });

      // Iterar sobre las fundaciones y agregar la información a gatosxFundaciones
      for (String nombreFundacion in nombresFundaciones) {
        Map<String, dynamic> dataFundacion =
            datos[nombreFundacion][0]['fundacion'];
        List<Map<String, dynamic>> felinos = datos[nombreFundacion].sublist(1);
        Fundacion objFundacion = Fundacion(
          nombre: dataFundacion['Nombre'],
          descripcion: dataFundacion['Descripción'],
          latitud: dataFundacion['Latitud'],
          longitud: dataFundacion['Longitud'],
          celular: dataFundacion['Celular'],
        );

        List<GatoxFundacion> gatos = [];
        for (var felinoData in felinos) {
          Gato objGato = Gato(
            foto: felinoData['Foto'],
            nombre: felinoData['Nombre'],
            especie: felinoData['Especie'],
            fechaNacimiento: felinoData['FechaNacimiento'],
            raza: felinoData['Raza'],
            color: felinoData['Color'],
            genero: felinoData['Genero'],
            microchip: felinoData['Microchip'],
            peso: felinoData['Peso'],
            esterilizado: felinoData['Esterilizado'],
            edadMeses: felinoData['EdadMeses'],
          );
          GatoxFundacion objGatoxFundacion = GatoxFundacion(
            objGato: objGato,
            objFundacion: objFundacion,
          );
          gatos.add(objGatoxFundacion);
        }

        gatosxFundaciones.addAll(gatos);
      }

      _loading = false;

      // Actualizar la interfaz de usuario
      setState(() {});
    } else {
      print('No se encontraron datos de fundaciones y felinos.');
    }
  }

  List<Widget> buildNewestPet() {
    if (gatosxFundaciones.isNotEmpty) {
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
      _loading = false;
      return list;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.grey,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: HexColor("08CAF7"),
          centerTitle: true,
        ),
        bottomAppBarColor: HexColor("08CAF7"),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.yellow[800]),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 230, 244, 253),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Cat Life",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[850],
                fontSize: 25,
              ),
            ),
          ),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              Principal()),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("EC6337"),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                height: 10,
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
                            builder: (BuildContext context) => Principal()),
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
                  ),
                  /*Banner(
                    message: 'Nuevo',
                    location: BannerLocation.topStart,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Principal()),
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
                              'Comunidad',
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
                    ),
                  ),*/
                ],
              ),
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
                                    builder: (BuildContext context) =>
                                        Registro(),
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
                height: 10,
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
                                        color:
                                            Color.fromARGB(255, 230, 244, 253),
                                        borderRadius:
                                            new BorderRadius.circular(10.0)),
                                    width: 300.0,
                                    height: 200.0,
                                    alignment: AlignmentDirectional.center,
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Center(
                                          child: new SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child:
                                                new CircularProgressIndicator(
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
                        : buildNewestPet() == null
                            ? Text("data")
                            : Container(
                                height: 240,
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: buildNewestPet(),
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
      ),
    );
  }
}
