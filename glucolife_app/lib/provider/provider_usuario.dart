import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';

/// Clase que representa los datos del usuario y notifica cambios.
class UsuarioProvider extends ChangeNotifier {
  /// Usuario almacenado.
  Usuario? _usuario;

  /// Obtiene el usuario almacenado.
  Usuario? get obtenerUsuario => _usuario;

  /// Actualiza el usuario almacenado y notifica a los listeners.
  ///
  /// [nuevoUsuario]: Nuevo usuario a almacenar.
  void actualizarUsuario(Usuario nuevoUsuario) {
    _usuario = nuevoUsuario;
    notifyListeners();
  }
}
