import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Locale _locale = const Locale('es', '');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlucoLife',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('es', ''),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
      },
      
    );
  }
}
