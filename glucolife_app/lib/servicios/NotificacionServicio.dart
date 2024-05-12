import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

enum NotificationFrequency {
  daily,
  weekly,
  custom
}

class NotificacionServicio{
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  /// Método llamado al tocar una notificación para manejar la respuesta.
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  /// Inicializa el servicio de notificaciones.
  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) =>null,
    );
  }

  /// Muestra las notificaciones de las medicinas.
  ///
  /// [titulo]: El título de la notificación.
  /// [cuerpo]: El cuerpo de la notificación.
  /// [payload]: El payload asociado con la notificación.
  /// [frecuencia]: La frecuencia de la notificación.
  /// [intervaloPersonalizado]: Intervalo personalizado en minutos
  ///
  /// Devuelve una excepcion cuando el intervalo posee el formato incorrecto
  static Future mostrarNotificacionMedicina({
    required String titulo,
    required String cuerpo,
    required String payload,
    required NotificationFrequency frecuencia,
    int? intervaloPersonalizado,
  }) async {
    int delaySeconds;
    switch (frecuencia) {
      case NotificationFrequency.daily:
        delaySeconds = 86400;
        break;
      case NotificationFrequency.weekly:
        delaySeconds = 604800;
        break;
      case NotificationFrequency.custom:
        if (intervaloPersonalizado != null && intervaloPersonalizado > 0) {
          delaySeconds = intervaloPersonalizado;
        } else {
          throw ArgumentError('Intervalo personalizado inválido.');
        }
        break;
    }
    await Future.delayed(Duration(seconds: delaySeconds));

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    // Mostrar la notificación
    await _flutterLocalNotificationsPlugin
        .show(0, titulo, cuerpo, notificationDetails, payload: payload);
  }

  /// Muestra una notificación con un retraso específico y una fecha y hora programadas.
  ///
  /// [titulo]: El título de la notificación.
  /// [cuerpo]: El cuerpo de la notificación.
  /// [payload]: El payload asociado con la notificación.
  /// [scheduledDateTime]: La fecha y hora programadas para mostrar la notificación.
  static Future<void> mostrarNotificacionRecordatorio({
    required String titulo,
    required String cuerpo,
    required String payload,
    DateTime? scheduledDateTime,
  }) async {
    if (scheduledDateTime == null) {
      throw ArgumentError('La fecha y hora programadas son obligatorias.');
    }

    int delaySeconds = scheduledDateTime.difference(DateTime.now()).inSeconds;
    if (delaySeconds <= 0) {
      throw ArgumentError('La fecha y hora programadas deben ser en el futuro.');
    }

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await Future.delayed(Duration(seconds: delaySeconds));

    await _flutterLocalNotificationsPlugin.show(0, titulo, cuerpo, notificationDetails, payload: payload);
  }
}
