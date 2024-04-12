import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Modelo/Fundacion.dart';

class DetailsAdoptionPage extends StatelessWidget {
  final Fundacion objFundacion;

  DetailsAdoptionPage({@required this.objFundacion});
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Scaffold(
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
              'Fundación',
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
            automaticallyImplyLeading:
                false, // Desactiva la flecha de devolución
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 2, 80),
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
                                'Podrás contactar con la fundación para recibir más información de este amigo peludo',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      color: HexColor("B2E4F9"),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 30.0),
                        leading: CircleAvatar(
                          child: Icon(
                            IcoFontIcons.hospital,
                            color: Colors.white,
                            size: 20,
                          ),
                          backgroundColor: HexColor("08CAF7"),
                        ),
                        title: Text(
                          objFundacion.nombre,
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.indigo[900],
                              fontSize: 18,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              child: IconButton(
                                  icon: Icon(Icons.call),
                                  onPressed: () async {
                                    var url = Uri.parse(
                                        "tel:${objFundacion.celular}");
                                    try {
                                      if (await canLaunch(url.toString())) {
                                        await launch(url.toString());
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    } catch (e) {
                                      print(
                                          'Error al intentar lanzar la URL tel: $e');
                                    }
                                  }),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              child: IconButton(
                                icon: Icon(Icons.directions),
                                onPressed: () {
                                  openGoogleMaps(
                                      double.parse(objFundacion.latitud),
                                      double.parse(objFundacion.longitud));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
