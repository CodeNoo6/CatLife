import 'dart:convert';

import 'package:catage/NewApp/MenuPage.dart';
import 'package:catage/pets/pet_detail.dart';
import 'package:catage/pets/principal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../Database/Database.dart';
import '../Messages/Dialogs.dart';
import '../Messages/shared/types.dart';
import '../Messages/widgets/buttons/icon_button.dart';
import '../Modelo/Gato.dart';
import '../Modelo/Propietario.dart';
import '../NewApp/QrVaccineGView.dart';
import 'VacunaView.dart';

List _elements = [];

class AllVAcunasView extends StatefulWidget {
  final Gato pet;
  final Propietario objPropietario;

  const AllVAcunasView({@required this.pet, @required this.objPropietario});

  @override
  State<AllVAcunasView> createState() => _AllVAcunasViewState();
}

class _AllVAcunasViewState extends State<AllVAcunasView> {
  bool _loading = false;

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

  List<Map<String, dynamic>> data;

  void getData() async {
    _onLoading();
    data = (await Database.obtenerVacunas());
    _elements = List<dynamic>.from(data);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Principal()),
                  );
                },
              ),
              automaticallyImplyLeading:
                  false, // Desactiva la flecha de devolución
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VacunaView(
                      pet: widget.pet,
                      objPropietario: widget.objPropietario,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.vaccines),
              backgroundColor: HexColor("EC6337"), // Color del botón
              label: Text("Nueva Vacuna",
                  style: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                getData();
                setState(() {});
              },
              child: _loading
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 2, 120),
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
                                      width: 250,
                                      padding: EdgeInsets.all(3),
                                      child: Column(
                                        children: [
                                          BubbleSpecialOne(
                                            text:
                                                'Comparte el carné para que tu veterinario pueda vacunar a tu amigo peludo',
                                            isSender: false,
                                            color: HexColor("08CAF7"),
                                            textStyle: GoogleFonts.aBeeZee(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          BubbleSpecialOne(
                                            text:
                                                '¡Desliza hacia arriba para actualizar!',
                                            isSender: false,
                                            color: Colors.white,
                                            textStyle: GoogleFonts.aBeeZee(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Container(
                                    child: Text(
                                      widget.pet.nombre,
                                      style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Vacunación Digital ',
                                            style: TextStyle(
                                                fontFamily: 'SF Pro',
                                                fontSize: 20.0,
                                                fontStyle: FontStyle
                                                    .italic, // Aplica la cursiva
                                                fontWeight: FontWeight
                                                    .bold, // Aplica negrita
                                                letterSpacing: -0.5,
                                                color: Colors.blue[400]),
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: QrImageView(
                                    data:
                                        "https://gimomagic.com.co/deep.php/?id=" +
                                            widget.pet.felinoId,
                                    backgroundColor: Colors.white,
                                    version: QrVersions.auto,
                                    size: 150.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: _elements
                                      .where((element) =>
                                          element["felino"] ==
                                          widget.pet.nombre)
                                      .map((element) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Aquí puedes manejar la acción de tocar en cada elemento
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Card(
                                          color: HexColor("B2E4F9"),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 10.0),
                                            leading: CircleAvatar(
                                              child: Icon(
                                                IcoFontIcons.testBottle,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              backgroundColor:
                                                  HexColor("08CAF7"),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0),
                                                        spreadRadius: 2,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Vacuna: " +
                                                            element['nVacuna'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueGrey[600],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        IcoFontIcons
                                                            .injectionSyringe,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Dosis aplicadas: " +
                                                            element['dosis']
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[600],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        IcoFontIcons.stopwatch,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        element['frecuencia']
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Eliminar Vacuna"),
                                                      content: Text(
                                                          "¿Estás seguro de que quieres eliminar esta vacuna?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text("Cancelar"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await Database
                                                                .eliminarVacunaPorNombre(
                                                                    widget.pet
                                                                        .felinoId,
                                                                    element[
                                                                        'nVacuna']);
                                                            data = (await Database
                                                                .obtenerVacunas());
                                                            if (data == null) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      VacunaView(
                                                                          pet: widget
                                                                              .pet,
                                                                          objPropietario:
                                                                              widget.objPropietario),
                                                                ),
                                                              );
                                                            } else {
                                                              getData();
                                                              setState(() {});
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }
                                                          },
                                                          child:
                                                              Text("Eliminar"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                            margin: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          SizedBox(
                            height: 90,
                          )
                        ],
                      ),
                    ),
            )));
  }
}

Future<void> eliminar(BuildContext context, String nVacuna) async {
  await Database.eliminarVacuna(nVacuna);
}

void editar(BuildContext context) {}

void aplicar(BuildContext context) {}
