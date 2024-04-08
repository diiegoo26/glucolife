import 'package:glucolife_app/modelos/Recordatorio.dart';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:glucolife_app/modelos/medicamento.dart';

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
  /// Unidad utilizada para las mediciones.
  String unidad;
  /// Valor de hiperglucemia del usuario.
  double hiperglucemia;
  /// Valor de hipoglucemia del usuario.
  double hipoglucemia;
  /// Objetivo del usuario.
  double objetivo;
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
    required this.unidad,
    required this.hiperglucemia,
    required this.hipoglucemia,
    required this.objetivo,
    required this.imagenUrl,
  });
}

