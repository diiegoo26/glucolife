class Actividad {
  final String nombre;
  String tiempoRealizado;
  String intensidad;
  double caloriasQuemadas; // Nuevo campo

  Actividad({
    required this.nombre,
    this.tiempoRealizado = '',
    this.intensidad = '',
    this.caloriasQuemadas = 0.0, // Inicializado con 0 por defecto
  });
}
