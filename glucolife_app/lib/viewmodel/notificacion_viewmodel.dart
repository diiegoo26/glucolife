import 'package:flutter/cupertino.dart';
import 'package:glucolife_app/servicios/NotificacionServicio.dart';

class NotificacionViewModel extends ChangeNotifier {
  final NotificacionServicio _notificacionServicio;

  /// Constructor de la clase [NotificacionViewModel].
  ///
  /// [notificacionServicio]: Servicio para la gestión de notificaciones.
  NotificacionViewModel({
    required NotificacionServicio notificacionServicio,
  }) : _notificacionServicio = notificacionServicio;

  /// Inicializa el servicio de notificaciones.
  ///
  /// Devuelve error cuando no se puede inicializar de forma correcta las notificaciones
  Future<void> inicializarNotificaciones() async {
    try {
      await NotificacionServicio.init();
    } catch (error) {
      throw 'Error al inicializar notificaciones: $error';
    }
  }

  /// Muestra una notificación diferida.
  ///
  /// [titulo]: El título de la notificación.
  /// [cuerpo]: El cuerpo de la notificación.
  /// [payload]: La carga útil de la notificación.
  /// [frecuencia]: La frecuencia de la notificación.
  /// [intervaloPersonalizado]: Intervalo personalizado en minutos
  ///
  /// Devuelve error cuando no se muestra la notificacion de los medicamentos
  Future<void> mostrarNotificacionMedicamentos({
    required String titulo,
    required String cuerpo,
    required String payload,
    required NotificationFrequency frecuencia,
    int? intervaloPersonalizado,
  }) async {
    try {
      await NotificacionServicio.mostrarNotificacionMedicina(
        titulo: titulo,
        cuerpo: cuerpo,
        payload: payload,
        frecuencia: frecuencia,
        intervaloPersonalizado: intervaloPersonalizado,
      );
    } catch (error) {
      throw 'Error al mostrar notificación: $error';
    }
  }

  /// Muestra una notificación diferida en una fecha y hora específicas.
  ///
  /// [titulo]: El título de la notificación.
  /// [cuerpo]: El cuerpo de la notificación.
  /// [payload]: La carga útil de la notificación.
  /// [scheduledDateTime]: La fecha y hora programadas para la notificación.
  ///
  /// Devuelve error cuando no se muestra la notificacion de los recordatorios
  Future<void> mostrarNotificacionRecordatorios({
    required String titulo,
    required String cuerpo,
    required String payload,
    required NotificationFrequency frecuencia,
    required DateTime scheduledDateTime,
  }) async {
    try {
      await NotificacionServicio.mostrarNotificacionRecordatorio(
        titulo: titulo,
        cuerpo: cuerpo,
        payload: payload,
        scheduledDateTime: scheduledDateTime,
      );
    } catch (error) {
      throw 'Error al mostrar notificación: $error';
    }
  }
}
