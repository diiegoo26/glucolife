import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:intl/intl.dart';

class ActividadServicio {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Guarda la actividad en Firebase.
  ///
  /// [ejercicio]: La actividad a ser guardada.
  /// [fechaSeleccionada]: Indica la fecha de cuando ha sido registrada
  ///
  /// Muestra excepciones cuando el usuario no se encuentra autentificado o cuando no se puede almacenar en Firebase
  Future<void> guardarActividadEnFirebase(Actividad ejercicio,DateTime fechaSeleccionada) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        await _firestore.collection('actividades').add({
          'usuario': uid,
          'nombre': ejercicio.nombre,
          'tiempoRealizado': ejercicio.tiempoRealizado,
          'intensidad': ejercicio.intensidad,
          'caloriasQuemadas': ejercicio.caloriasQuemadas,
          'fechaRegistro': DateFormat('yyyy-MM-dd').format(fechaSeleccionada),
        });
      } else {
        throw 'Usuario no autenticado';
      }
    } catch (error) {
      throw 'Error al almacenar en Firebase: $error';
    }
  }

  /// Elimina una actividad de Firebase dado su ID de documento.
  ///
  /// [documentId]: ID del documento de la actividad a ser eliminada.
  ///
  /// Devuelve una excepcion cuando no se puede eliminar de Firebase
  Future<void> eliminarActividad(String documentId) async {
    try {
      await _firestore.collection('actividades').doc(documentId).delete();
    } catch (error) {
      throw 'Error al borrar la actividad: $error';
    }
  }
  /// Calcula las calorías quemadas durante una actividad.
  ///
  /// [tiempo]: Tiempo dedicado a la actividad en formato de texto.
  /// [intensidad]: Nivel de intensidad de la actividad.
  ///
  /// Retorna la cantidad de calorías quemadas.
  double calcularCaloriasQuemadas(String tiempo, String intensidad) {
    double factorIntensidad = 0.0;

    switch (intensidad) {
      case 'Alta':
        factorIntensidad = 2.0;
        break;
      case 'Moderada':
        factorIntensidad = 1.5;
        break;
      case 'Baja':
        factorIntensidad = 1.0;
        break;
      default:
        factorIntensidad = 1.0;
        break;
    }

    double tiempoRealizado = double.tryParse(tiempo.split(' ')[0]) ?? 0.0;
    double caloriasQuemadas = tiempoRealizado * factorIntensidad;
    return caloriasQuemadas;
  }

}
