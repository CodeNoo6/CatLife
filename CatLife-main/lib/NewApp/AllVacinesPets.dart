import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';

import '../Database/Database.dart';

class AllVacinesPets extends StatefulWidget {
  @override
  _AllVacinesPetsState createState() => _AllVacinesPetsState();
}

class _AllVacinesPetsState extends State<AllVacinesPets> {
  bool _loading = false;
  Map<String, dynamic> data;
  List _elements = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _onLoading() {
    setState(() {
      _loading = true;
    });
  }

  void _login() {
    setState(() {
      _loading = false;
    });
  }

  void getData() async {
    _onLoading();
    data = await Database.obtenerFelinos();
    if (data != null && data.isNotEmpty) {
      setState(() {
        // Limpiar la lista _elements antes de agregar nuevos datos
        _elements.clear();
        // Recorrer todos los felinos
        for (var felino in data["felinos"]) {
          // Crear un nuevo mapa que contendrá todos los datos del felino
          Map<String, dynamic> felinoData = {};
          // Agregar todos los datos del felino al mapa
          felino.forEach((key, value) {
            felinoData[key] = value;
          });
          // Agregar el nombre del felino como topicName
          _elements.add({
            'topicName': felinoData['Nombre'],
            'group': 'Felinos',
            'felinoData': felinoData
          });
        }
        print("Elementos creados:");
        print(_elements);
      });
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.grey[900],
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Vacunas',
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
          ),
          automaticallyImplyLeading: false, // Desactiva la flecha de devolución
        ),
        body: Column(
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
                            'Tus amigos peludos con carné de vacunación digital',
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
            Expanded(
              child: GroupedListView<dynamic, String>(
                elements: _elements,
                groupBy: (element) => element["felinoData"]["Especie"],
                order: GroupedListOrder.DESC,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                itemBuilder: (c, element) {
                  return Card(
                    elevation: 1.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(
                            base64.decode(element["felinoData"]["Foto"]),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          element["felinoData"]["Nombre"],
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850],
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
