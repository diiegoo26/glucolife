import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/viewmodel/registro_viewmodel.dart';
import 'package:glucolife_app/vistas/alimentacion/visualizacion_datos.dart';
import 'package:glucolife_app/vistas/deportes/visualizacion_datos.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RegistroViewModel _viewModel = RegistroViewModel();
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
          title: GestureDetector(
            onTap: () {},
            child: Text('Bienvenido, ${_usuario?.nombre ?? "Usuario"}'),
          )),
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
                MaterialPageRoute(
                    builder: (context) => VisualizacionActividad()),
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
                MaterialPageRoute(
                    builder: (context) => VisualizacionAlimentacion()),
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
      setState(() {
        _usuario = usuario;
      });
    } catch (error) {
      // Manejar el error (puedes mostrar un mensaje al usuario)
      print('Error al obtener el usuario: $error');
    }
  }
}
