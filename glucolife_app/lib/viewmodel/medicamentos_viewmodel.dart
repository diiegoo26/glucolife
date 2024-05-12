import 'package:flutter/cupertino.dart';
import 'package:glucolife_app/modelos/medicamento.dart';
import 'package:glucolife_app/servicios/MedicamentoServicio.dart';

class MedicamentoViewModel extends ChangeNotifier {
  final MedicamentoServicio _medicamentoServicio;

  /// Constructor de la clase [MedicamentoViewModel].
  ///
  /// [medicamentoServicio]: Servicio para la gestión de medicamentos.
  MedicamentoViewModel({
    required MedicamentoServicio medicamentoServicio,
  }) : _medicamentoServicio = medicamentoServicio;

  List<Medicamento> medicamentos = [];

  /// Agrega un medicamento.
  ///
  /// [medicamento]: El medicamento a agregar.
  ///
  /// Devuelve error cuando no se puede almacenar el medicamento en Firebase
  Future<void> agregarMedicamento(Medicamento medicamento) async {
    try {
      await MedicamentoServicio.agregarMedicamentoAFirebase(medicamento);
      notifyListeners();
    } catch (error) {
      throw 'Error al agregar medicamento: $error';
    }
  }

  /// Elimina un medicamento.
  ///
  /// [documentId]: El ID del documento del medicamento a eliminar.
  ///
  /// Devuelve error cuando no se puede eliminar el medicamento de Firebase
  Future<void> eliminarMedicamento(String documentId) async {
    try {
      await MedicamentoServicio.eliminarMedicamentos(documentId);
      notifyListeners();
    } catch (error) {
      throw 'Error al eliminar medicamento: $error';
    }
  }
}