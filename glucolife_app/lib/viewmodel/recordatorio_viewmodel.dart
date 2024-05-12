import 'package:flutter/cupertino.dart';
import 'package:glucolife_app/modelos/recordatorio.dart';
import 'package:glucolife_app/servicios/RecordatorioServicio.dart';

class RecordatorioViewModel extends ChangeNotifier {
  final RecordatorioServicio _recordatorioServicio;

  /// Constructor de la clase [RecordatorioViewModel].
  ///
  /// [recordatorioServicio]: Servicio para la gestión de recordatorios.
  RecordatorioViewModel({
    required RecordatorioServicio recordatorioServicio,
  }) : _recordatorioServicio = recordatorioServicio;

  List<Recordatorio> recordatorios = [];

  /// Agrega un recordatorio.
  ///
  /// [recordatorio]: El recordatorio a agregar.
  ///
  /// Devuelve error cuando no se puede agregar a Firebase
  Future<void> agregarRecordatorio(Recordatorio recordatorio) async {
    try {
      await RecordatorioServicio.agregarRecordatorioAFirebase(recordatorio);
      notifyListeners();
    } catch (error) {
      throw ('Error al agregar recordatorio: $error');
    }
  }

  /// Elimina un recordatorio.
  ///
  /// [documentId]: El ID del documento del recordatorio a eliminar.
  ///
  /// Devuelve error cuando no se puede eliminar el recordatorio de forma correcta
  Future<void> eliminarRecordatorio(String documentId) async {
    try {
      await RecordatorioServicio.eliminarRecordatorio(documentId);
      notifyListeners();
    } catch (error) {
      throw 'Error al eliminar recordatorio: $error';
    }
  }
}
