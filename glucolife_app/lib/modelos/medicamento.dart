/// Clase que representa un medicamento.
class Medicamento {
  /// Nombre del medicamento.
  String nombre;

  /// Dosis del medicamento.
  int dosis;

  /// Intervalo de administración del medicamento.
  String intervalo;

  /// Constructor de la clase `Medicamento`.
  Medicamento({
    required this.nombre,
    required this.dosis,
    required this.intervalo,
  });
}
