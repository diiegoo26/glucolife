import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/login/signUp.dart';
import 'package:glucolife_app/vistas/signin/registro.dart';

class RecuperarPassScreen extends StatefulWidget {
  @override
  _RecuperarPassScreenState createState() => _RecuperarPassScreenState();
}

class _RecuperarPassScreenState extends State<RecuperarPassScreen> {
  final TextEditingController _emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con degradado
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/imagenes/fondo.jpg'), // Reemplaza con la ruta de tu imagen
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.green.withOpacity(
                        0.5), // Ajusta la opacidad según sea necesario
                    BlendMode.srcOver,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'Recuperar contraseña',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 20.0),
                  _buildTextField('Email', _emailController,
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _auth.sendPasswordResetEmail(
                            email: _emailController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                        print("Correo enviado correctamente");
                      } catch (e) {
                        print(
                            "Error al enviar el correo de restablecimiento: $e");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Enviar correo de recuperación',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      color: Colors.white, // Establece el color de fondo del contenedor
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}
