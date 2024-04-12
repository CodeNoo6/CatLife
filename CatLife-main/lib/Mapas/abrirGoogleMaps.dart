import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

//void main() => runApp(MapLauncherDemo());

class MapLauncherDemo extends StatelessWidget {
  openMapsSheet(context) async {
    final availableMaps = await MapLauncher.installedMaps;
    availableMaps.forEach((element) {
      print(element.icon);
      print(element.mapName);
    });
    await availableMaps.first.showMarker(
        coords: Coords(4.6270162, -74.0729415),
        title: 'ejemplo',
        description: 'description ejemplo');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map Launcher Demo'),
        ),
        body: Center(child: Builder(
          builder: (context) {
            return MaterialButton(
              onPressed: () => openMapsSheet(context),
              child: Text('Show Maps'),
            );
          },
        )),
      ),
    );
  }
}
