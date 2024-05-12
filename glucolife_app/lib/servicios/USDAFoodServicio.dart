import 'dart:convert';

import 'package:glucolife_app/claves.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:http/http.dart' as http;

/// Clase que realiza búsquedas de alimentos utilizando la API de USDA.
class USDAFood {
  /// Realiza una búsqueda de alimentos utilizando la API de USDA.
  ///
  /// [query]: La cadena de búsqueda para la consulta de alimentos.
  ///
  /// Devuelve una excepcion cuando no se puede encontrar el alimento ingresado
  Future<List<Alimentos>> buscarAlimento(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://api.nal.usda.gov/fdc/v1/foods/search?query=$query&api_key='+Claves.USDAFoodKey,
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('foods')) {
        List<dynamic> foods = data['foods'];

        DateTime fechaActual = DateTime.now();

        List<Alimentos> results = foods.map((food) {
          List<Nutriente> nutrientes = [];


          if (food['foodNutrients'] != null &&
              food['foodNutrients'].isNotEmpty) {
            nutrientes = food['foodNutrients']
                .where((nutrient) =>
                    nutrient['nutrientName'] == 'Protein' ||
                    nutrient['nutrientName'] == 'Carbohydrate, by difference' ||
                    nutrient['nutrientName'] == 'Total lipid (fat)')
                .map<Nutriente>((nutrient) {
              return Nutriente(
                nutrienteId: nutrient['nutrientId'],
                nombre_nutriente: nutrient['nutrientName'],
                valor: nutrient['value'].toDouble(),
              );
            }).toList();
          }

          return Alimentos(
            id: food['fdcId'],
            descripcion: food['description'].toString(),
            nutrientes: nutrientes,
            fechaRegistro: fechaActual,
          );
        }).toList();

        return results;
      } else {
        throw Exception('La respuesta no contiene la clave "foods"');
      }
    } else {
      throw Exception(
          'Error al realizar la búsqueda. Código de estado: ${response.statusCode}');
    }
  }
}
