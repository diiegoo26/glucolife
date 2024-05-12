/// Clase que representa un alimento ingerido.
class Alimentos {
  /// Identificador único del alimento.
  int id;

  /// Descripción del alimento.
  String descripcion;

  /// Lista de nutrientes presentes en el alimento.
  List<Nutriente> nutrientes;

  /// Fecha y hora en que se registró el alimento.
  DateTime fechaRegistro;

  /// Constructor de la clase `Alimentos`.
  Alimentos({
    required this.id,
    required this.descripcion,
    required this.nutrientes,
    required this.fechaRegistro,
  });
}

/// Clase que representa un nutriente presente en un alimento.
class Nutriente {
  /// Identificador único del nutriente.
  final int nutrienteId;

  /// Nombre del nutriente.
  final String nombre_nutriente;

  /// Valor del nutriente presente en el alimento.
  final double valor;

  /// Constructor de la clase `Nutriente`.
  Nutriente({
    required this.nutrienteId,
    required this.nombre_nutriente,
    required this.valor,
  });
}
