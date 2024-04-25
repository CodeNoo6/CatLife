import 'dart:convert';
import 'dart:ffi';

import 'package:catage/Utilities/Utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Modelo/Fundacion.dart';
import '../Modelo/Gato.dart';
import '../Modelo/Propietario.dart';
import '../Modelo/Vacuna.dart';

List contacts;

class Database {
  static Future<void> guardarCodigoVerificacion(
      String email, String verificationCode) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('verification_codes').doc(email);

    try {
      await documentReference.set({
        'verification_codes': FieldValue.arrayUnion([verificationCode]),
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error al guardar el código de verificación: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerFelinoId(
      String felinoId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> felinosEncontrados = [];

    for (var doc in querySnapshot.docs) {
      List<dynamic> felinosData = doc.data()['Felinos'] ?? [];

      for (var felino in felinosData) {
        if (felino['FelinoId'] == felinoId) {
          felinosEncontrados.add({
            'propietario': doc.data()['Propietario'] ?? {},
            'felino': felino
          });
        }
      }
    }

    return felinosEncontrados;
  }

  static Future<bool> validarCodigoVerificacion(
      String email, String verificationCode) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('verification_codes')
            .doc(email)
            .get();

    if (!documentSnapshot.exists) {
      return false;
    }

    final List<dynamic> verificationCodes =
        documentSnapshot.data()['verification_codes'];

    return verificationCodes.contains(verificationCode);
  }

  static Future<void> eliminarCodigoVerificacion(String email) async {
    await FirebaseFirestore.instance
        .collection('verification_codes')
        .doc(email)
        .delete();
  }

  static Future<String> verificarCorreoExistente(String correo) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(correo).get();
    if (snapshot.exists) {
      return snapshot.id;
    } else {
      return null;
    }
  }

  static Future<bool> validarPropietario(
      String correo, String contrasena) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(correo)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String contrasenaAlmacenada = data["Propietario"]['Contrasena'];
        if (contrasenaAlmacenada == contrasena) {
          return true;
        } else {
          return false;
        }
      } else {
        print('No se encontró ningún propietario con el correo especificado.');
        return false;
      }
    } catch (e) {
      print('Error al validar el propietario: $e');
      return false;
    }
  }

  static Future<Propietario> obtenerPropietario() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(await Utilities.obtenerCorreo())
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        Propietario propietario = Propietario(
          foto: data['Foto'],
          correo: data['Correo'],
          nombreApellido: data['NombreApellido'],
          celular: data['Celular'],
          pais: data['Pais'],
          direccion: data['Direccion'],
          contrasena: data['Contrasena'],
        );

        return propietario;
      } else {
        print('No se encontró ningún propietario con el correo especificado.');
        return null;
      }
    } catch (e) {
      print('Error al obtener el propietario: $e');
      return null;
    }
  }

  static Future<void> registroPropietario(Propietario objPropietario) async {
    DocumentReference userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(objPropietario.correo);

    final json = {
      'Foto': objPropietario.foto,
      'Correo': objPropietario.correo,
      'NombreApellido': objPropietario.nombreApellido,
      'Celular': objPropietario.celular,
      'Pais': objPropietario.pais,
      'Direccion': objPropietario.direccion,
      'Contrasena': objPropietario.contrasena,
    };

    await userSnapshot.set({'Propietario': json});
  }

  static Future<void> actualizarContrasena(
      String correo, String nuevaContrasena) async {
    try {
      // Obtén la referencia al documento del usuario
      DocumentReference userSnapshot =
          FirebaseFirestore.instance.collection('users').doc(correo);

      // Actualiza el campo de contraseña
      await userSnapshot.update({
        'Propietario.Contrasena': nuevaContrasena,
      });

      print('Contraseña actualizada exitosamente');
    } catch (e) {
      print('Error al actualizar la contraseña: $e');
    }
  }

  static Future<void> registroFelino(Gato objGato) async {
    // Obtener una referencia al documento del usuario actual
    DocumentReference userSnapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(await Utilities.obtenerCorreo());

    String felinoId = userSnapshot.collection('Felinos').doc().id;

    final json = {
      'FelinoId': felinoId,
      'Foto': objGato.foto,
      'Nombre': objGato.nombre,
      'Especie': objGato.especie,
      'FechaNacimiento': objGato.fechaNacimiento,
      'Raza': objGato.raza,
      'Color': objGato.color,
      'Genero': objGato.genero,
      'Microchip': objGato.microchip,
      'Peso': objGato.peso,
      'Esterilizado': objGato.esterilizado,
      'EdadMeses': objGato.edadMeses
    };

    await userSnapshot.update({
      'Felinos': FieldValue.arrayUnion([json])
    });
  }

  static Future<Map<String, dynamic>> obtenerFelinos() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(await Utilities.obtenerCorreo())
            .get();

    if (querySnapshot.exists) {
      Map<String, dynamic> propietarioFelinos = {};
      propietarioFelinos['propietario'] =
          querySnapshot.data()['Propietario'] ?? {};

      List<Map<String, dynamic>> felinos = [];

      List<dynamic> felinosData = querySnapshot.data()['Felinos'] ?? [];

      felinosData.forEach((felino) {
        felinos.add(felino);
      });

      propietarioFelinos['felinos'] = felinos;

      return propietarioFelinos;
    } else {
      return {};
    }
  }

  static Future<void> registroFelinoAdoptado(
      Gato objGato, Fundacion objFundacion) async {
    String nombreFundacion = objFundacion.nombre.replaceAll(' ', '');
    DocumentReference fundacionRef =
        FirebaseFirestore.instance.collection('Adopcion').doc(nombreFundacion);

    // Crea un mapa con los datos de la fundación
    Map<String, dynamic> fundacionData = {
      'Nombre': objFundacion.nombre,
      'Latitud': objFundacion.latitud,
      'Longitud': objFundacion.longitud,
      'Descripción': objFundacion.descripcion,
      'Celular': objFundacion.celular,
    };

    // Crea un mapa con los datos del gato
    Map<String, dynamic> gatoData = {
      'Foto': objGato.foto,
      'Nombre': objGato.nombre,
      'Especie': objGato.especie,
      'FechaNacimiento': objGato.fechaNacimiento,
      'Raza': objGato.raza,
      'Color': objGato.color,
      'Genero': objGato.genero,
      'Microchip': objGato.microchip,
      'Peso': objGato.peso,
      'Esterilizado': objGato.esterilizado,
      'EdadMeses': objGato.edadMeses,
    };

    // Verifica si la fundación ya existe en la base de datos
    DocumentSnapshot fundacionSnapshot = await fundacionRef.get();
    if (fundacionSnapshot.exists) {
      // La fundación ya existe, agrega el gato a la lista de felinos adoptados
      await fundacionRef.update({
        'Fundacion': fundacionData,
        'Felinos': FieldValue.arrayUnion([gatoData]),
      });
    } else {
      // La fundación no existe, crea un nuevo documento para la fundación
      await fundacionRef.set({
        'Fundacion': fundacionData,
        'Felinos': [gatoData],
      });
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerTodasFundaciones() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Adopcion').get();

    List<Map<String, dynamic>> fundaciones = [];

    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> fundacionData = doc.data();
      fundaciones.add(fundacionData);
    }

    return fundaciones;
  }

  static Future<Map<String, List<Map<String, dynamic>>>>
      obtenerFundacionesYFelinos() async {
    // Obtener todas las fundaciones
    QuerySnapshot fundacionesSnapshot =
        await FirebaseFirestore.instance.collection('Adopcion').get();

    // Inicializar un mapa para almacenar las fundaciones y sus felinos correspondientes
    Map<String, List<Map<String, dynamic>>> fundacionesConFelinos = {};

    // Iterar sobre cada fundación
    for (DocumentSnapshot fundacionDoc in fundacionesSnapshot.docs) {
      String nombreFundacion =
          fundacionDoc.id; // Obtener el nombre de la fundación

      // Obtener los felinos de la fundación actual
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Adopcion')
              .doc(nombreFundacion)
              .get();

      if (querySnapshot.exists) {
        // Obtener los datos de la fundación
        Map<String, dynamic> datosFundacion =
            querySnapshot.data()['Fundacion'] ?? {};

        // Convertir los datos de los felinos en una lista de mapas
        List<dynamic> felinosData = querySnapshot.data()['Felinos'] ?? [];
        List<Map<String, dynamic>> felinos = felinosData
            .map((felino) => Map<String, dynamic>.from(felino))
            .toList();
        fundacionesConFelinos[nombreFundacion] = [
          {'fundacion': datosFundacion},
          ...felinos,
        ];
      }
    }

    // Retornar el mapa con todas las fundaciones y sus felinos correspondientes
    return fundacionesConFelinos;
  }

  static Future<Map<String, dynamic>> obtenerTodosLosFelinosAdoptados() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Adopcion').get();

    Future<Map<String, dynamic>> felinos;

    querySnapshot.docs.forEach((doc) {
      felinos = obtenerFelinosAdoptados(doc.id);
    });

    return felinos;
  }

  static Future<Map<String, dynamic>> obtenerFelinosAdoptados(
      String nombreFundacion) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Adopcion')
              .doc(nombreFundacion)
              .get();

      if (querySnapshot.exists) {
        Map<String, dynamic> fundacionFelinos = {};
        fundacionFelinos['fundacion'] = querySnapshot.data()['Fundacion'] ?? {};

        List<Map<String, dynamic>> felinos = [];

        List<dynamic> felinosData = querySnapshot.data()['Felinos'] ?? [];

        felinosData.forEach((felino) {
          felinos.add(Map<String, dynamic>.from(felino));
        });

        fundacionFelinos['felinos'] = felinos;

        return fundacionFelinos;
      } else {
        return {}; // Retorna un mapa vacío si no se encuentra la fundación
      }
    } catch (e) {
      print('Error al obtener felinos adoptados: $e');
      return {};
    }
  }

  static Future<void> agregarVacunaAFelino(
      String felinoId, Vacuna nuevaVacuna) async {
    DocumentReference userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(await Utilities.obtenerCorreo());

    Map<String, dynamic> vacuna = {
      'felino': felinoId,
      'nVacuna': nuevaVacuna.nombre,
      'fAplicacion': nuevaVacuna.fechaAplicacion,
      'veterinario': nuevaVacuna.nombreVeterinario,
      'frecuencia': nuevaVacuna.proximAplicacion,
      'dosis': nuevaVacuna.dosis,
      'codigoVet': nuevaVacuna.codigoVet
    };

    await userSnapshot.update({
      'Vacunas': FieldValue.arrayUnion([vacuna])
    });
  }

  static Future<void> eliminarVacunaPorNombre(
      String felinoId, String nombreVacuna) async {
    DocumentReference userSnapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(await Utilities.obtenerCorreo());

    // Obtener el documento del usuario
    DocumentSnapshot userData = await userSnapshot.get();

    // Verificar si existe el documento y si contiene el campo Vacunas
    if (userData.exists && userData.data() != null) {
      Map<String, dynamic> userDataMap =
          userData.data() as Map<String, dynamic>;

      // Verificar si el campo Vacunas existe y no es nulo
      if (userDataMap.containsKey('Vacunas') &&
          userDataMap['Vacunas'] != null) {
        List<dynamic> vacunas = List.from(userDataMap['Vacunas']);

        // Filtrar la lista de vacunas para encontrar la que se desea eliminar por su nombre
        List<dynamic> nuevasVacunas = vacunas
            .where((vacuna) => vacuna['nVacuna'] == nombreVacuna)
            .toList();

        // Si se encontró la vacuna, eliminarla y actualizar el documento del usuario
        if (nuevasVacunas.isNotEmpty) {
          vacunas.removeWhere((vacuna) => vacuna['nVacuna'] == nombreVacuna);
          await userSnapshot.update({'Vacunas': vacunas});
        } else {
          // Si no se encontró ninguna vacuna con ese nombre, puedes manejarlo como desees
          print('No se encontró ninguna vacuna con el nombre especificado.');
        }
      } else {
        // Si el campo Vacunas no está presente o es nulo, puedes manejarlo como desees
        print('El campo Vacunas no está presente o es nulo.');
      }
    } else {
      // Si el documento del usuario no existe o es nulo, puedes manejarlo como desees
      print('No se encontró el documento del usuario o es nulo.');
    }
  }

  static Future<void> aplicarVacuna(
    String felinoId,
    String nombreVacuna,
    String veterinario,
    int codigoVet,
    String correo,
    int dosisActual,
    String frecuencia,
  ) async {
    try {
      CollectionReference aplicacionesCollection =
          FirebaseFirestore.instance.collection('aplicaciones');

      // Obtener una referencia al documento de la vacuna existente o crear uno nuevo si no existe
      DocumentReference vacunaDoc = aplicacionesCollection.doc(nombreVacuna);
      DocumentSnapshot vacunaSnapshot = await vacunaDoc.get();

      if (vacunaSnapshot.exists) {
        // Si el documento de la vacuna ya existe, actualizar el arreglo "aplicaciones"
        await vacunaDoc.update({
          'aplicaciones': FieldValue.arrayUnion([
            {
              'felinoId': felinoId,
              'veterinario': veterinario,
              'codigoVet': codigoVet,
              'dosis': dosisActual,
              'frecuencia': frecuencia,
              'fechaAplicacion': DateTime.now(),
            }
          ])
        });
        await actualizarDosis(felinoId, nombreVacuna, correo);
      } else {
        // Si el documento de la vacuna no existe, crear uno nuevo con el arreglo "aplicaciones"
        await vacunaDoc.set({
          'felinoId': felinoId,
          'nombreVacuna': nombreVacuna,
          'aplicaciones': [
            {
              'felinoId': felinoId,
              'veterinario': veterinario,
              'codigoVet': codigoVet,
              'dosis': dosisActual,
              'frecuencia': frecuencia,
              'fechaAplicacion': DateTime.now(),
            }
          ]
        });
      }
    } catch (e) {
      print('Error al aplicar la vacuna: $e');
      throw Exception(
          'Hubo un error al aplicar la vacuna. Por favor, inténtalo de nuevo.');
    }
  }

  static Future<void> actualizarDosis(
    String felinoId,
    String nombreVacuna,
    String correo,
  ) async {
    try {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(correo);

      DocumentSnapshot userSnapshot = await userDoc.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      List<dynamic> vacunas = userData['Vacunas'];
      var vacunaExistente =
          vacunas.firstWhere((vacuna) => vacuna['nVacuna'] == nombreVacuna);

      // Aumentar la dosis en 1
      int dosisActual = vacunaExistente['dosis'] ?? 0;
      vacunaExistente['dosis'] = dosisActual + 1;

      // Actualizar el documento en la base de datos con las vacunas modificadas
      await userDoc.update({
        'Vacunas': vacunas,
      });
    } catch (e) {
      print('Error al aplicar la vacuna: $e');
      throw Exception(
          'Hubo un error al aplicar la vacuna. Por favor, inténtalo de nuevo.');
    }
  }

  static Future<Map<String, dynamic>> validaRegistro() async {
    final DocumentReference documents = await FirebaseFirestore.instance
        .collection('users')
        .doc(await Utilities.obtenerCorreo());
    DocumentSnapshot snapshot = await documents.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data;
  }

  static Future<List<Map<String, dynamic>>> obtenerVacunas() async {
    final DocumentReference userDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(await Utilities.obtenerCorreo());
    DocumentSnapshot snapshot = await userDocument.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    try {
      List<Map<String, dynamic>> vacunas =
          List<Map<String, dynamic>>.from(userData["Vacunas"]);
      if (vacunas.isEmpty) {
        return null;
      }
      return vacunas;
    } catch (Exception) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerVacunasByEmail(
      String correo) async {
    final DocumentReference userDocument =
        FirebaseFirestore.instance.collection('users').doc(correo);
    DocumentSnapshot snapshot = await userDocument.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    try {
      List<Map<String, dynamic>> vacunas =
          List<Map<String, dynamic>>.from(userData["Vacunas"]);
      if (vacunas.isEmpty) {
        return null;
      }
      return vacunas;
    } catch (Exception) {
      return null;
    }
  }

  static Future<bool> eliminarVacuna(String nVacuna) async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc(await Utilities.obtenerCorreo());

    DocumentSnapshot snapshot = await collection.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    List<Map<String, dynamic>> vacunas =
        List<Map<String, dynamic>>.from(userData["Vacunas"]);
    vacunas.removeWhere((vacuna) => vacuna['nVacuna'] == nVacuna);

    await collection.update({'Vacunas': vacunas});
  }

  static Future<bool> eliminarFelino(String nFelino) async {
    try {
      var userEmail = await Utilities.obtenerCorreo();
      if (userEmail == null) {
        throw Exception(
            'No se pudo obtener el correo electrónico del usuario.');
      }

      var collection =
          FirebaseFirestore.instance.collection('users').doc(userEmail);

      DocumentSnapshot snapshot = await collection.get();
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      if (userData == null || !userData.containsKey("Felinos")) {
        throw Exception(
            'No se encontró la lista de felinos en los datos del usuario.');
      }

      List<Map<String, dynamic>> felinos =
          List<Map<String, dynamic>>.from(userData["Felinos"]);
      felinos.removeWhere((felino) => felino["Nombre"] == nFelino);

      await collection.update({'Felinos': felinos});

      // Eliminar vacunas asociadas al felino eliminado
      List<Map<String, dynamic>> vacunas =
          List<Map<String, dynamic>>.from(userData["Vacunas"]);
      vacunas.removeWhere((vacuna) => vacuna['felino'] == nFelino);
      await collection.update({'Vacunas': vacunas});

      return true; // La eliminación fue exitosa
    } catch (error) {
      print('Error al eliminar el felino: $error');
      return false; // La eliminación falló
    }
  }
}
