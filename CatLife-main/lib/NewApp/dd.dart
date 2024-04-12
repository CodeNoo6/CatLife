import 'dart:async';
import 'package:catage/Database/Database.dart';
import 'package:catage/Registro.dart';
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
import 'IntroPage.dart';
import 'MenuPage.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final quickActions = QuickActions();

  String shortcut = 'no action set';

  String correo;

  /*void initQuickActions() {
    quickActions.initialize((type) {
      if (type == null) if (type == ShortcutItems.accionVacuna.type) {
        print('Pressed: vacuna');
      } else if (type == ShortcutItems.accionTratamiento.type) {
        print('Pressed: tratamiento');
      } else if (type == ShortcutItems.accionConsulta.type) {
        print('Pressed: consulta');
      } else if (type == ShortcutItems.accionMiGato.type) {
        print('Pressed: mi gato');
      }
      setState(() {
        shortcut = type;
      });
    });

    quickActions.setShortcutItems(ShortcutItems.items);
  }*/

  Map<String, List<Map<String, dynamic>>> datos;

  Future<void> _initializeData() async {
    //await initQuickActions();
    correo = await Utilities.obtenerCorreo();
    datos = await Database.obtenerFundacionesYFelinos();
    setState(() {});
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
                    home: correo != null
                        ? MenuPage(
                            data: datos,
                          )
                        : IntroPage(),
                  ));
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
