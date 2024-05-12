import 'package:flutter/material.dart';

/// Provider para notificar la seleccion de la fecha en el calendario
class SeleccionarFechaProvider extends ChangeNotifier {
  /// Fecha seleccionada.
  DateTime _seleccionarFehca = DateTime.now();

  /// Obtiene la fecha seleccionada.
  DateTime get seleccionarFecha => _seleccionarFehca;

  /// Actualiza la fecha seleccionada y notifica a los listeners.
  ///
  /// [fechaSeleccionada]: Nueva fecha seleccionada.
  void actualizarFecha(DateTime fechaSeleccionada) {
    _seleccionarFehca = fechaSeleccionada;
    notifyListeners();
  }
}


