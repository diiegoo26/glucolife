import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucolife_app/modelos/recordatorio.dart';

class RecordatorioServicio {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lista de recordatorios.
  List<Recordatorio> recordatorios = [];

  /// Agrega un nuevo recordatorio a Firebase.
  ///
  /// [recordatorio]: El recordatorio a agregar.
  ///
  /// Muestra excepciones cuando el usuario no se encuentra autentificado o cuando no se puede almacenar el alimento en Firebase
  static Future<void> agregarRecordatorioAFirebase(Recordatorio recordatorio) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference coleccionRecordatorio = firestore.collection('recordatorio');

        await coleccionRecordatorio.add({
          'usuario': uid,
          'descripcion': recordatorio.descripcion,
          'fecha': recordatorio.fecha,
        });

      } else {
        print('Usuario no autenticado');
      }
    } catch (error) {
      print('Error al almacenar en Firebase: $error');
    }
  }

  /// Elimina un recordatorio de Firebase.
  ///
  /// [documentId]: El ID del documento del recordatorio a eliminar.
  ///
  /// Devuelve una excepcion cuando no se puede eliminar correctame el recordatorio
  static Future<void> eliminarRecordatorio(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recordatorio')
          .doc(documentId)
          .delete();
    } catch (error) {
      print("Error al borrar");
    }
  }
}
