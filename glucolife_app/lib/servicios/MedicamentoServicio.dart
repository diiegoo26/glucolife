import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucolife_app/modelos/medicamento.dart';

class MedicamentoServicio {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lista de medicamentos del usuario.
  List<Medicamento> medicamentos = [];

  /// Agrega un medicamento a la base de datos de Firebase.
  ///
  /// [medicamento]: El medicamento que se va a agregar.
  ///
  /// Muestra excepciones cuando el usuario no se encuentra autentificado o cuando no se puede almacenar el alimento en Firebase
  static Future<void> agregarMedicamentoAFirebase(Medicamento medicamento) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference coleccionMedicamentos =
        firestore.collection('medicamentos');

        await coleccionMedicamentos.add({
          'usuario': uid,
          'nombre': medicamento.nombre,
          'dosis': medicamento.dosis,
          'recordatorio': medicamento.intervalo,
        });
      } else {
        print('Usuario no autenticado');
      }
    } catch (error) {
      print('Error al almacenar en Firebase: $error');
    }
  }

  /// Elimina un medicamento de la base de datos de Firebase.
  ///
  /// [documentId]: El ID del documento del medicamento que se va a eliminar.
  ///
  /// Devuelve una excepcion cuando no se puede eliminar el medicamente de Firebase
  static Future<void> eliminarMedicamentos(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('medicamentos')
          .doc(documentId)
          .delete();
    } catch (error) {
      print("Error al eliminar");
    }
  }
}
