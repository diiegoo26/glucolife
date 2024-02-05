import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AjustesViewModel extends ChangeNotifier {
  Future<void> cerrarSesion() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }
}
