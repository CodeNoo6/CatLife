import 'dart:convert';
import 'dart:io';

import 'package:catage/Login/PasswordView.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../Database/Database.dart';
import '../Modelo/Propietario.dart';
import 'LoginView.dart';

class RegistryView extends StatefulWidget {
  const RegistryView({Key key}) : super(key: key);

  @override
  State<RegistryView> createState() => _RegistryViewState();
}

class _RegistryViewState extends State<RegistryView> {
  final _formKeyThree = GlobalKey<FormState>();
  File _imageProp;
  String validaImageDos = "va";
  TextEditingController tsCorreo = TextEditingController();
  TextEditingController tsNombreApellido = TextEditingController();
  TextEditingController tsCelular = TextEditingController();
  TextEditingController tsPais = TextEditingController();
  TextEditingController tsDireccion = TextEditingController();
  String _selectedCountry;
  List<String> _countries = [
    'Selecciona tu país',
    'Argentina',
    'Brasil',
    'Chile',
    'Colombia',
    'México',
  ];
  Propietario objPropietario = new Propietario();

  Future getImage(ImageSource source, String imagen) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 2, 40),
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
                              'Mediante nuestra red de apoyo usaremos tu contacto si tu mascota se pierde',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Form(
                  key: _formKeyThree,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            _imageProp != null
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
                                                FileImage(_imageProp),
                                          ),
                                        ),
                                        onPressed: () => getImage(
                                            ImageSource.gallery,
                                            "propietario")),
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
                                            backgroundColor: HexColor("08CAF7"),
                                            child: Text(
                                              'Tu foto',
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
                                            ImageSource.gallery,
                                            "propietario")),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            validaImageDos == "v"
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
                      TextFormField(
                        controller: tsCorreo,
                        keyboardType: TextInputType
                            .emailAddress, // Tipo de teclado para correos electrónicos
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Tu correo electrónico",
                          hintStyle: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es requerido';
                          }
                          // Validar el correo electrónico
                          if (!EmailValidator.validate(value)) {
                            return 'Ingresa un correo electrónico válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: tsNombreApellido,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$")),
                        ],
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Tu nombre y apellido",
                          hintStyle: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
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
                      TextFormField(
                        controller: tsCelular,
                        keyboardType: TextInputType
                            .phone, // Tipo de teclado para números de teléfono
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Tu celular",
                          hintStyle: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es requerido';
                          }
                          if (value.length < 7) {
                            return 'Ingresa un número de celular válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        decoration: InputDecoration(
                          hintText: 'Selecciona tu país',
                          hintStyle:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
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
                              value == 'Selecciona tu país') {
                            return 'Selecciona tu país';
                          }
                          return null;
                        },
                        isExpanded: true,
                        items: _countries
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                )),
                          );
                        }).toList(),
                        hint: Align(
                            alignment: Alignment.center,
                            child: Text(_countries[0],
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13))),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: tsDireccion,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Tu dirección",
                          hintStyle: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
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
                      GestureDetector(
                        onTap: () async {
                          _formKeyThree.currentState.validate();
                          String correoExistente =
                              await Database.verificarCorreoExistente(
                                  tsCorreo.text);

                          if (correoExistente != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                    'Usuario yá registrado.\nPor favor, intenta iniciar sesión o recupera tu contraseña.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginView(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: HexColor("EC6337"),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Iniciar sesión",
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
                                  ],
                                );
                              },
                            );
                          } else {
                            if (validaImageDos == "va") {
                              setState(() {
                                validaImageDos = "v";
                              });
                            } else {
                              setState(() {
                                validaImageDos = "";
                              });
                            }
                            if (_formKeyThree.currentState.validate()) {
                              var bytesTwo = await _imageProp.readAsBytes();
                              var base64imgTwo = base64Encode(bytesTwo);
                              objPropietario.foto = base64imgTwo;
                              objPropietario.correo = tsCorreo.text;
                              objPropietario.nombreApellido =
                                  tsNombreApellido.text;
                              objPropietario.celular =
                                  int.parse(tsCelular.text);
                              objPropietario.pais = _selectedCountry;
                              objPropietario.direccion = tsDireccion.text;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PasswordView(
                                    objPropietario: objPropietario,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor("EC6337"),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Registrarse",
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
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿Ya tienes una cuenta? ",
                              style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginView(),
                                  ),
                                );
                              },
                              child: Text(
                                "Inicia sesión ahora",
                                style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ])));
  }
}
