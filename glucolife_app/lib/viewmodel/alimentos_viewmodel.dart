import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:glucolife_app/servicios/AlimentoServicio.dart';

class AlimentosViewModel extends ChangeNotifier {
  final AlimentosServicio _alimentosServicio = AlimentosServicio();

  /// Agrega un alimento a Firebase.
  ///
  /// [producto]: El alimento a agregar.
  /// [cantidadUnidades]: La cantidad de unidades del alimento.
  ///
  /// Devuelve error cuando no se puede guardar los alimentos en Firebase
  Future<void> agregarAlimentoAFirebase(Alimentos producto, int cantidadUnidades,DateTime fechaSeleccionada) async {
    try {
      await _alimentosServicio.agregarAlimentoAFirebase(producto, cantidadUnidades,fechaSeleccionada);
      notifyListeners();
    } catch (error) {
      throw 'Error al agregar alimento a Firebase: $error';
    }
  }

  /// Elimina un alimento de Firebase.
  ///
  /// [documentId]: El ID del documento del alimento a eliminar.
  ///
  /// Devuelve error cuando no se puede eliminar el alimento en Firebase
  Future<void> eliminarAlimento(String documentId) async {
    try {
      await _alimentosServicio.eliminarAlimento(documentId);
      notifyListeners();
    } catch (error) {
      throw 'Error al eliminar alimento: $error';
    }
  }

  /// Obtiene los valores totales de los alimentos.
  ///
  /// Devuelve error cuando no se puede obtener los valores de Firebase
  Future<Map<String, double>> obtenerValoresTotal() async {
    try {
      return await _alimentosServicio.obtenerValoresTotal();
    } catch (error) {
      throw 'Error al obtener valores totales de alimentos: $error';
    }
  }

  /// Calcula el total de calorías de un producto.
  ///
  /// [producto]: El alimento.
  /// [unidades]: La cantidad de unidades del alimento.
  double calcularTotalCalorias(Alimentos producto, int unidades) {
    double totalCalorias = _alimentosServicio.calcularCaloriasTotales([producto]) * unidades;
    return double.parse(totalCalorias.toStringAsFixed(2));
  }

  /// Calcula el total de proteínas de un producto.
  ///
  /// [producto]: El alimento.
  /// [unidades]: La cantidad de unidades del alimento.
  double calcularTotalProteinas(Alimentos producto, int unidades) {
    double totalProteinas = _alimentosServicio.calcularTotalProteinas([producto]) * unidades;
    return double.parse(totalProteinas.toStringAsFixed(2));
  }

  /// Calcula el total de grasas de un producto.
  ///
  /// [producto]: El alimento.
  /// [unidades]: La cantidad de unidades del alimento.
  double calcularTotalGrasas(Alimentos producto, int unidades) {
    double totalGrasas = _alimentosServicio.calcularTotalGrasas([producto]) * unidades;
    return double.parse(totalGrasas.toStringAsFixed(2));
  }

  /// Calcula el total de carbohidratos de un producto.
  ///
  /// [producto]: El alimento.
  /// [unidades]: La cantidad de unidades del alimento.
  double calcularTotalCarbohidratos(Alimentos producto, int unidades) {
    double totalCarbohidratos = _alimentosServicio.calcularTotalCarbohidratos([producto]) * unidades;
    return double.parse(totalCarbohidratos.toStringAsFixed(2));
  }
}
