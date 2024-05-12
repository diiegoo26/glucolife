import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/servicios/LoginServicio.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginServicio _loginServicio = LoginServicio();
  Usuario? _usuario;

  /// Inicia sesión con el correo electrónico y la contraseña proporcionados.
  ///
  /// [context]: El contexto de la aplicación.
  /// [email]: El correo electrónico del usuario.
  /// [password]: La contraseña del usuario.
  ///
  /// Devuelve error cuando no se puede realizar el logueo de forma correcta en Firebase Authentication
  Future<bool> signIn(BuildContext context, String email, String password) async {
    try {
      bool success = await _loginServicio.signIn(context, email, password);
      return success;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return false;
    }
  }

  /// Obtiene el usuario actualmente autenticado.
  ///
  /// Devuelve error cuando no se puede recuperar al usuario logueado
  Future<Usuario?> obtenerUsuarioActual() async {
    try {
      Usuario? user = await _loginServicio.obtenerUsuarioActual();
      return user;
    } catch (e) {
      print('Error al obtener el usuario actual: $e');
      return null;
    }
  }

  /// Inicia sesión con Google.
  ///
  /// [context]: El contexto de la aplicación.
  ///
  /// Devuelve error cuando no se puede iniciar sesion mendiante Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await _loginServicio.signInWithGoogle(context);
    } catch (e) {
      throw 'Error durante el inicio de sesión con Google: $e';
    }
  }
}
