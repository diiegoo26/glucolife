import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';

class UserData extends ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  void actualizarUsuario(Usuario nuevoUsuario) {
    _usuario = nuevoUsuario;
    notifyListeners();
  }
}
