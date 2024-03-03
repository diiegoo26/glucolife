import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarDatosGlucosa(double y1) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('sensor').add({
          'userId': user.uid,
          'hora': DateTime.now(),
          'valor': y1,
        });
      } else {
        // Manejar el caso cuando el usuario no está autenticado
        print('Usuario no autenticado');
      }
    } catch (e) {
      print('Error al guardar datos en Firebase: $e');
      // Manejar el error según tus necesidades
    }
  }

  Future<double> obtenerHiperglucemia() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
        await _firestore.collection('usuarios').doc(user.uid).get();

        // Verificar si el documento existe antes de intentar acceder al campo
        if (userSnapshot.exists) {
          // Obtener el valor del campo "hiperglucemia"
          double hiperglucemia = userSnapshot.get('hiperglucemia');
          // Hacer algo con el valor de "hiperglucemia", por ejemplo, imprimirlo
          return hiperglucemia;
        } else {
          print('El documento no existe para el usuario actual');
          return 0.0; // Otra acción o valor predeterminado según tu lógica
        }
      } else {
        print('Usuario no autenticado');
        return 0.0; // Otra acción o valor predeterminado según tu lógica
      }
    } catch (e) {
      print('Error al obtener hiperglucemia: $e');
      return 0.0; // Otra acción o valor predeterminado según tu lógica
    }
  }

  Future<double> obtenerHipoglucemia() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
        await _firestore.collection('usuarios').doc(user.uid).get();

        // Verificar si el documento existe antes de intentar acceder al campo
        if (userSnapshot.exists) {
          // Obtener el valor del campo "hiperglucemia"
          double hipoglucemia = userSnapshot.get('hipoglucemia');
          // Hacer algo con el valor de "hiperglucemia", por ejemplo, imprimirlo
          return hipoglucemia;
        } else {
          print('El documento no existe para el usuario actual');
          return 0.0; // Otra acción o valor predeterminado según tu lógica
        }
      } else {
        print('Usuario no autenticado');
        return 0.0; // Otra acción o valor predeterminado según tu lógica
      }
    } catch (e) {
      print('Error al obtener hiperglucemia: $e');
      return 0.0; // Otra acción o valor predeterminado según tu lógica
    }
  }
}
