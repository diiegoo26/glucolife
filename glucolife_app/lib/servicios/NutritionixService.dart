import 'dart:convert';

import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:http/http.dart' as http;

class USDAFood {
  Future<List<Alimentos>> performSearch(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://api.nal.usda.gov/fdc/v1/foods/search?query=$query&api_key=fcZd4NPWYwG4bkDaS65PepIQ9KPFqLsAGePDQRey',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('foods')) {
        List<dynamic> foods = data['foods'];

        // Filtrar los alimentos para mostrar solo las proteínas, grasas e hidratos
        List<Alimentos> results = foods.map((food) {
          List<Nutriente> nutrientes = [];

          if (food['foodNutrients'] != null &&
              food['foodNutrients'].isNotEmpty) {
            // Filtrar solo las proteínas y los carbohidratos
            nutrientes = food['foodNutrients']
                .where((nutrient) =>
                    nutrient['nutrientName'] == 'Protein' ||
                    nutrient['nutrientName'] == 'Carbohydrate, by difference' ||
                    nutrient['nutrientName'] == 'Total lipid (fat)' ||
                    nutrient['nutrientName'] == 'Total Sugars' ||
                    nutrient['nutrientName'] == 'Energy' ||
                    nutrient['nutrientName'] == 'Water')
                .map<Nutriente>((nutrient) {
              return Nutriente(
                nutrientId: nutrient['nutrientId'],
                nutrientName: nutrient['nutrientName'],
                value: nutrient['value'].toDouble(),
              );
            }).toList();
          }

          return Alimentos(
            fdcId: food['fdcId'],
            description: food['description'].toString(),
            foodNutrients: nutrientes,
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

  double calcularCaloriasTotales(List<Alimentos> alimentos) {
    double totalCalorias = 0.0;

    for (var alimento in alimentos) {
      for (var nutriente in alimento.foodNutrients) {
        // Considerar solo los nutrientes relevantes para las calorías
        if (nutriente.nutrientName == 'Protein' ||
            nutriente.nutrientName == 'Carbohydrate, by difference' ||
            nutriente.nutrientName == 'Total lipid (fat)') {
          totalCalorias += nutriente.value;
        }
      }
    }

    return totalCalorias;
  }

  double calcularTotalProteinas(List<Alimentos> alimentos) {
    double totalProteinas = 0.0;

    for (var alimento in alimentos) {
      for (var nutriente in alimento.foodNutrients) {
        if (nutriente.nutrientName == 'Protein') {
          totalProteinas += nutriente.value;
        }
      }
    }

    return totalProteinas;
  }

  double calcularTotalCarbohidratos(List<Alimentos> alimentos) {
    double totalCarbohidratos = 0.0;

    for (var alimento in alimentos) {
      for (var nutriente in alimento.foodNutrients) {
        if (nutriente.nutrientName == 'Carbohydrate, by difference') {
          totalCarbohidratos += nutriente.value;
        }
      }
    }

    return totalCarbohidratos;
  }

  double calcularTotalGrasas(List<Alimentos> alimentos) {
    double totalGrasas = 0.0;

    for (var alimento in alimentos) {
      for (var nutriente in alimento.foodNutrients) {
        if (nutriente.nutrientName == 'Total lipid (fat)') {
          totalGrasas += nutriente.value;
        }
      }
    }

    return totalGrasas;
  }
}
