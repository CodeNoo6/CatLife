import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/nearby_response.dart';

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {
  String apiKey =
      "AIzaSyDBSLtAFqzfVi3X65FDL_9xI9E29a5ZSRs"; // Reemplaza "TU_API_KEY" con tu propia API key
  String radius = "10000"; // Radio de búsqueda en metros

  double latitude = 4.631629179224748; // Latitud de tu ubicación
  double longitude = -74.06634131962039; // Longitud de tu ubicación

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  List<String> phoneNumbers = []; // Lista para almacenar números de teléfono

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: getNearbyPlaces,
              child: const Text("Get Nearby Places"),
            ),
            if (nearbyPlacesResponse.results != null)
              ...nearbyPlacesResponse.results
                  .asMap()
                  .entries
                  .toList()
                  .map((entry) => nearbyPlacesWidget(entry.value, entry.key))
                  .toList()
          ],
        ),
      ),
    );
  }

  // Método para obtener los lugares cercanos y sus detalles
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
    });

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
    });
  }

  // Widget para mostrar un lugar cercano
  Widget nearbyPlacesWidget(Results results, int index) {
    return GestureDetector(
      onTap: () {
        // Llamar a getPlaceDetails cuando se toque un lugar
        getPlaceDetails(results.placeId, index);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: " + results.rating.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Name: " + results.userRatingsTotal.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Name: " + results.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Location: " + results.vicinity,
            ),
            SizedBox(height: 5),
            Text(
              results.openingHours != null ? "Open" : "Closed",
              style: TextStyle(
                fontStyle: results.openingHours != null
                    ? FontStyle.normal
                    : FontStyle.italic,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Types: " + results.types.join(", "),
            ),
            SizedBox(height: 5),
            Text(
              "Phone Number: " + phoneNumbers[index],
            ),
          ],
        ),
      ),
    );
  }
}
