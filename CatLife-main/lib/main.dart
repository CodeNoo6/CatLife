/*import 'package:catage/age.dart';
import 'package:catage/age_human.dart';
import 'package:catage/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quick_actions/quick_actions.dart';
import 'NewApp/MenuPage.dart';
import 'Shorcut.dart';
import 'SplashScreen.dart';
import 'Utilities/Utilities.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final quickActions = QuickActions();
  String shortcut = 'no action set';
  String correo;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await initQuickActions();
    correo = await Utilities.obtenerCorreo();
    setState(() {});
  }

  void initQuickActions() {
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
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        home: correo != null ? MenuPage() : SplashScreen(),
      );
}
*/