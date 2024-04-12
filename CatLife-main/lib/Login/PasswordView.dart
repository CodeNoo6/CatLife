import 'package:catage/Login/LoginView.dart';
import 'package:catage/NewApp/MenuPage.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Database/Database.dart';
import '../Modelo/Propietario.dart';

class PasswordView extends StatefulWidget {
  final Propietario objPropietario;

  PasswordView({@required this.objPropietario});

  @override
  State<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  final _formKeyThree = GlobalKey<FormState>();
  TextEditingController tsContrasenaNew = TextEditingController();
  TextEditingController tsContrasenaConfirm = TextEditingController();
  bool _showPasswordNew = false;
  bool _showPasswordConfirm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        text: '¡Asigna una contraseña!',
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
                      controller: tsContrasenaNew,
                      keyboardType: TextInputType.text,
                      obscureText:
                          !_showPasswordNew, // Oculta la contraseña si showPasswordNew es false
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: "Nueva contraseña",
                        hintStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: tsContrasenaConfirm,
                      keyboardType: TextInputType.text,
                      obscureText: !_showPasswordConfirm,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: "Confirmar contraseña",
                        hintStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        suffixIcon: IconButton(
                          icon: Icon(_showPasswordConfirm
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _showPasswordConfirm = !_showPasswordConfirm;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es requerido';
                        }
                        if (value != tsContrasenaNew.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        if (_formKeyThree.currentState.validate()) {
                          widget.objPropietario.contrasena =
                              tsContrasenaConfirm.text;
                          Database.registroPropietario(widget.objPropietario);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => LoginView(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¡Crear contraseña!",
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
                    SizedBox(height: 30),
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
