import 'dart:math';

import 'package:catage/Login/LoginView.dart';
import 'package:catage/Login/RegistryView.dart';
import 'package:catage/NewApp/MenuPage.dart';
import 'package:catage/Recuperacion/VerificationPage.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/hotmail.dart';

import '../Database/Database.dart';
import '../Modelo/Propietario.dart';

class SendCodeView extends StatefulWidget {
  @override
  State<SendCodeView> createState() => _SendCodeViewState();
}

class _SendCodeViewState extends State<SendCodeView> {
  final _formKeyThree = GlobalKey<FormState>();
  TextEditingController tsCorreo = TextEditingController();
  final outlookSmtp = hotmail("catlifegimo@outlook.com", "Tomate123##");
  String verificationCode = '';
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return _isSending
        ? Scaffold(
            backgroundColor: Color.fromARGB(255, 230, 244, 253),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading:
                  false, // Desactiva la flecha de devolución
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
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
              automaticallyImplyLeading:
                  false, // Desactiva la flecha de devolución
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
                              text: 'Proceso de recuperación de contraseña',
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
                              if (!EmailValidator.validate(value)) {
                                return 'Ingresa un correo electrónico válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                _isSending =
                                    true; // Comienza el envío del correo
                              });
                              String correoExistente;
                              if (_formKeyThree.currentState.validate()) {
                                correoExistente =
                                    await Database.verificarCorreoExistente(
                                        tsCorreo.text);
                              }
                              if (correoExistente != null) {
                                var rng = new Random();
                                verificationCode = _generateVerificationCode();

                                await Database.guardarCodigoVerificacion(
                                    tsCorreo.text, verificationCode);

                                final message = Message()
                                  ..from = Address(
                                      "catlifegimo@outlook.com", 'Cat Life')
                                  ..recipients.add(tsCorreo.text)
                                  ..subject = '¡Hola! Tu código de verificación'
                                  ..html = '''
            <!DOCTYPE html>
            <html lang="en">
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width,initial-scale=1">
              <title>Email Verification</title>
            </head>
            <body style="background-color:#fafafa;display:flex;justify-content:center;align-items:center">
              <div class="c-email" style="width:100vw;border-radius:10px;overflow:hidden;box-shadow:0 7px 22px 0 rgba(0,0,0,.1)">
                <div class="c-email__header" style="background-color:#08caf7;width:100%;height:60px">
                  <h1 class="c-email__header__title" style="font-size:18px;font-family:'Open Sans';height:60px;line-height:60px;margin:0;text-align:center;color:#fff">Ingresa este código en tu app</h1>
                </div>
                <div class="c-email__content" style="width:100%;display:flex;flex-direction:column;justify-content:space-around;align-items:center;flex-wrap:wrap;background-color:#fff;padding:10px">
                  <div class="c-email__code" style="display:block;width:60%;margin:30px auto;background-color:#ddd;border-radius:10px;padding:2px;text-align:center;font-size:20px;font-family:'Open Sans';letter-spacing:5px;box-shadow:0 7px 22px 0 rgba(0,0,0,.1)">
                    <span class="c-email__code__text">$verificationCode</span>
                  </div>
                </div>
                <div class="c-email__footer" style="width:100%;background-color:#fff"></div>
              </div>
            </body>
            </html>
          ''';
                                try {
                                  final sendReport =
                                      await send(message, outlookSmtp);
                                  setState(() {
                                    _isSending =
                                        false; // Finaliza el envío del correo
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          VerificationPage(
                                        correo: correoExistente,
                                      ),
                                    ),
                                  );
                                } on MailerException catch (e) {
                                  print('Message not sent.');
                                  for (var p in e.problems) {
                                    print('Problem: ${p.code}: ${p.msg}');
                                  }
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                        'Usuario no encontrado.\nPor favor, registrate.',
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
                                                builder:
                                                    (BuildContext context) =>
                                                        RegistryView(),
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
                                                  "Registrarse",
                                                  style: GoogleFonts.aBeeZee(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    "Enviar código",
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

  String _generateVerificationCode() {
    var rng = Random();
    int code = rng.nextInt(9000) + 1000; // Genera un número entre 1000 y 9999
    return code.toString();
  }
}
