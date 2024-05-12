import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/home_viewmodel.dart';
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
import 'package:glucolife_app/vistas/recordatorios/visualizar_recordatorios.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:provider/provider.dart';

class HomeVista extends StatefulWidget {
  @override
  _HomeVistaState createState() => _HomeVistaState();
}

class _HomeVistaState extends State<HomeVista> {
  final LoginViewModel _loginViewModel = LoginViewModel();
  final HomeViewModel _homeViewModel = HomeViewModel();
  final GlobalKey<AnimatedFloatingActionButtonState> key =
  GlobalKey<AnimatedFloatingActionButtonState>();
  DateTime seleccionaFecha = DateTime.now();
  bool showChart = true;

  @override
  /// Inicializacion de las llamadas a los servicios
  void initState() {
    super.initState();
    _obtenerUsuarioActual();
  }

  @override
  Widget build(BuildContext context) {
    /// Llamada al provider para poder mantener la vista actualizada
    final seleccionaFechaModel = Provider.of<SeleccionarFechaProvider>(context);
    seleccionaFecha = seleccionaFechaModel.seleccionarFecha;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Consumer<UsuarioProvider>(
              builder: (context, usuarioModel, child) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage:
                      NetworkImage(usuarioModel.obtenerUsuario?.imagenUrl ?? "https://cdn-icons-png.flaticon.com/512/3135/3135768.png")
                    ),
                    SizedBox(width: 8),
                    Text('Bienvenido, ${usuarioModel.obtenerUsuario?.nombre ?? "Usuario"}'),
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
              date: seleccionaFecha,
              initialDate: DateTime(2000),
              textColor: Colors.black,
              backgroundColor: Colors.white,
              selectedColor: Colors.green,
              showMonth: true,
              locale: Localizations.localeOf(context),
              lastDate: DateTime.now(),
              onDateSelected: (date) {
                setState(() {
                  seleccionaFecha = date;
                  // Check if the selected date is the current date
                  showChart = seleccionaFecha.year == DateTime.now().year &&
                      seleccionaFecha.month == DateTime.now().month &&
                      seleccionaFecha.day == DateTime.now().day;
                });
                seleccionaFechaModel.actualizarFecha(date);
              },
            ),
            SizedBox(height: 20),
            if (showChart) TarjetaGraficoActualVista()
            else
              TarjetaGraficoNoActualVista(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisualizarActividad()),
                );
              },
              child: TarjetaActividadHomeVista(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizarAlimentos()),
                );
              },
              child: TarjetaAlimentosHomeVista(),
            ),
            TarjetaConsejoVista(),
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
                  Consumer<UsuarioProvider>(
                    builder: (context, usuarioModel, child) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(usuarioModel.obtenerUsuario?.imagenUrl ?? "https://cdn-icons-png.flaticon.com/512/3135/3135768.png"),
                        ),
                        title: Text(
                          '${usuarioModel.obtenerUsuario?.nombre ?? "Usuario"} ${usuarioModel.obtenerUsuario?.apellidos??"Apellidos"}',
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
                  MaterialPageRoute(builder: (context) => AjustesVitsa()),
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

  /// Llamada al servicio para obtener los datos del usuario logueado
  void _obtenerUsuarioActual() async {
    try {
      Usuario? usuario = await _loginViewModel.obtenerUsuarioActual();
      Provider.of<UsuarioProvider>(context, listen: false).actualizarUsuario(usuario!);
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
                /// Llamada al metodo para cerrar sesion
                _homeViewModel.cerrarSesion(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BienvenidaVista()),
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


