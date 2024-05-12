import 'package:flutter/cupertino.dart';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:glucolife_app/servicios/ActividadServicio.dart';
import 'package:glucolife_app/servicios/WgerServicio.dart';

class ActividadViewModel extends ChangeNotifier {
  final ActividadServicio _actividadService = ActividadServicio();
  final WgerService _wgerServicio = WgerService();

  List<Actividad> ejercicios = [];
  List<Actividad> filtrar = [];

  /// Obtiene las actividades desde el servicio Wger.
  ///
  /// Retorna una lista de las actividades encontradas
  ///
  /// Devuelve error cuando no se puede recuperar las actividades de la API Wger
  Future<List<Actividad>> obtenerActividades() async {
    try {
      ejercicios = await _wgerServicio.buscarActividad();
      notifyListeners();
      return filtrar = List.from(ejercicios);
    } catch (error) {
      throw 'Error al recuperar ejercicios: $error';
    }
  }

  /// Filtra las actividades por un término de búsqueda.
  ///
  /// [query]: Es el término de búsqueda para filtrar las actividades.
  void filterejercicios(String query) {
    filtrar = ejercicios
        .where((exercise) =>
        exercise.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  /// Guarda una actividad en Firebase.
  ///
  /// [ejercicio]: La actividad que se va a guardar.
  ///
  /// Devuelve error cuando no se puede almacenar la actividad en la base de datos
  Future<void> guardarActividad(Actividad ejercicio,DateTime fechaSeleccionada) async {
    try {
      await _actividadService.guardarActividadEnFirebase(ejercicio,fechaSeleccionada);
    } catch (error) {
      throw 'Error al guardar la actividad: $error';
    }
  }

  /// Elimina una actividad de Firebase.
  ///
  /// [documentId]: El ID del documento de la actividad que se va a eliminar.
  ///
  /// Devuelve error cuando no se puede eliminar correctamente la actividad de Firebase
  Future<void> eliminarActividad(String documentId) async {
    try {
      await _actividadService.eliminarActividad(documentId);
    } catch (error) {
      throw 'Error al eliminar la actividad: $error';
    }
  }

  /// Calcula el total de calorías quemadas para una actividad.
  ///
  /// [tiempo]: El tiempo de duración de la actividad.
  /// [intensidad]: La intensidad de la actividad.
  ///
  /// Retorna el total de calorías quemadas
  double calcularTotalCaloriasQuemadas(
      String tiempo, String intensidad) {
    double totalCalorias =
    _actividadService.calcularCaloriasQuemadas(tiempo, intensidad);
    return double.parse(totalCalorias.toStringAsFixed(4));
  }
}
