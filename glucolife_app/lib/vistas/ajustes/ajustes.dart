import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/datos_medicos.dart';
import 'package:glucolife_app/vistas/ajustes/datos_personales.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:provider/provider.dart';

class Ajustes extends StatefulWidget {
  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<Ajustes> {
  final LoginViewModel _viewModel = LoginViewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        title: Text('Ajustes'),
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
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
              _buildUserProfile(),
              const SizedBox(height: 20.0),
              _buildCard("Datos personales", irDatosPersonales),
              _buildCard("Datos Médicos", irDatosMedicos),
              _buildCard("Cambio de contraseña", irCambioContrasena),
              _buildLogoutTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Consumer<UserData>(
      builder: (context, usuarioModel, child) {
        return Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(usuarioModel.usuario?.imagenUrl ?? "https://cdn-icons-png.flaticon.com/512/3135/3135768.png"),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido,',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${usuarioModel.usuario?.nombre} ${usuarioModel.usuario?.apellidos}',
                  style: TextStyle(
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

  Widget _buildCard(String title, VoidCallback onTap) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
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
      MaterialPageRoute(builder: (context) => DatosPersonales()),
    );
  }

  void irDatosMedicos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DatosMedicos()),
    );
  }

  void irCambioContrasena() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = '';

        return AlertDialog(
          title: Text('Cambio de Contraseña'),
          content: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              email = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _auth.sendPasswordResetEmail(email: email);
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  void _obtenerUsuarioActual() async {
    try {
      Usuario? usuario = await _viewModel.obtenerUsuarioActual();
      setState(() {
        _usuario = usuario;
      });
    } catch (error) {
      print('Error al obtener el usuario: $error');
    }
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

  Widget _buildLogoutTile() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        title: Text(
          "Cerrar Sesión",
          style: TextStyle(
            fontWeight: FontWeight.bold,
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
}
