import 'dart:convert';
import 'dart:io';
import 'package:catage/Database/Database.dart';
import 'package:catage/Modelo/Gato.dart';
import 'package:catage/Modelo/Propietario.dart';
import 'package:catage/NewApp/MenuPage.dart';
import 'package:catage/pets/principal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'Messages/Dialogs.dart';
import 'Messages/shared/types.dart';
import 'Messages/widgets/buttons/icon_button.dart';
import 'Messages/widgets/buttons/icon_outline_button.dart';
import 'Modelo/Fundacion.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyTwo = GlobalKey<FormState>();
  final _formKeyThree = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _checkBox = false;
  bool _listTileCheckBox = false;
  bool isSwitchedMicrochip = false;
  bool isSwitchedEsterilizado = false;
  File _image;
  File _imageProp;
  String validaImage = "va";
  String validaImageDos = "va";
  TextEditingController tENombre = TextEditingController();
  TextEditingController tEEspecie = TextEditingController();
  String dFNacimiento = "va";
  TextEditingController tERaza = TextEditingController();
  TextEditingController tsColor = TextEditingController();
  String sGenero;
  String valida = "va";
  TextEditingController tsPeso = TextEditingController();
  TextEditingController tsPropietario = TextEditingController();
  TextEditingController tsCedula = TextEditingController();
  TextEditingController tsTelefono = TextEditingController();
  TextEditingController tsDireccion = TextEditingController();
  TextEditingController tsEdad = TextEditingController();
  Gato objGato = new Gato();
  String selectedUnit = 'meses'; // Valor predeterminado

// Lista de opciones para la unidad de tiempo
  List<String> units = ['meses', 'años'];

// Método para manejar el cambio de la unidad de tiempo seleccionada
  void onUnitChanged(String newValue) {
    setState(() {
      selectedUnit = newValue;
    });
  }

  Future getImage(ImageSource source, String imagen) async {
    if (imagen == "gato") {
      try {
        final image = await ImagePicker()
            .pickImage(source: source, maxHeight: 600.0, maxWidth: 600.0);
        if (image == null) return;
        final imageTemporary = File(image.path);

        setState(() {
          validaImage = "";
          this._image = imageTemporary;
        });
      } on PlatformException catch (e) {
        print("Failed to pick image: $e");
      }
    }
    if (imagen == "propietario") {
      try {
        final image = await ImagePicker()
            .pickImage(source: source, maxHeight: 600.0, maxWidth: 600.0);
        if (image == null) return;
        final imageTemporary = File(image.path);

        setState(() {
          validaImageDos = "";
          this._imageProp = imageTemporary;
        });
      } on PlatformException catch (e) {
        print("Failed to pick image: $e");
      }
    }
  }

  bool validarFechaNacimiento(String fechaNacimientoStr) {
    DateTime fechaNacimiento = DateTime.parse(fechaNacimientoStr);
    DateTime fechaActual = DateTime.now();
    if (fechaNacimiento.isBefore(fechaActual)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('es')],
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: Colors.grey[800]),
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
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MenuPage(),
                ),
              );
            },
          ),
          title: Text(
            'Registro de felino',
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
                    return _currentStep == 1
                        ? Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: controls.onStepCancel,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: HexColor("08CAF7"),
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
                              ),
                              SizedBox(
                                width: 150,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_currentStep == 1) {
                                      if (sGenero == null) {
                                        setState(() {
                                          valida = "v";
                                        });
                                      } else {
                                        if (_formKeyTwo.currentState
                                            .validate()) {
                                          var bytes =
                                              await _image.readAsBytes();
                                          var base64img = base64Encode(bytes);
                                          objGato.foto = base64img;
                                          objGato.nombre = tENombre.text;
                                          objGato.especie = "Felino";
                                          objGato.fechaNacimiento =
                                              dFNacimiento;
                                          objGato.raza = tERaza.text;
                                          objGato.color = tsColor.text;
                                          objGato.genero = sGenero;
                                          objGato.microchip =
                                              isSwitchedMicrochip;
                                          objGato.peso = tsPeso.text;
                                          objGato.esterilizado =
                                              isSwitchedEsterilizado;
                                          objGato.edadMeses =
                                              tsEdad.text + " " + selectedUnit;
                                          Fundacion objFundacion =
                                              new Fundacion();
                                          objFundacion.nombre =
                                              "El arca de rene";
                                          objFundacion.latitud =
                                              "5.620193183521917";
                                          objFundacion.longitud =
                                              "-73.81127374774876";
                                          objFundacion.descripcion =
                                              "Brindamos apoyo a felinos en riesgo";
                                          objFundacion.celular = 3133717962;
                                          //Database.registroFelinoAdoptado(
                                          //    objGato, objFundacion);
                                          Database.registroFelino(objGato);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Principal(),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      backgroundColor: Colors.green),
                                  child: Text('Guardar')),
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (_currentStep == 0) {
                                    if (validaImage == "va") {
                                      setState(() {
                                        validaImage = "v";
                                      });
                                    } else {
                                      if (dFNacimiento == "va") {
                                        dFNacimiento = "v";
                                      } else {
                                        bool esValida = validarFechaNacimiento(
                                            dFNacimiento);
                                        print(esValida);
                                        if (!esValida) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'La fecha de nacimiento debe ser anterior a la fecha actual.',
                                                textAlign: TextAlign
                                                    .center, // Centra el texto
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } else {
                                          if (dFNacimiento != "" &&
                                              validaImage != "v" &&
                                              _formKey.currentState
                                                  .validate()) {
                                            return continued();
                                          }
                                        }
                                      }
                                    }
                                  }
                                  if (_currentStep == 1) {
                                    if (sGenero != null) {
                                      setState(() {
                                        valida = sGenero;
                                      });
                                    }
                                    if (valida == "va") {
                                      setState(() {
                                        valida = "v";
                                      });
                                    }
                                    if (valida != "v") {
                                      if (_formKeyTwo.currentState.validate()) {
                                        return continued();
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: HexColor("08CAF7"),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.only(
                                      right: 118,
                                      left: 118,
                                      top: 10,
                                      bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Siguiente",
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
                                width: 10,
                              ),
                              _currentStep == 1
                                  ? GestureDetector(
                                      onTap: controls.onStepCancel,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue[400],
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                      title: Text(
                        '',
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      content: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
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
                                      text:
                                          'Registra la foto, nombre... de tu amigo peludo',
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
                          Center(
                            child: Column(
                              children: [
                                _image != null
                                    ? Container(
                                        width: 160.0,
                                        height: 160.0,
                                        child: IconButton(
                                            icon: Container(
                                              width: 160.0,
                                              height: 160.0,
                                              padding: EdgeInsets.all(2),
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    FileImage(_image),
                                              ),
                                            ),
                                            onPressed: () => getImage(
                                                ImageSource.gallery, "gato")),
                                      )
                                    : Container(
                                        width: 160.0,
                                        height: 160.0,
                                        child: IconButton(
                                            icon: Container(
                                              width: 160.0,
                                              height: 160.0,
                                              padding: EdgeInsets.all(2),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    HexColor("08CAF7"),
                                                child: Text(
                                                  'Seleccionar Foto',
                                                  style: GoogleFonts.aBeeZee(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () => getImage(
                                                ImageSource.gallery, "gato")),
                                      ),
                                validaImage == "v"
                                    ? Text(
                                        "La foto es requerida",
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
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DateTimePicker(
                                  textAlign: TextAlign.center,
                                  initialValue: '',
                                  locale: const Locale("es"),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  dateLabelText: 'Fecha de nacimiento',
                                  style: TextStyle(
                                    fontSize: 13,
                                    // Otros estilos de texto, si es necesario
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      dFNacimiento = val;
                                    });
                                  },
                                  validator: (val) {
                                    setState(() {
                                      dFNacimiento = val;
                                    });
                                    return null;
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      dFNacimiento = val;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                dFNacimiento == "v" || dFNacimiento == ""
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
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: tENombre,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$")),
                                  ],
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                    hintText: "Nombre",
                                    hintStyle: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13),
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
                                /*TextFormField(
                                  controller: tEEspecie,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$")),
                                  ],
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                      labelText: "Especie",
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Este campo es requerido';
                                    }
                                    return null;
                                  },
                                ),*/
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: tERaza,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$")),
                                  ],
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                    hintText: "Raza",
                                    hintStyle: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13),
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
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
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
                                      text:
                                          'Registro detallado de rasgos físicos',
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
                                      text: 'Por si tu amigo no regresa',
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
                          Form(
                            key: _formKeyTwo,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: tsColor,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$")),
                                  ],
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                    hintText: "Color",
                                    hintStyle: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13),
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
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        child: Text(
                                          "Genero",
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.all(0.0),
                                        child: DropdownButton<String>(
                                          value: sGenero,
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                          items: <String>[
                                            'Masculino',
                                            'Femenino',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            "Selecciona",
                                            style: GoogleFonts.aBeeZee(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          onChanged: (String value) {
                                            setState(() {
                                              sGenero = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                valida == "v"
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        "¿Tiene Microchip?",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      value: isSwitchedMicrochip,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitchedMicrochip = value;
                                        });
                                      },
                                      activeTrackColor: HexColor("08CAF7"),
                                      activeColor: Colors.blue,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: tsPeso,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]+')),
                                  ],
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                    hintText: "Peso (Kg)",
                                    hintStyle: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13),
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
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        "¿Está esterilizado?",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      value: isSwitchedEsterilizado,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitchedEsterilizado = value;
                                        });
                                      },
                                      activeTrackColor: HexColor("08CAF7"),
                                      activeColor: Colors.blue,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            controller: tsEdad,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9]+')),
                                            ],
                                            decoration: InputDecoration(
                                              hintText: "Edad",
                                              hintStyle: GoogleFonts.aBeeZee(
                                                textStyle: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 10.0),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Este campo es requerido';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          flex: 1,
                                          child: DropdownButton<String>(
                                            value: selectedUnit,
                                            onChanged: onUnitChanged,
                                            items: units.map((unit) {
                                              return DropdownMenuItem<String>(
                                                value: unit,
                                                child: Text(unit),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
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
