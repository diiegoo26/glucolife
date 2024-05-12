import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AjustesServicios {
  /// Permite al usuario seleccionar una fecha.
  /// Retorna la fecha seleccionada por el usuario o null si ninguna fecha fue seleccionada.
  Future<DateTime?> seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    return picked;
  }
}
