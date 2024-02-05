import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/ajustes_viewmodel.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/ajustes/datos_medicos.dart';
import 'package:glucolife_app/vistas/ajustes/datos_personales.dart';
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
  final AjustesViewModel _viewModelAjustes = AjustesViewModel();
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
            image: AssetImage('imagenes/fondo.jpg'),
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
        CircularProfileAvatar(
          "https://st.depositphotos.com/2101611/3925/v/600/depositphotos_39258143-stock-illustration-businessman-avatar-profile-picture.jpg",
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
        _viewModelAjustes.cerrarSesion();
      },
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

  void cerrarSesion() async {
    try {
      await _viewModelAjustes.cerrarSesion();
      print('Sesión cerrada correctamente');
    } catch (error) {
      print('Error al cerrar la sesión: $error');
    }
  }
}
