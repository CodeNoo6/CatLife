import 'dart:convert';

import 'package:catage/NewApp/MenuPage.dart';
import 'package:catage/pets/pet_detail.dart';
import 'package:catage/pets/principal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:lottie/lottie.dart';

import '../Database/Database.dart';
import '../Messages/Dialogs.dart';
import '../Messages/shared/types.dart';
import '../Messages/widgets/buttons/icon_button.dart';
import '../Modelo/Gato.dart';
import '../Modelo/Propietario.dart';
import '../NewApp/QrVaccineGView.dart';
import 'VacunaView.dart';

List _elements = [
  {'name': 'John', 'group': 'Team A'},
  {'name': 'Will', 'group': 'Team B'},
  {'name': 'Beth', 'group': 'Team A'},
  {'name': 'Miranda', 'group': 'Team B'},
  {'name': 'Mike', 'group': 'Team C'},
  {'name': 'Danny', 'group': 'Team C'},
];

class VacunasGPublic extends StatefulWidget {
  final String id;

  const VacunasGPublic({@required this.id});

  @override
  State<VacunasGPublic> createState() => _VacunasGPublicState();
}

class _VacunasGPublicState extends State<VacunasGPublic> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  String _codigo = '';
  TextEditingController _controller = TextEditingController();
  String _errorMessage;
  bool _vacunaAplicada = false;
  Gato gato;
  Propietario propietario;

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
  List<TextEditingController> _controllersVeterinario = [];
  List<TextEditingController> _controllers = [];
  List<TextEditingController> _controllersDosis = [];
  List<TextEditingController> _controllersPorFrecuencia = [];
  Map<String, TextEditingController> _controllerPorFrecuenciaMap = {};
  Map<int, String> _selectedFrecuenciaPorVacuna = {};
  List<String> _countries = [
    'Frecuencia de aplicación',
    'Cada 15 días',
    'Cada semana',
    'Cada mes',
    'Cada año',
    'Vacuna completada',
  ];
  List<String> _errorMessages;
  List<String> _errorMessagesDosis;
  List<String> _errorMessagesVeterinario;
  List<String> _errorMessagesFrecuencia;
  List<bool> _vacunasAplicadas;

  void getDabaBase() async {
    _onLoading();
    List<Map<String, dynamic>> gatoMap =
        await Database.obtenerFelinoId(widget.id);
    Gato objGato = new Gato();
    objGato.foto = gatoMap[0]["felino"]["Foto"];
    objGato.nombre = gatoMap[0]["felino"]["Nombre"];
    objGato.especie = gatoMap[0]["felino"]["Especie"];
    objGato.fechaNacimiento = gatoMap[0]["felino"]["FechaNacimiento"];
    objGato.raza = gatoMap[0]["felino"]["Raza"];
    objGato.color = gatoMap[0]["felino"]["Color"];
    objGato.genero = gatoMap[0]["felino"]["Genero"];
    objGato.microchip = gatoMap[0]["felino"]["Microchip"];
    objGato.peso = gatoMap[0]["felino"]["Peso"];
    objGato.esterilizado = gatoMap[0]["felino"]["Esterilizado"];
    objGato.edadMeses = gatoMap[0]["felino"]["EdadMeses"];
    objGato.felinoId = gatoMap[0]["felino"]["FelinoId"];
    Propietario objPropietario = new Propietario();
    objPropietario.foto = gatoMap[0]["propietario"]["Foto"];
    objPropietario.nombreApellido = gatoMap[0]["propietario"]["NombreApellido"];
    objPropietario.celular = gatoMap[0]["propietario"]["Celular"];
    objPropietario.correo = gatoMap[0]["propietario"]["Correo"];
    data = (await Database.obtenerVacunasByEmail(objPropietario.correo));
    _elements = List<dynamic>.from(data);
    setState(() {
      gato = objGato;
      propietario = objPropietario;
    });
  }

  @override
  void initState() {
    super.initState();
    getDabaBase();
    _countries.forEach((frecuencia) {
      var controller = TextEditingController();
      _controllersPorFrecuencia.add(controller);
      _controllerPorFrecuenciaMap[frecuencia] = controller;
    });
    _controllers =
        List.generate(_elements.length, (_) => TextEditingController());
    _controllersVeterinario =
        List.generate(_elements.length, (_) => TextEditingController());
    _controllersDosis =
        List.generate(_elements.length, (_) => TextEditingController());
    _errorMessages = List.generate(_elements.length, (_) => null);
    _errorMessagesDosis = List.generate(_elements.length, (_) => null);
    _errorMessagesDosis = List.generate(_elements.length, (_) => null);
    _errorMessagesVeterinario = List.generate(_elements.length, (_) => null);
    _errorMessagesFrecuencia = List.generate(_elements.length, (_) => null);
    _vacunasAplicadas = List.generate(_elements.length, (index) => false);
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
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
            actions: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 15.0, top: 10.0, bottom: 10.0),
                child: GestureDetector(
                  onTap: () {
                    SystemNavigator.pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor("EC6337"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(2),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Guardar  ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: _loading
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
                              borderRadius: new BorderRadius.circular(10.0)),
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
                                  padding: EdgeInsets.fromLTRB(10, 10, 2, 50),
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
                                            'Luego de realizar el procedimiento no olvides guardar el carné',
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
                            SizedBox(
                              child: Container(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: MemoryImage(
                                    base64Decode(
                                      gato.foto,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                padding: EdgeInsets.only(top: 16.0),
                                child: Text(
                                  gato.nombre,
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
                                        'Carné de vacunación',
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
                                      Text(
                                        'digital',
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '(Inyectologia veterinaria)',
                                        style: TextStyle(
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: _elements
                                  .where((element) =>
                                      element["felino"] ==
                                      gato.nombre) // Filtrar elementos
                                  .toList() // Convertir el resultado a una lista
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final element = entry.value;
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Card(
                                      color: Colors.blue[50],
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 10.0),
                                        leading: CircleAvatar(
                                          child: Icon(
                                            IcoFontIcons.injectionSyringe,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          backgroundColor: HexColor("08CAF7"),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Vacuna: " +
                                                        element['nVacuna'],
                                                    style: GoogleFonts.aBeeZee(
                                                      textStyle: TextStyle(
                                                        color: Colors.blue[800],
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                _vacunasAplicadas[index]
                                                    ? Text("")
                                                    : Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextFormField(
                                                            controller:
                                                                _controllersVeterinario[
                                                                    index],
                                                            keyboardType:
                                                                TextInputType
                                                                    .text, // Usamos TextInputType.text para indicar que solo se acepte texto
                                                            textAlign: TextAlign
                                                                .center,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Veterinario",
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .aBeeZee(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                vertical: 8.0,
                                                                horizontal:
                                                                    10.0,
                                                              ),
                                                            ),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[a-zA-Z\s]')), // Este formateador permite solo letras y espacios
                                                            ],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _errorMessagesVeterinario[
                                                                        index] =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextFormField(
                                                            controller:
                                                                _controllers[
                                                                    index],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number, // Usamos TextInputType.number para indicar que solo se acepten números
                                                            textAlign: TextAlign
                                                                .center,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Código profesional M.P o T.P",
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .aBeeZee(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                vertical: 8.0,
                                                                horizontal:
                                                                    10.0,
                                                              ),
                                                            ),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[0-9]')), // Este formateador permite solo dígitos numéricos
                                                            ],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _errorMessages[
                                                                        index] =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          TextFormField(
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[0-9]')),
                                                            ],
                                                            controller:
                                                                _controllersDosis[
                                                                    index],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            textAlign: TextAlign
                                                                .center,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Número de dosis",
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .aBeeZee(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        10.0),
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          10.0),
                                                            ),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _errorMessagesDosis[
                                                                        index] =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          DropdownButtonFormField<
                                                              String>(
                                                            value:
                                                                _selectedFrecuenciaPorVacuna[
                                                                    index],
                                                            decoration:
                                                                InputDecoration(
                                                              errorText:
                                                                  _errorMessagesFrecuencia[
                                                                      index],
                                                              hintText:
                                                                  'Selecciona la frecuencia de aplicación',
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 13),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        10.0),
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          10.0),
                                                            ),
                                                            onChanged: (String
                                                                newValue) {
                                                              setState(() {
                                                                _selectedFrecuenciaPorVacuna[
                                                                        index] =
                                                                    newValue;
                                                              });
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty ||
                                                                  value ==
                                                                      'Frecuencia de aplicación') {
                                                                return 'Selecciona la frecuencia de aplicación';
                                                              }
                                                              return null;
                                                            },
                                                            isExpanded: true,
                                                            items: _countries.map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    value,
                                                                    style: TextStyle(
                                                                        color: Colors.grey[
                                                                            600],
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            hint: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  'Frecuencia de aplicación',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          13)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                  onPressed:
                                                      _vacunasAplicadas[index]
                                                          ? null
                                                          : () async {
                                                              TextEditingController
                                                                  controllerDosis =
                                                                  _controllersDosis[
                                                                      index];
                                                              if (controllerDosis
                                                                  .text
                                                                  .isEmpty) {
                                                                setState(() {
                                                                  _errorMessagesDosis[
                                                                          index] =
                                                                      'Por favor ingresa un número de dosis';
                                                                });
                                                              }
                                                              TextEditingController
                                                                  controllerCodigo =
                                                                  _controllers[
                                                                      index];
                                                              if (controllerCodigo
                                                                  .text
                                                                  .isEmpty) {
                                                                setState(() {
                                                                  _errorMessages[
                                                                          index] =
                                                                      'Por favor ingresa tu código profesional';
                                                                });
                                                              }
                                                              TextEditingController
                                                                  controllerVeterinario =
                                                                  _controllersVeterinario[
                                                                      index];
                                                              if (controllerVeterinario
                                                                  .text
                                                                  .isEmpty) {
                                                                setState(() {
                                                                  _errorMessagesVeterinario[
                                                                          index] =
                                                                      'Por favor ingresa tu nombre';
                                                                });
                                                              }
                                                              if (_selectedFrecuenciaPorVacuna[
                                                                          index] ==
                                                                      null ||
                                                                  _selectedFrecuenciaPorVacuna[
                                                                          index] ==
                                                                      'Frecuencia de aplicación') {
                                                                setState(() {
                                                                  _errorMessagesFrecuencia[
                                                                          index] =
                                                                      'Campo necesario';
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  _errorMessagesFrecuencia[
                                                                          index] =
                                                                      null;
                                                                });

                                                                setState(() {
                                                                  _errorMessages[
                                                                          index] =
                                                                      null;
                                                                  _codigo =
                                                                      controllerCodigo
                                                                          .text;
                                                                  _vacunasAplicadas[
                                                                          index] =
                                                                      true;
                                                                });
                                                                await Database.aplicarVacuna(
                                                                    widget.id,
                                                                    element[
                                                                        'nVacuna'],
                                                                    controllerVeterinario
                                                                        .text,
                                                                    int.parse(
                                                                        controllerCodigo
                                                                            .text),
                                                                    propietario
                                                                        .correo,
                                                                    int.parse(
                                                                        controllerDosis
                                                                            .text),
                                                                    _selectedFrecuenciaPorVacuna[
                                                                        index]);
                                                              }
                                                            },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: _vacunasAplicadas[
                                                            index]
                                                        ? Colors
                                                            .grey // Cambia el color del botón si la vacuna ya fue aplicada
                                                        : Colors.green[
                                                            400], // Color de fondo del botón
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        _vacunasAplicadas[index]
                                                            ? Text(
                                                                "Dosis aplicada",
                                                                style:
                                                                    GoogleFonts
                                                                        .aBeeZee(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              )
                                                            : Text(
                                                                "Aplicar Dosis",
                                                                style:
                                                                    GoogleFonts
                                                                        .aBeeZee(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                            width: 10),
                                                        _vacunasAplicadas[index]
                                                            ? Icon(
                                                                IcoFontIcons
                                                                    .testBottle,
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            : Icon(
                                                                IcoFontIcons
                                                                    .injectionSyringe,
                                                                color: Colors
                                                                    .white,
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                        margin: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 16, left: 16, top: 0, bottom: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: Image.memory(
                                          base64Decode(propietario.foto))
                                      .image,
                                  backgroundColor: Colors.transparent,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Propietario (a)",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      propietario.nombreApellido,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}

Future<void> eliminar(BuildContext context, String nVacuna) async {
  await Database.eliminarVacuna(nVacuna);
}

void editar(BuildContext context) {}

void aplicar(BuildContext context) {}
