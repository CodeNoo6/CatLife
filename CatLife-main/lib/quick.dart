import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

import 'Shorcut.dart';

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'QuickActions Example';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final quickActions = QuickActions();
  String shortcut = 'no action set';

  @override
  void initState() {
    super.initState();

    initQuickActions();
  }

  void initQuickActions() {
    quickActions.initialize((type) {
      if (type == null) return;

      if (type == ShortcutItems.accionVacuna.type) {
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Text(
            'Shortcut $shortcut',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
}
