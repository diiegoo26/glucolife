import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/ajustes.dart';
import 'package:glucolife_app/vistas/alimentacion/visualizacion_datos.dart';
import 'package:glucolife_app/vistas/deportes/visualizar_actividad.dart';
import 'package:glucolife_app/vistas/home/tarjeta_actividad.dart';
import 'package:glucolife_app/vistas/home/tarjeta_alimentacion.dart';
import 'package:glucolife_app/vistas/home/tarjeta_grafico.dart';
import 'package:glucolife_app/vistas/medicacion/medicacion.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginViewModel _viewModel = LoginViewModel();
  final GlobalKey<AnimatedFloatingActionButtonState> key = GlobalKey<AnimatedFloatingActionButtonState>();

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
          title: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Consumer<UserData>(
                builder: (context, usuarioModel, child) {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(usuarioModel.usuario?.imagenUrl ?? ""),
                        onBackgroundImageError: (exception, stackTrace) {
                          print('Error cargando la imagen: $exception\n$stackTrace');
                        },
                      ),
                      SizedBox(width: 8),
                      Text('Bienvenido, ${usuarioModel.usuario?.nombre ?? "Usuario"}'),
                    ],
                  );
                },
              ),
            ),
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
            SizedBox(height: 20),
            TarjetaGrafico(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualizarActividad()),  // Reemplaza DetalleVista con el nombre de tu vista de destino
                );
              },
              child: TarjetaActividad(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualizarAlimentos()),  // Reemplaza DetalleVista con el nombre de tu vista de destino
                );
              },
              child: TarjetaAlimentacion(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizarMedicacion()),
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
                'Medicación',
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
            SizedBox(height: 16),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<UserData>(
                    builder: (context, usuarioModel, child) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(usuarioModel.usuario?.imagenUrl ?? ""),
                        ),
                        title: Text(
                          '${usuarioModel.usuario?.nombre ?? "Usuario"} ${usuarioModel.usuario?.apellidos??""}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ajustes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ajustes()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.food_bank),
              title: Text('Alimentación'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualizarAlimentos()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.medication),
              title: Text('Medicación'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualizarMedicacion()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.run_circle),
              title: Text('Actividad'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualizarActividad()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar Sesión'),
              onTap: () {
                _mostrarDialogoCerrarSesion();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _obtenerUsuarioActual() async {
    try {
      Usuario? usuario = await _viewModel.obtenerUsuarioActual();
      Provider.of<UserData>(context, listen: false).actualizarUsuario(usuario!);
    } catch (error) {
      print('Error al obtener el usuario: $error');
    }
  }

  void abrirDrawer() {
    Scaffold.of(context).openDrawer();
  }

  void _mostrarDialogoCerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Cerrar Sesión?'),
          content: Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

}
