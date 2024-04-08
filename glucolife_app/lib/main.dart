import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/servicios/WgerService.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/viewmodel/medicaciones_viewmodel.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Plugin de notificaciones locales de Flutter.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Clave global para el navegador.
final navigatorKey = GlobalKey<NavigatorState>();

/// Función principal de la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init(); // Inicializa las notificaciones locales.

  // Obtiene los detalles de la notificación si la aplicación se lanzó desde una notificación.
  var initialNotification =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // Si la aplicación se lanzó desde una notificación, navega a la ruta correspondiente después de 1 segundo.
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed('/another',
          arguments: initialNotification?.notificationResponse?.payload);
    });
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Inicializa Firebase con las opciones predeterminadas.
  );

  // Inicialización de servicios y objetos necesarios.
  WgerService wgerService = WgerService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // Inicio de la aplicación.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserData(), // Proveedor para los datos del usuario.
        ),
        ChangeNotifierProvider(
          create: (context) => ActividadViewModel(
            exerciseService: wgerService,
            firestore: firestore,
            auth: auth,
          ), // Proveedor para el modelo de vista de actividades.
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedDateModel(), // Proveedor para el modelo de fecha seleccionada.
          child: MyApp(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

/// Clave de API para Firebase.
const apiKey = "AIzaSyAMsD5TyCfbzYekFN6oDg7fNuJMRUbhPAM";

/// Clase principal de la aplicación.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlucoLife',
      theme: ThemeData(
        primarySwatch: Colors.green, // Tema de la aplicación.
      ),
      initialRoute: '/', // Ruta inicial de la aplicación.
      routes: {
        '/': (context) => WelcomeScreen(), // Ruta para la pantalla de bienvenida.
        '/home': (context) => HomeScreen(), // Ruta para la pantalla principal.
      },
    );
  }
}
