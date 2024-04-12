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

class LocateDoctorPage extends StatefulWidget {
  const LocateDoctorPage({Key key}) : super(key: key);

  @override
  State<LocateDoctorPage> createState() => _LocateDoctorPageState();
}

class _LocateDoctorPageState extends State<LocateDoctorPage> {
  String apiKey = "AIzaSyDBSLtAFqzfVi3X65FDL_9xI9E29a5ZSRs";
  String radius = "10000";

  double latitude;
  double longitude;

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  List<String> phoneNumbers = []; // Lista para almacenar números de teléfono
  bool _loading = false;

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
      getNearbyPlaces();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _getCurrentLocationAndCenterMap();
      _loading = true;
      getNearbyPlaces();
    });
  }

  void getNearbyPlaces() async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            latitude.toString() +
            ',' +
            longitude.toString() +
            '&radius=' +
            radius +
            '&key=' +
            apiKey +
            '&keyword=Veterinaria');

    print("La url es");
    print(url);

    var response = await http.get(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    // Llena la lista de números de teléfono con valores predeterminados
    phoneNumbers =
        List.generate(nearbyPlacesResponse.results.length, (index) => '');

    // Lista de futures para almacenar las solicitudes de detalles
    List<Future<void>> futures = [];

    // Crear las solicitudes de detalles para cada lugar
    for (int i = 0; i < nearbyPlacesResponse.results.length; i++) {
      futures.add(getPlaceDetails(nearbyPlacesResponse.results[i].placeId, i));
    }

    // Esperar a que todas las solicitudes se completen
    await Future.wait(futures);
    // Ordenar las ubicaciones por proximidad a tu ubicación
    nearbyPlacesResponse.results.sort((a, b) {
      double distanceA = _calculateDistance(latitude, longitude,
          a.geometry.location.lat, a.geometry.location.lng);
      double distanceB = _calculateDistance(latitude, longitude,
          b.geometry.location.lat, b.geometry.location.lng);
      return distanceA.compareTo(distanceB);
    }); /*
    nearbyPlacesResponse.results.sort((a, b) {
      return b.rating.compareTo(a.rating);
    });*/

    /*nearbyPlacesResponse.results.sort((a, b) {
      return b.userRatingsTotal.compareTo(a.userRatingsTotal);
    });*/

    setState(() {});
  }

  // Método para calcular la distancia entre dos puntos geográficos utilizando la fórmula de la distancia euclidiana
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void openMapsSheet(BuildContext context, double latitude, double longitude,
      String title, String description) async {
    final availableMaps = await MapLauncher.installedMaps;
    availableMaps.forEach((element) {
      print(element.icon);
      print(element.mapName);
    });
    await availableMaps.first.showMarker(
        coords: Coords(latitude, longitude),
        title: title,
        description: description);
  }

  void openGoogleMaps(double latitude, double longitude) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      final googleMaps = availableMaps.firstWhere(
        (map) => map.mapType == MapType.google,
        orElse: () => availableMaps.first,
      );
      await googleMaps.showMarker(
        coords: Coords(latitude, longitude),
        title: "Ubicación",
      );
    } catch (e) {
      print("Error al abrir Google Maps: $e");
      // Manejar el error si no se puede abrir Google Maps
    }
  }

  // Método para obtener los detalles de un lugar por su place_id
  Future<void> getPlaceDetails(String placeId, int index) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=' +
            placeId +
            '&key=' +
            apiKey);

    print("La url es");
    print(url);

    var response = await http.get(url);

    // Analizar la respuesta y mostrar los detalles, como el número de teléfono
    var placeDetails = jsonDecode(response.body);
    var phoneNumber = placeDetails['result']['formatted_phone_number'];

    // Actualizar la lista de números de teléfono
    setState(() {
      phoneNumbers[index] = phoneNumber;
      _loading = false;
    });
  }

  // Widget para mostrar un lugar cercano
  Widget nearbyPlacesWidget(Results results, int index) {
    double _rating = double.parse(results.rating.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: HexColor("B2E4F9"),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 30.0),
          leading: CircleAvatar(
            child: Icon(
              IcoFontIcons.hospital,
              color: Colors.white,
              size: 20,
            ),
            backgroundColor: HexColor("08CAF7"),
          ),
          title: Text(
            results.name,
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                color: Colors.indigo[900],
                fontSize: 18,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              RatingBar.builder(
                itemSize: 20,
                initialRating: double.parse(results.rating.toString()),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.pets,
                  color: Colors.blue,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Comentarios: ${results.userRatingsTotal.toString()}",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              phoneNumbers[index] != null
                  ? CircleAvatar(
                      child: IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () async {
                            var url = Uri.parse("tel:${phoneNumbers[index]}");
                            if (!await launcher.launchUrl(url)) {
                              debugPrint(
                                  "Could not launch the uri"); // because the simulator doesn't has the phone app
                            }
                          }),
                    )
                  : Text(""),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                child: IconButton(
                  icon: Icon(Icons.directions),
                  onPressed: () {
                    openGoogleMaps(results.geometry.location.lat,
                        results.geometry.location.lng);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    /*GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[900]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              results.name,
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                    fontSize: 15),
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "Puntuación: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 13),
                ),
                Text(results.rating.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 13))
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "Comentarios: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 13),
                ),
                Text(results.userRatingsTotal.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 13))
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "Ubicación: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 13),
                ),
                Container(
                  width: 250,
                  child: Text(results.vicinity,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 13)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 2, 50),
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
                        text: 'Número de contacto: ',
                        isSender: false,
                        color: Colors.deepOrange,
                        textStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      phoneNumbers[index] != null
                          ? BubbleSpecialOne(
                              text: phoneNumbers[index],
                              isSender: false,
                              color: Colors.green,
                              textStyle: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : BubbleSpecialOne(
                              text: "Ups no se reporta número de contacto",
                              isSender: false,
                              color: Colors.green,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                phoneNumbers[index] != null
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          var url = Uri.parse("tel:${phoneNumbers[index]}");
                          try {
                            if (await canLaunch(url.toString())) {
                              await launch(url.toString());
                            } else {
                              throw 'Could not launch $url';
                            }
                          } catch (e) {
                            print('Error al intentar lanzar la URL tel: $e');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        icon: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        label: Row(
                          children: [
                            Text(
                              'Llamar',
                              style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                    5), // Espacio entre el texto y el segundo icono
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    : Text(""),
                phoneNumbers[index] != null
                    ? SizedBox(
                        width: 40,
                      )
                    : SizedBox(
                        width: 175,
                      ),
                ElevatedButton.icon(
                  onPressed: () {
                    openGoogleMaps(results.geometry.location.lat,
                        results.geometry.location.lng);
                    /*openMapsSheet(
                        context,
                        results.geometry.location.lat,
                        results.geometry.location.lng,
                        results.name,
                        results.vicinity);*/
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  label: Row(
                    children: [
                      Text(
                        '¡Ir Ahora!',
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                          width:
                              5), // Espacio entre el texto y el segundo icono
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 230, 244, 253),
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
            'Emergencias',
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
          ),
          automaticallyImplyLeading: false, // Desactiva la flecha de devolución
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 2, 50),
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
                              text:
                                  'Clinicas más cercanas a tu ubicación con Google Maps',
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
                      : Column(
                          children: [
                            if (nearbyPlacesResponse.results != null)
                              ...nearbyPlacesResponse.results
                                  .asMap()
                                  .entries
                                  .toList()
                                  .map((entry) => nearbyPlacesWidget(
                                      entry.value, entry.key))
                                  .toList()
                          ],
                        ),
                  SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
