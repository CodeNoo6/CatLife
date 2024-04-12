import 'package:catage/Login/RegistryView.dart';
import 'package:catage/NewApp/MenuPage.dart';
import 'package:catage/Recuperacion/SendCode.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Database/Database.dart';
import '../NewApp/BuildingPage.dart';
import '../Registro.dart';
import '../Utilities/Utilities.dart'; // Importa la clase Database

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKeyThree = GlobalKey<FormState>();
  TextEditingController tsCorreo = TextEditingController();
  TextEditingController tsContrasena = TextEditingController();
  bool _showPasswordNew = false;

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
                  padding: EdgeInsets.fromLTRB(10, 10, 2, 30),
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
                        text: '¡Me alegra verte de nuevo!',
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
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKeyThree,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: tsCorreo,
                      keyboardType: TextInputType.emailAddress,
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
                      controller: tsContrasena,
                      keyboardType: TextInputType.text,
                      obscureText:
                          !_showPasswordNew, // Oculta la contraseña si showPasswordNew es false
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: "Contraseña",
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
                        suffixIcon: IconButton(
                          icon: Icon(_showPasswordNew
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _showPasswordNew =
                                  !_showPasswordNew; // Cambia el estado de showPasswordNew
                            });
                          },
                        ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SendCodeView(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(),
                          Text(
                            "¿Olvidaste la contraseña? ",
                            style: GoogleFonts.aBeeZee(
                              decoration: TextDecoration.underline,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKeyThree.currentState.validate()) {
                          bool isValid = await Database.validarPropietario(
                              tsCorreo.text, tsContrasena.text);
                          if (isValid) {
                            await Utilities.guardaCorreo(tsCorreo.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => MenuPage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Credenciales inválidas'),
                            ));
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
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿No tienes una cuenta? ",
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RegistryView(),
                                ),
                              );
                            },
                            child: Text(
                              "Registrate ahora",
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
