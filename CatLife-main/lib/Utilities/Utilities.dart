import 'package:shared_preferences/shared_preferences.dart';

class Utilities {
  static Future<void> guardaCorreo(correo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('correo', correo);
  }

  static Future<String> obtenerCorreo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String correo = pref.getString('correo');
    return correo;
  }
}
