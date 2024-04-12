import 'dart:convert';

import 'package:catage/Modelo/Fundacion.dart';
import 'package:catage/Modelo/GatoxFundacion.dart';
import 'package:catage/NewApp/LocateDoctorPage.dart';
import 'package:catage/NewApp/UtilitiePage.dart';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
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
import '../Modelo/Gato.dart';
import '../Modelo/GatoxPropietario.dart';
import '../Modelo/Propietario.dart';
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
  String propietario;
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

  @override
  void initState() {
    super.initState();
    setState(() {
      _initializeState();
    });
  }

  void _initializeState() async {
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
          /*leading: Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.grey[900],
                ),
                onPressed: () {
                  // Acción al presionar el icono de notificación
                },
              ),
              if (hayNotificaciones)
                Positioned(
                  top: 10,
                  right: 15,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),*/
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
                  /*GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Principal()),
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
                  ),*/
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
                ],
              ),
              /*Row(
                children: [
                  SizedBox(
                    width: 250,
                  ),
                  GestureDetector(
                    onTap: () {},
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
                                height: 200,
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
                                'Los gatos se comunican con una variedad de expresiones faciales y corporales.',
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
