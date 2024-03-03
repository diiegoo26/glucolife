import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/servicios/WgerService.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/viewmodel/home_viewmodel.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // Asegúrate de tener el archivo con las opciones de Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WgerService wgerService = WgerService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserData(),
        ),
        ChangeNotifierProvider(
          create: (context) => ActividadViewModel(
            exerciseService: wgerService,
            firestore: firestore,
            auth: auth,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedDateModel(),
          child: MyApp(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

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
        '/': (context) => WelcomeScreen(),
        '/home':(context) => HomeScreen(),
      },
    );
  }
}
