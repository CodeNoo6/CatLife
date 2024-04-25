import 'dart:async';
import 'dart:developer';
import 'package:catage/pets/AllVacunaView.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'dart:io';
import 'package:catage/Database/Database.dart';
import 'package:catage/Modelo/Gato.dart';
import 'package:catage/Modelo/Propietario.dart';
import 'package:catage/pets/principal.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../Modelo/Vacuna.dart';
import '../View_home.dart';
import '../age.dart';

import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../generated/l10n.dart';
import '../testMessaging/eje.dart';

class Result extends StatelessWidget {
  const Result({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text("Readed text: $text")],
      ),
    );
  }
}

class VacunaView extends StatefulWidget {
  final Gato pet;
  final Propietario objPropietario;

  const VacunaView({@required this.pet, @required this.objPropietario});

  @override
  _VacunaViewState createState() => _VacunaViewState();
}

class _VacunaViewState extends State<VacunaView> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyTwo = GlobalKey<FormState>();
  int _currentStep = 0;
  TextEditingController tEVacuna = TextEditingController();
  TextEditingController tEVeterinario = TextEditingController();
  String dFAplicacion = "va";
  String dFProxima = "va";
  final StreamController<String> controller = StreamController<String>();
  String savedText;
  String _selectedCountry;
  List<String> _countries = [
    'Frecuencia de aplicación',
    'Cada 15 días',
    'Cada semana',
    'Cada mes',
    'Cada año',
    'Vacuna completada',
  ];
  String errorVacuna;

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  DateTime getDateNow() {
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.grey[800],
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
            'Registro de vacuna',
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
          ),
          automaticallyImplyLeading: false, // Desactiva la flecha de devolución
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_currentStep == 0) {
                              if (dFProxima == "va") {
                                dFProxima = "v";
                              } else {
                                //NotificationController.createNewNotification();
                                if (_formKey.currentState.validate()) {
                                  if (_selectedCountry ==
                                      "Frecuencia de aplicación") {
                                    errorVacuna =
                                        "Frecuencia de aplicación inválida";
                                  }
                                  if (_selectedCountry !=
                                      "Frecuencia de aplicación") {
                                    Vacuna objVacuna = new Vacuna();
                                    objVacuna.nombre = tEVacuna.text;
                                    objVacuna.fechaAplicacion = dFAplicacion;
                                    objVacuna.proximAplicacion =
                                        _selectedCountry;
                                    objVacuna.nombreVeterinario = "";
                                    objVacuna.dosis = 0;
                                    objVacuna.codigoVet = 0;
                                    Database.agregarVacunaAFelino(
                                        widget.pet.nombre, objVacuna);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            AllVAcunasView(
                                          pet: widget.pet,
                                          objPropietario: widget.objPropietario,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: HexColor("08CAF7"),
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _currentStep == 1
                                    ? Text(
                                        "Guardar",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        "Guardar",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        _currentStep == 1
                            ? GestureDetector(
                                onTap: controls.onStepCancel,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.circular(40)),
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Anterior",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Text(""),
                      ],
                    );
                  },
                  type: StepperType.vertical,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: new Text(
                        '',
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      content: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
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
                                width: 200,
                                padding: EdgeInsets.all(3),
                                child: Column(
                                  children: [
                                    BubbleSpecialOne(
                                      text: 'Registra la nueva vacuna',
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
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: tEVacuna,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "Vacuna",
                                    hintStyle: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10.0),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Este campo es requerido';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                DateTimePicker(
                                  textAlign: TextAlign.center,
                                  initialValue: getDateNow()
                                      .toString(), // Obtener la fecha actual utilizando el método getDateNow()
                                  locale: const Locale("es"),
                                  enabled: false,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  dateLabelText: 'Fecha de aplicación',
                                  onChanged: (val) {
                                    setState(() {
                                      dFAplicacion = val;
                                    });
                                  },
                                  validator: (val) {
                                    setState(() {
                                      dFAplicacion = val;
                                    });
                                    return null;
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      dFAplicacion = val;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                DropdownButtonFormField<String>(
                                  value: _selectedCountry,
                                  decoration: InputDecoration(
                                    errorText: errorVacuna,
                                    hintText:
                                        'Frecuencia de aplicación inválida',
                                    hintStyle: TextStyle(
                                        color: Colors.grey[600], fontSize: 13),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10.0),
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _selectedCountry = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value ==
                                            'Frecuencia de aplicación inválida') {
                                      return 'Frecuencia de aplicación inválida';
                                    }
                                    return null;
                                  },
                                  isExpanded: true,
                                  items: _countries
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13),
                                          )),
                                    );
                                  }).toList(),
                                  hint: Align(
                                      alignment: Alignment.center,
                                      child: Text(_countries[0],
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13))),
                                ),
                                dFAplicacion == "v" || dFAplicacion == ""
                                    ? Text(
                                        "Este campo es requerido",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : SizedBox(
                                        height: 2.0,
                                      ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
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

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 1 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
