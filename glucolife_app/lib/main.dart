import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glucolife_app/claves.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/servicios/Devices_Bloc.dart';
import 'package:glucolife_app/servicios/NotificacionServicio.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/conectar_dispositivos.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:provider/provider.dart';
import 'package:vital_core/environment.dart';
import 'package:vital_core/region.dart';
import 'package:vital_devices/device_manager.dart';
import 'package:vital_devices/vital_devices.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fimber/fimber.dart';
import 'package:permission_handler/permission_handler.dart';


import 'package:vital_core/vital_core.dart' as vital_core;


/// Plugin de notificaciones locales de Flutter.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Clave global para el navegador.
final navigatorKey = GlobalKey<NavigatorState>();


/// Función principal de la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificacionServicio.init();

  var status = await Permission.notification.request();

  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());

  final vitalClient = vital_core.VitalClient()
    ..init(
      region: Region.eu,
      environment: Environment.sandbox,
      apiKey: Claves.VitalKey,
    );

  final DeviceManager deviceManager = DeviceManager();

  var initialNotification =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed('/another',
          arguments: initialNotification?.notificationResponse?.payload);
    });
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    /// Inicializacion de los Provider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UsuarioProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ActividadViewModel(
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SeleccionarFechaProvider(),
          child: MyApp(),
        ),
        ChangeNotifierProvider(
          create: (_) => DevicesBloc(deviceManager),
          child: const ConectarDispositivos(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

/// Clase principal de la aplicación.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlucoLife',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BienvenidaVista(),
        '/home': (context) => HomeVista(),
      },
    );
  }
}
