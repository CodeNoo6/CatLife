import 'package:catage/Database/Database.dart';
import 'package:catage/Recuperacion/NewPassword.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Login/RegistryView.dart';

class VerificationPage extends StatefulWidget {
  final String correo;

  VerificationPage({@required this.correo});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  final _formKeyThree = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 244, 253),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Desactiva la flecha de devolución
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BubbleSpecialOne(
                                text:
                                    'Te envie al correo un código de verificación',
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
                                text: 'En ocasiones queda en Spam',
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
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKeyThree,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            maxLength: 4,
                            controller: _codeController,
                            keyboardType: TextInputType
                                .phone, // Tipo de teclado para números de teléfono
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "Código",
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
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es requerido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        if (_formKeyThree.currentState.validate()) {
                          String code = _codeController.text;
                          bool codeValid =
                              await Database.validarCodigoVerificacion(
                                  widget.correo, code);
                          if (codeValid) {
                            print('Código válido: $code');
                            await Database.eliminarCodigoVerificacion(
                                widget.correo);
                            print('Código eliminado de la base de datos');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => NewPassword(
                                  correo: widget.correo,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                    'Código invalido.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor("EC6337"),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Verificar",
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
