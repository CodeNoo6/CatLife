import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'eje.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*await NotificationController.initializeLocalNotifications(debug: true);
  await NotificationController.initializeRemoteNotifications(debug: true);
  await NotificationController.initializeIsolateReceivePort();
  await NotificationController.getInitialNotificationAction();*/
  Notification.createNewNotification();
}

class Notification {
  static Timer _timer;

  static void createNewNotification() {
    // Cancela el temporizador anterior si existe
    _cancelNotification();

    // Define la hora específica para mostrar la notificación (por ejemplo, 1 hora)
    const Duration notificationDelay = Duration(seconds: 1);

    // Programa la notificación para dentro de la hora específica
    _timer = Timer(notificationDelay, () {
      // NotificationController.createNewNotification();
      _showNotification();
    });
  }

  static void _showNotification() {
    // Aquí puedes agregar la lógica para mostrar la notificación
    print('Notificación programada');
  }

  static void _cancelNotification() {
    // Cancela el temporizador anterior si existe
    _timer?.cancel();
  }
}
