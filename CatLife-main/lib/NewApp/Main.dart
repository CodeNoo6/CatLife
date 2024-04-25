import 'dart:async';
import 'package:catage/Database/Database.dart';
import 'package:catage/Registro.dart';
import 'package:catage/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Modelo/Gato.dart';
import '../Modelo/Propietario.dart';
import '../Shorcut.dart';
import '../Utilities/Utilities.dart';
import '../generated/l10n.dart';
import '../pets/VacunasGPublic.dart';
import '../testMessaging/eje.dart';
import '../testMessaging/firebase_api.dart';
import 'IntroPage.dart';
import 'MenuPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*await NotificationController.initializeLocalNotifications(debug: true);
  await NotificationController.initializeRemoteNotifications(debug: true);
  await NotificationController.initializeIsolateReceivePort();
  await NotificationController.getInitialNotificationAction();*/
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final quickActions = QuickActions();

  String shortcut = 'no action set';

  String correo;

  Map<String, List<Map<String, dynamic>>> datos;

  Future<void> _initializeData() async {
    await Utilities.guardaTips("");
    correo = await Utilities.obtenerCorreo();
    datos = await Database.obtenerFundacionesYFelinos();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        Uri uri = Uri.parse(settings.name);
        String path = uri.path;
        String id = uri.queryParameters['id'];
        if (path == '/') {
          return MaterialPageRoute(
              builder: (_) => MaterialApp(
                      localizationsDelegates: [
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        S.delegate,
                      ],
                      supportedLocales: S.delegate.supportedLocales,
                      debugShowCheckedModeBanner: false,
                      home: FutureBuilder(
                        future: _initializeData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Muestra una pantalla de carga mientras se inicializan los datos
                            return Scaffold(
                              body: Center(
                                child: SplashScreen(),
                              ),
                            );
                          } else {
                            // Una vez que la inicialización se completa, decide qué página mostrar
                            if (correo != null) {
                              // Si se obtuvo el correo, muestra MenuPage()
                              return MenuPage(data: datos);
                            } else {
                              // Si no se pudo obtener el correo, muestra IntroPage()
                              return IntroPage();
                            }
                          }
                        },
                      )));
        } else if (path == '/deep.php/' && id != null) {
          return MaterialPageRoute(
              builder: (_) => VacunasGPublic(
                    id: id,
                  ));
        } else {
          return MaterialPageRoute(builder: (_) => MenuPage());
        }
      },
    );
  }
}
