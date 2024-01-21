class Usuario {
  String email;
  String password;
  String nombre;
  String apellidos;

  Usuario(
      {required this.email,
      required this.password,
      required this.nombre,
      required this.apellidos});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombre': nombre,
      'apellidos': apellidos,
    };
  }
}
