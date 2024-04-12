import 'package:quick_actions/quick_actions.dart';

class ShortcutItems {
  static final items = <ShortcutItem>[
    accionVacuna,
    accionTratamiento,
    accionConsulta,
    accionMiGato
  ];

  static final accionVacuna = const ShortcutItem(
    type: 'Vacuna',
    localizedTitle: 'Vacuna',
    icon: 'vaccine_cat',
  );

  static final accionTratamiento = const ShortcutItem(
    type: 'Tratamiento',
    localizedTitle: 'Tratamiento',
    icon: 'health_cat',
  );

  static final accionConsulta = const ShortcutItem(
    type: 'Consulta',
    localizedTitle: 'Consulta',
    icon: 'doctor_cat',
  );

  static final accionMiGato = const ShortcutItem(
    type: 'Mi gato',
    localizedTitle: 'Mi gato',
    icon: 'cat',
  );
}
