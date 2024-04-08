import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:glucolife_app/modelos/Recordatorio.dart';
import 'package:glucolife_app/modelos/medicamento.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

enum NotificationFrequency { daily, weekly, custom }

class RecordatoriosViewModel {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> agregarRecordatorioAFirebase(Recordatorio recordatorio) async {
    try {
      // Obtener el usuario actualmente autenticado
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Si hay un usuario autenticado, obtener su UID
        String uid = currentUser.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference recordatoriosCollection =
        firestore.collection('recordatorio');

        await recordatoriosCollection.add({
          'usuario': uid,
          'descripcion': recordatorio.descripcion,
          'fecha': recordatorio.fecha,
        });

        // Mensaje de éxito o realizar otras acciones después de almacenar en Firebase
      } else {
        print('Usuario no autenticado');
        // Manejar el caso en el que no haya usuario autenticado según tus necesidades
      }
    } catch (error) {
      print('Error al almacenar en Firebase: $error');
      // Manejar el error según tus necesidades
    }
  }

  static Future<void> eliminar(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recordatorio')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recordatorio eliminado con éxito'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el recordatorio'),
        ),
      );
    }
  }

  // Método llamado cuando se toca en una notificación
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  // Método para inicializar las notificaciones locales
  static Future init() async {
    // Inicialización del plugin
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
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static Future<void> showDelayedNotification2({
    required String title,
    required String body,
    required String payload,
    DateTime? scheduledDateTime, // Fecha y hora específicas para mostrar la notificación
  }) async {
    if (scheduledDateTime == null) {
      throw ArgumentError('La fecha y hora programadas son obligatorias.');
    }

    // Calcular el retraso en segundos desde el tiempo actual hasta la fecha y hora programadas
    int delaySeconds = scheduledDateTime.difference(DateTime.now()).inSeconds;
    if (delaySeconds <= 0) {
      throw ArgumentError('La fecha y hora programadas deben ser en el futuro.');
    }
    // Configurar los detalles de la notificación
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    // Esperar el tiempo especificado antes de mostrar la notificación
    await Future.delayed(Duration(seconds: delaySeconds));

    // Mostrar la notificación
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
  }



  // Método para cancelar una notificación específica
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Método para cancelar todas las notificaciones
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
