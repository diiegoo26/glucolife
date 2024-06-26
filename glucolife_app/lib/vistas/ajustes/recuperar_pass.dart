import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/login/signUp.dart';

class RecuperarPassVista extends StatefulWidget {
  @override
  _RecuperarPassVistaState createState() => _RecuperarPassVistaState();
}

class _RecuperarPassVistaState extends State<RecuperarPassVista> {
  final TextEditingController _emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar contraseña'),
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/imagenes/fondo.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.green.withOpacity(
                        0.5),
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
                              builder: (context) => LoginVista()),
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
                      'Enviar correo',
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
      color: Colors.white,
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
