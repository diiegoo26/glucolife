import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:glucolife_app/servicios/WgerService.dart';

class ActividadViewModel extends ChangeNotifier {
  final WgerService _exerciseService;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  WgerService wgerService = WgerService();

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
      print('Error al recuperar ejercicios: $error');
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
      // Calcular las calorías quemadas
      double caloriasQuemadas =
          wgerService.calcularCaloriasQuemadas([ejercicio]);

      // Obtener el usuario actualmente autenticado
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Si hay un usuario autenticado, obtener su UID
        String uid = currentUser.uid;

        CollectionReference actividadesCollection =
            _firestore.collection('actividades');

        await actividadesCollection.add({
          'usuario': uid, // Añadir el UID del usuario al documento
          'nombre': ejercicio.nombre,
          'tiempoRealizado': ejercicio.tiempoRealizado,
          'intensidad': ejercicio.intensidad,
          'caloriasQuemadas': caloriasQuemadas,
        });

        // Mensaje de éxito o realizar otras acciones después de almacenar en Firebase
      } else {
        print('Usuario no autenticado');
        // Manejar el caso en el que no haya usuario autenticado según tus necesidades
      }
    } catch (error) {
      print('Error al almacenar en Firebase: $error');
      // Manejar el error según tus necesidades
    }
  }
}
