import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/signin/registro.dart';

class LoginVista extends StatefulWidget {
  @override
  _LoginVistaState createState() => _LoginVistaState();
}

class _LoginVistaState extends State<LoginVista> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginViewModel _loginViewModel = LoginViewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
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
                    'Bienvenido a Glucolife',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  _buildTextField('Email', _emailController,
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 12.0),
                  _buildTextField('Contraseña', _passwordController,
                      obscureText: true),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      irCambioContrasena();
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        try {
                          /// Llamada al servicio para realizar el logueo
                          bool exito = await _loginViewModel.signIn(
                            context,
                            email,
                            password,
                          );

                          if (!exito) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Correo electrónico o contraseña incorrectos.',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                            ),
                          );
                        }
                      } else {
                        // Muestra un SnackBar si algún campo está vacío
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Por favor, ingresa el correo electrónico y la contraseña.',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistroVista(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Registrar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      botonLogueoRedes(
                        onPressed: () {
                          /// Llamada al servicio para iniciar sesion mediante Google
                          _loginViewModel.signInWithGoogle(context);
                        },
                        icon: Image.asset(
                          'assets/imagenes/google.webp',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      botonLogueoRedes(
                        onPressed: () {
                          // Implementa la lógica de inicio de sesión con Apple
                        },
                        icon: Image.asset(
                          'assets/imagenes/apple.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      botonLogueoRedes(
                        onPressed: () {
                          // Implementa la lógica de inicio de sesión con Facebook
                        },
                        icon: Image.asset(
                          'assets/imagenes/facebook.webp',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
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

  /// Ventana para solicitar el cambio de contraseña en caso de olvido
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
}

class botonLogueoRedes extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const botonLogueoRedes({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: icon,
      label: Text(''),
    );
  }
}
