import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/ajustes_viewmodel.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/datos_medicos.dart';
import 'package:glucolife_app/vistas/ajustes/datos_personales.dart';
import 'package:glucolife_app/vistas/ajustes/conectar_dispositivos.dart';
import 'package:glucolife_app/vistas/ajustes/recuperar_pass.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:provider/provider.dart';

class AjustesVitsa extends StatefulWidget {
  const AjustesVitsa();

  @override
  _AjustesVitsaState createState() => _AjustesVitsaState();
}

class _AjustesVitsaState extends State<AjustesVitsa> {
  final AjustesViewModel _ajustesViewModel = AjustesViewModel();
  final LoginViewModel _loginViewModel = LoginViewModel();

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
        title: const Text('Ajustes'),
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagenes/fondo.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.green.withOpacity(0.5),
              BlendMode.srcOver,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _TarjetaDelUsuario(),
              const SizedBox(height: 20.0),
              _Tarjeta("Datos personales", irDatosPersonales),
              _Tarjeta("Datos Médicos", irDatosMedicos),
              _Tarjeta("Cambio de contraseña", irCambioContrasena),
              _Tarjeta("Dispositivos", irDispositivos),
              _cerrarSesion(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _TarjetaDelUsuario() {
    return Consumer<UsuarioProvider>(
      builder: (context, usuarioModel, child) {
        return Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                usuarioModel.obtenerUsuario?.imagenUrl ??
                    "https://cdn-icons-png.flaticon.com/512/3135/3135768.png",
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido,',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${usuarioModel.obtenerUsuario?.nombre} ${usuarioModel.obtenerUsuario?.apellidos}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _Tarjeta(String title, VoidCallback onTap) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.green.shade800,
        ),
        onTap: onTap,
      ),
    );
  }

  void irDatosPersonales() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DatosPersonalesVista()),
    );
  }

  void irDatosMedicos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DatosMedicosVista()),
    );
  }

  void irDispositivos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConectarDispositivos()),
    );
  }

  void _obtenerUsuarioActual() async {
    try {
      Usuario? usuario = await _loginViewModel.obtenerUsuarioActual();
      setState(() {
        _usuario = usuario;
      });
    } catch (error) {
      print('Error al obtener el usuario: $error');
    }
  }

  void irCambioContrasena() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecuperarPassVista()),
    );
  }

  Widget _cerrarSesion() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        title: const Text(
          "Cerrar Sesión",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.exit_to_app,
          color: Colors.red,
        ),
        onTap: () {
          _mostrarDialogoCerrarSesion();
        },
      ),
    );
  }

  /// Muestra un diálogo para confirmar el cierre de sesión.
  void _mostrarDialogoCerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Cerrar Sesión?'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _ajustesViewModel.cerrarSesion(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BienvenidaVista()),
                );
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}

