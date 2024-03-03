import 'package:flutter/material.dart';

class Medicamento {
  String nombre;
  String dosis;
  String fechaInicio;
  String frecuencia;
  List<int> diasSeleccionados;
  bool recordatorioActivado;
  TimeOfDay horaRecordatorio;

  Medicamento({
    required this.nombre,
    required this.dosis,
    required this.fechaInicio,
    required this.frecuencia,
    required this.diasSeleccionados,
    required this.recordatorioActivado,
    required this.horaRecordatorio,
  });
}
