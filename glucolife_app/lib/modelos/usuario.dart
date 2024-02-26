class Usuario {
  String nombre;
  String apellidos;
  String email;
  String password;
  DateTime fechaNacimiento;
  String nivelActividad;
  double altura;
  double peso;
  String unidadComida;
  String unidad;
  double hiperglucemia;
  double hipoglucemia;
  double objetivo;
  String imagenUrl;

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
    required this.unidad,
    required this.hiperglucemia,
    required this.hipoglucemia,
    required this.objetivo,
    required this.imagenUrl,
  });
}
