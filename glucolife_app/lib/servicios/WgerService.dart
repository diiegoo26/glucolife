import 'dart:convert';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:http/http.dart' as http;

class WgerService {
  final String apiUrl = 'https://wger.de/api/v2/exercise/';

  Future<List<Actividad>> fetchExercises() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data
          .map((item) => Actividad(
              nombre: item['name'],
              intensidad: "",
              tiempoRealizado: "",
              caloriasQuemadas: 0.0))
          .toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  double calcularCaloriasQuemadas(List<Actividad> actividades) {
    double totalCalorias = 0.0;

    for (var actividad in actividades) {
      // Asigna valores predeterminados si la intensidad o el tiempo no están establecidos
      double factorIntensidad = actividad.intensidad == 'Alta'
          ? 2.0
          : (actividad.intensidad == 'Moderada' ? 1.5 : 1.0);
      double tiempoRealizado =
          double.tryParse(actividad.tiempoRealizado.split(' ')[0]) ?? 0.0;

      // Fórmula básica para calcular las calorías quemadas: tiempo * factor de intensidad
      double caloriasQuemadas = tiempoRealizado * factorIntensidad;

      // Acumula las calorías quemadas para cada actividad
      totalCalorias += caloriasQuemadas;
    }

    return totalCalorias;
  }
}
