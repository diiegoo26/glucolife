import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeServicio {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Guarda los datos de glucosa en Firebase.
  ///
  /// [valorGlucosa]: Valor de glucosa a ser guardado.
  ///
  /// Devuelve excepcion cuando el usuario no está logueado o no se puede almacenar el valor en Firebase
  Future<void> guardarDatosGlucosa(double valorGlucosa) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('sensor').add({
          'userId': user.uid,
          'hora': DateTime.now(),
          'valor': valorGlucosa,
        });
      } else {
        print('Usuario no autenticado');
      }
    } catch (e) {
      print('Error al guardar datos en Firebase: $e');
    }
  }

  /// Obtiene el valor de hiperglucemia del usuario actual.
  ///
  /// Retorna el valor de hiperglucemia.
  ///
  /// Devuelve excepcion cuando el usuario no está logueado o no se puede recuperar el valor en Firebase
  Future<double> obtenerHiperglucemia() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
        await _firestore.collection('usuarios').doc(user.uid).get();

        if (userSnapshot.exists) {
          double hiperglucemia = userSnapshot.get('hiperglucemia');
          return hiperglucemia;
        } else {
          print('El documento no existe para el usuario actual');
          return 0.0;
        }
      } else {
        print('Usuario no autenticado');
        return 0.0;
      }
    } catch (e) {
      print('Error al obtener hiperglucemia: $e');
      return 0.0;
    }
  }

  /// Obtiene el valor de hipoglucemia del usuario actual.
  ///
  /// Retorna el valor de hipoglucemia.
  ///
  /// Devuelve excepcion cuando el usuario no está logueado o no se puede recuperar el valor en Firebase
  Future<double> obtenerHipoglucemia() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
        await _firestore.collection('usuarios').doc(user.uid).get();

        if (userSnapshot.exists) {
          double hipoglucemia = userSnapshot.get('hipoglucemia');
          return hipoglucemia;
        } else {
          print('El documento no existe para el usuario actual');
          return 0.0;
        }
      } else {
        print('Usuario no autenticado');
        return 0.0;
      }
    } catch (e) {
      print('Error al obtener hipoglucemia: $e');
      return 0.0;
    }
  }
}
