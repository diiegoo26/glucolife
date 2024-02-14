import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/ajustes.dart';
import 'package:glucolife_app/vistas/alimentacion/visualizacion_datos.dart';
import 'package:glucolife_app/vistas/deportes/visualizar_actividad.dart';
import 'package:glucolife_app/vistas/home/grafica.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
    _obtenerUsuarioActual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          title: Consumer<UserData>(
            builder: (context, usuarioModel, child) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the settings screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Ajustes()),
                  );
                },
                child: Text(
                    'Bienvenido, ${usuarioModel.usuario?.nombre ?? "Usuario"}'),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HorizontalCalendar(
                date: DateTime.now(),
                initialDate: DateTime.now(),
                textColor: Colors.black,
                backgroundColor: Colors.white,
                selectedColor: Colors.green,
                showMonth: true,
                locale: Localizations.localeOf(context),
                onDateSelected: (date) {
                  if (kDebugMode) {
                    print(date.toString());
                  }
                },
              ),
              SizedBox(height: 50),
              LineChartSample10(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisualizarActividad()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Deporte',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisualizarAlimentos()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Alimentación',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisualizarActividad()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Consejos',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ));
  }

  void _obtenerUsuarioActual() async {
    try {
      Usuario? usuario = await _viewModel.obtenerUsuarioActual();
      Provider.of<UserData>(context, listen: false).actualizarUsuario(usuario!);
    } catch (error) {
      // Manejar el error (puedes mostrar un mensaje al usuario)
      print('Error al obtener el usuario: $error');
    }
  }
}
