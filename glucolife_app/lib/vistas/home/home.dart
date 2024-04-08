import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/alimentos_viewmodel.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/ajustes.dart';
import 'package:glucolife_app/vistas/alimentacion/visualizacion_datos.dart';
import 'package:glucolife_app/vistas/deportes/visualizar_actividad.dart';
import 'package:glucolife_app/vistas/home/tarjeta_actividad_home.dart';
import 'package:glucolife_app/vistas/home/tarjeta_alimentacion_home.dart';
import 'package:glucolife_app/vistas/home/tarjeta_consejos.dart';
import 'package:glucolife_app/vistas/home/tarjeta_grafico_actual.dart';
import 'package:glucolife_app/vistas/home/tarjeta_grafico_no_actual.dart';
import 'package:glucolife_app/vistas/medicacion/visualizar_medicamentos.dart';
import 'package:glucolife_app/vistas/recordatorios/agregar_recordatorio.dart';
import 'package:glucolife_app/vistas/recordatorios/visualizar_recordatorios.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginViewModel _viewModel = LoginViewModel();
  final GlobalKey<AnimatedFloatingActionButtonState> key =
  GlobalKey<AnimatedFloatingActionButtonState>();
  DateTime selectedDate = DateTime.now();
  bool showChart = true; // Flag to control chart visibility

  @override
  void initState() {
    super.initState();
    _obtenerUsuarioActual();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateModel = Provider.of<SelectedDateModel>(context);
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
                      backgroundImage:
                      NetworkImage(usuarioModel.usuario?.imagenUrl ?? "https://cdn-icons-png.flaticon.com/512/3135/3135768.png")
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HorizontalCalendar(
              date: selectedDate,
              initialDate: DateTime(2000),
              textColor: Colors.black,
              backgroundColor: Colors.white,
              selectedColor: Colors.green,
              showMonth: true,
              locale: Localizations.localeOf(context),
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                  // Check if the selected date is the current date
                  showChart = selectedDate.year == DateTime.now().year &&
                      selectedDate.month == DateTime.now().month &&
                      selectedDate.day == DateTime.now().day;
                });
                selectedDateModel.updateSelectedDate(date);
              },
            ),
            SizedBox(height: 20),
            if (showChart) TarjetaGrafico()
            else
              TarjetaGraficoNoActual(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualizarActividad()),
                );
              },
              child: TarjetaActividadHome(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizarAlimentos()),  // Reemplaza DetalleVista con el nombre de tu vista de destino
                );
              },
              child: TarjetaAlimentacionHome(),
            ),
            TarjetaConsejo(),
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
                          backgroundImage: NetworkImage(usuarioModel.usuario?.imagenUrl ?? "https://cdn-icons-png.flaticon.com/512/3135/3135768.png"),
                        ),
                        title: Text(
                          '${usuarioModel.usuario?.nombre ?? "Usuario"} ${usuarioModel.usuario?.apellidos??"Apellidos"}',
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
                  MaterialPageRoute(builder: (context) => VisualizarMedicamentos()),
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
              leading: Icon(Icons.alarm),
              title: Text('Recordatorios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualizarRecordatorios()),
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


