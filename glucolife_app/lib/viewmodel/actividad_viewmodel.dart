
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:glucolife_app/servicios/WgerService.dart';
import 'package:intl/intl.dart';

class ActividadViewModel extends ChangeNotifier {
  final WgerService _exerciseService;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ActividadViewModel({
    required WgerService exerciseService,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _exerciseService = exerciseService,
        _firestore = firestore,
        _auth = auth;

  List<Actividad> exercises = [];
  List<Actividad> filteredExercises = [];

  Future<void> fetchExercises() async {
    try {
      exercises = await _exerciseService.fetchExercises();
      filteredExercises = List.from(exercises);
      notifyListeners();
    } catch (error) {
      print('Error: $error al recuperar ejercicios');
      // Manejar el error según tus necesidades
    }
  }

  void filterExercises(String query) {
    filteredExercises = exercises
        .where((exercise) =>
        exercise.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> guardarActividadEnFirebase(Actividad ejercicio) async {
    try {
      double caloriasQuemadas =
      _exerciseService.calcularCaloriasQuemadas([ejercicio]);

      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        CollectionReference actividadesCollection =
        _firestore.collection('actividades');

        await actividadesCollection.add({
          'usuario': uid,
          'nombre': ejercicio.nombre,
          'tiempoRealizado': ejercicio.tiempoRealizado,
          'intensidad': ejercicio.intensidad,
          'caloriasQuemadas': ejercicio.caloriasQuemadas,
          'fechaRegistro': DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal()),
        });

        // Mensaje de éxito o realizar otras acciones después de almacenar en Firebase
      } else {
        print('Usuario no autenticado');
        // Manejar el caso en el que no haya usuario autenticado según tus necesidades
      }
    } catch (error) {
      print('Error: $error al almacenar en Firebase');
      // Manejar el error según tus necesidades
    }
  }

  Future<void> eliminar(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('actividades')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Actividad eliminada con éxito'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la actividad'),
        ),
      );
    }
  }
}
