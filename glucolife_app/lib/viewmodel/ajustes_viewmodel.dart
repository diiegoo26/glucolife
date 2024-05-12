import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/servicios/AjustesServicios.dart';
import 'package:glucolife_app/servicios/LoginServicio.dart';

class AjustesViewModel extends ChangeNotifier {
  final LoginServicio _loginServicio = LoginServicio();
  final AjustesServicios _ajustesServicios = AjustesServicios();


  /// Cierra la sesión del usuario y navega a la pantalla de bienvenida.
  ///
  /// [context]: El contexto de la aplicación.
  Future<void> cerrarSesion(BuildContext context) async {
    await _loginServicio.cerrarSesion();
  }

  /// Permite al usuario seleccionar una fecha.
  ///
  /// [context]: El contexto de la aplicación.
  /// [fechaSeleccionada]: Función de devolución de llamada que se invoca cuando se selecciona una fecha.
  /// [fechaInicial]: La fecha inicial para mostrar en el selector de fecha.
  Future<void> seleccionarFecha(
      BuildContext context, void Function(DateTime) fechaSeleccionada, DateTime? fechaInicial) async {
    final DateTime? pickedDate = await _ajustesServicios.seleccionarFecha(context);

    if (pickedDate != null) {
      fechaSeleccionada(pickedDate);
    }
  }

  /// Guarda los datos médicos del usuario.
  ///
  /// [usuario]: Usuario logueado.
  /// [context]: El contexto de la aplicación.
  ///
  /// Devuelve error cuando no se pueden guardar los cambios en de los datos medicos en Firebase
  Future<void> guardarDatosMedicos(Usuario? usuario, BuildContext context) async {
    try {
      await _loginServicio.guardarDatosMedicos(usuario);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Datos médicos guardados correctamente.'),
        ),
      );
    } catch (error) {
      print ('Error al guardar los datos médicos: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar los datos médicos.'),
        ),
      );
    }
  }

  /// Guarda los datos personales del usuario.
  ///
  /// [context]: El contexto de la aplicación.
  /// [imagePath]: La ruta de la imagen de perfil del usuario.
  /// [usuario]: Usuario logueado.
  ///
  ///  Devuelve error cuando no se pueden guardar los cambios en de los datos personales en Firebase
  Future<void> guardarDatosPersonales(
      BuildContext context, String? imagePath, Usuario? usuario) async {
    try {
      await _loginServicio.guardarDatosPersonales(imagePath, usuario, context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Datos personales guardados correctamente.'),
        ),
      );
    } catch (error) {
      print('Error al guardar los datos personales: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar los datos personales.'),
        ),
      );
    }
  }
}
