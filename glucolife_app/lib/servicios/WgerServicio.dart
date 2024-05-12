import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:glucolife_app/modelos/actividad.dart';

/// Servicio para interactuar con la API de Wger.
class WgerService {
  final String apiUrl = 'https://wger.de/api/v2/exerciseinfo/';

  /// Obtiene la lista de ejercicios desde la API de Wger.
  ///
  /// Retorna una lista de objetos de tipo [Actividad].
  ///
  /// Lanza una excepción si no se pueden cargar los ejercicios.
  Future<List<Actividad>> buscarActividad() async {
    final response = await http.get(Uri.parse(apiUrl));
    DateTime fechaActual = DateTime.now();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data
          .map((item) => Actividad(
        nombre: item['name'],
        intensidad: "",
        tiempoRealizado: "",
        caloriasQuemadas: 0.0,
        fechaRegistro: fechaActual,
      ))
          .toList();
    } else {
      throw Exception('Error al cargar las actividades');
    }
  }
}
