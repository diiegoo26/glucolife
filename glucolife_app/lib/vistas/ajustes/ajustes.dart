import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/datos_medicos.dart';
import 'package:glucolife_app/vistas/ajustes/datos_personales.dart';
import 'package:glucolife_app/vistas/welcome/welcome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Ajustes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AjustesScreen();
  }
}

class AjustesScreen extends StatefulWidget {
  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  final LoginViewModel _viewModel = LoginViewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Usuario? _usuario;
  final TextStyle greyTExt = TextStyle(
    color: Colors.grey.shade600,
  );

  @override
  void initState() {
    super.initState();
    _obtenerUsuarioActual();
  }

  bool _emailNotify = true;
  bool _pushNotify = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 30.0),
              _buildUserProfile(),
              const SizedBox(height: 20.0),
              _buildCard("Datos personales", irDatosPersonales),
              _buildCard("Datos Medicos", irDatosMedicos),
              _buildCard("Cambio de contraseña",irCambioContrasena),
              _buildLogoutTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundImage: NetworkImage(_usuario?.imagenUrl ?? ""),
          onBackgroundImageError: (exception, stackTrace) {
            print('Error cargando la imagen: $exception\n$stackTrace');
            // Puedes tomar acciones adicionales aquí, como mostrar una imagen de relleno.
          },
        ),
        const SizedBox(width: 10.0),
        Consumer<UserData>(
          builder: (context, userDataProvider, child) {
            return GestureDetector(
              onTap: () {
                // Navigate to the settings screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ajustes()),
                );
              },
              child: Text('Bienvenido, ${userDataProvider.usuario?.nombre}'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCard(String title, VoidCallback onTap) {
    return Card(
      elevation: 8,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.montserrat(),
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
          title: Text('Ingrese su correo electrónico'),
          content: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
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
              child: Text('Aceptar'),
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
      // Manejar el error (puedes mostrar un mensaje al usuario)
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
    return ListTile(
      title: Text(
        "Salir",
        style: GoogleFonts.montserrat(color: Colors.white),
      ),
      trailing: Icon(
        Icons.login,
        color: Colors.white,
      ),
      onTap: () {
        _mostrarDialogoCerrarSesion(); // Llamada aquí en respuesta a la acción del usuario
      },
    );
  }
}
