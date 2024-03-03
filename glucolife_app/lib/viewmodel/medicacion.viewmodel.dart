import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:glucolife_app/modelos/medicamentos.dart';
import 'package:timezone/timezone.dart' as tz;


class MedicamentoViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;

  TimeOfDay horaRecordatorio = TimeOfDay.now(); // Hora del día para el recordatorio

  // Flutter Local Notifications Plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> obtenerUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
  }

  Future<void> agregarMedicamentoAFirebase(Medicamento medicamento) async {
    try {
      // Obtener el usuario actualmente autenticado
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Si hay un usuario autenticado, obtener su UID
        String uid = currentUser.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference medicamentosCollection =
        firestore.collection('medicamentos');

        await medicamentosCollection.add({
          'usuario': uid,
          'nombre': medicamento.nombre,
          'dosis': medicamento.dosis,
          'fechaInicio': medicamento.fechaInicio,
          'frecuencia': medicamento.frecuencia,
          'diasSeleccionados': medicamento.diasSeleccionados,
          'recordatorioActivado': medicamento.recordatorioActivado,
          'horaRecordatorio': {
            'hour': medicamento.horaRecordatorio.hour,
            'minute': medicamento.horaRecordatorio.minute,
          },
          // Puedes agregar más campos según los atributos de tu clase Medicamento
        });

        // Mensaje de éxito o realizar otras acciones después de almacenar en Firebase
      } else {
        print('Usuario no autenticado');
        // Manejar el caso en el que no haya usuario autenticado según tus necesidades
      }

      // Notificar a los oyentes (la Vista) sobre cualquier cambio
      notifyListeners();
    } catch (error) {
      print('Error al almacenar en Firebase: $error');
      // Manejar el error según tus necesidades
    }
  }

  Future<void> eliminar(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('medicamentos')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medicamento eliminado con éxito'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el medicamento'),
        ),
      );
    }
  }
}