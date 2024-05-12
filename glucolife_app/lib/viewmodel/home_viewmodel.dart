import 'package:flutter/material.dart';
import 'package:glucolife_app/servicios/HomeServicio.dart';
import 'package:glucolife_app/servicios/LoginServicio.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';

class HomeViewModel {
  final HomeServicio _homeServicio = HomeServicio();
  final LoginServicio _loginServicio = LoginServicio();

  /// Guarda los datos de glucosa en Firebase.
  ///
  /// [valorLectura]: El valor de glucosa a guardar.
  ///
  /// Devuelve error cuando no se puede registrar las lecturas en Firebase
  Future<void> guardarDatosGlucosa(double valorLectura) async {
    try {
      await _homeServicio.guardarDatosGlucosa(valorLectura);
    } catch (e) {
      throw 'Error al guardar datos de glucosa: $e';
    }
  }

  /// Obtiene el valor de hiperglucemia desde Firebase.
  ///
  /// Devuelve error cuando no se puede recuperar el valor de hiperglucemia
  Future<double> obtenerHiperglucemia() async {
    try {
      return await _homeServicio.obtenerHiperglucemia();
    } catch (e) {
      print('Error al obtener hiperglucemia: $e');
      return 0.0;
    }
  }

  /// Obtiene el valor de hipoglucemia desde Firebase.
  ///
  /// Devuelve error cuando no se puede recuperar el valor de hipoglucemia
  Future<double> obtenerHipoglucemia() async {
    try {
      return await _homeServicio.obtenerHipoglucemia();
    } catch (e) {
      print('Error al obtener hipoglucemia: $e');
      return 0.0;
    }
  }

  /// Cierra la sesión del usuario y redirige a la pantalla de bienvenida.
  ///
  /// [context]: El contexto de la aplicación.
  Future<void> cerrarSesion(BuildContext context) async {
    await _loginServicio.cerrarSesion();
  }
}
