import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/ajustes.dart';
import 'package:glucolife_app/vistas/alimentacion/visualizacion_datos.dart';
import 'package:glucolife_app/vistas/deportes/visualizar_actividad.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginViewModel _viewModel = LoginViewModel();
  Usuario? _usuario;

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
      body: ListView(
        shrinkWrap: true,
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
          ElevatedButton(
            onPressed: () {
              // Lógica para el primer botón
            },
            child: Text('Grafico'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Lógica para el tercer botón
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VisualizarActividad()),
              );
            },
            child: Text('Actividad'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Lógica para el tercer botón
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VisualizarAlimentos()),
              );
            },
            child: Text('Comida'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Lógica para el cuarto botón
            },
            child: Text('Consejos'),
          ),
        ],
      ),
    );
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
