import 'package:flutter/cupertino.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/servicios/RegistroServicio.dart';

import 'package:flutter/material.dart';

class RegistroViewModel extends ChangeNotifier {
  final RegistroServicio _registroServicio = RegistroServicio();

  /// Registra un nuevo usuario.
  ///
  /// [usuario]: El usuario a registrar.
  /// [imagePath]: La ruta de la imagen de perfil del usuario.
  ///
  /// Devuelve error cuando el registro no se realiza exitosamente en Firebase
  Future<void> registrarUsuario(Usuario usuario, String imagePath) async {
    try {
      await _registroServicio.registrarUsuario(usuario, imagePath);
    } catch (e) {
      throw 'Error al registrar usuario: $e';
    }
  }

  /// Comprobacion del formato del correo
  ///
  /// [email] El correo del usuario
  bool verificarFormatoCorreo(String email) {
    return _registroServicio.comprobarFormatoCorreo(email);
  }

  /// Comprobacion del formato de la contraseña
  ///
  /// [pass] La contraseña del usuario
  bool verificarFormatoPass(String pass) {
    return _registroServicio.comprobarFormatoContrasena(pass);
  }
}

