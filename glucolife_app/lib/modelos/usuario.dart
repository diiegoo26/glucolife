/// Clase que representa un usuario en el sistema.
class Usuario {
  /// Nombre del usuario.
  String nombre;
  /// Apellidos del usuario.
  String apellidos;
  /// Dirección de correo electrónico del usuario.
  String email;
  /// Contraseña del usuario.
  String password;
  /// Fecha de nacimiento del usuario.
  DateTime fechaNacimiento;
  /// Nivel de actividad del usuario.
  String nivelActividad;
  /// Altura del usuario en metros.
  double altura;
  /// Peso del usuario en kilogramos.
  double peso;
  /// Unidad utilizada para las mediciones de comida.
  String unidadComida;
  /// Unidad utilizada para las mediciones de glucosa.
  String unidadMedida;
  /// Valor de hiperglucemia del usuario.
  double hiperglucemia;
  /// Valor de hipoglucemia del usuario.
  double hipoglucemia;
  /// Nivel de glucosa a obtener del usuario.
  double nivel_objetivo;
  /// URL de la imagen de perfil del usuario.
  String imagenUrl;

  /// Constructor de la clase Usuario.
  Usuario({
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.password,
    required this.fechaNacimiento,
    required this.nivelActividad,
    required this.altura,
    required this.peso,
    required this.unidadComida,
    required this.unidadMedida,
    required this.hiperglucemia,
    required this.hipoglucemia,
    required this.nivel_objetivo,
    required this.imagenUrl,
  });
}

