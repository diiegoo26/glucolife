/// Clase que representa una actividad física realizada.
class Actividad {
  /// Nombre de la actividad.
  final String nombre;

  /// Tiempo total dedicado a la actividad en formato de texto.
  String tiempoRealizado;

  /// Nivel de intensidad de la actividad.
  String intensidad;

  /// Cantidad de calorías quemadas durante la actividad.
  double caloriasQuemadas;

  /// Fecha y hora en que se registró la actividad.
  DateTime fechaRegistro;

  /// Constructor de la clase `Actividad`.
  Actividad({
    required this.nombre,
    this.tiempoRealizado = '',
    this.intensidad = '',
    this.caloriasQuemadas = 0.0,
    required this.fechaRegistro,
  });
}
