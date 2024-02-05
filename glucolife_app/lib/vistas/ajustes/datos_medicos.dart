import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

class DatosMedicos extends StatefulWidget {
  @override
  _DatosMedicosState createState() => _DatosMedicosState();
}

class _DatosMedicosState extends State<DatosMedicos> {
  bool showPassword = false;
  final LoginViewModel _viewModel = LoginViewModel();
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
        title: Text('Datos medicos'),
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              buildTextField("Altura", "${_usuario?.altura}", (value) {
                setState(() {
                  _usuario?.altura = double.parse(value);
                });
              }),
              buildTextField("Peso", "${_usuario?.peso}", (value) {
                setState(() {
                  _usuario?.peso = double.parse(value);
                });
              }),
              buildTextField(
                  "Nivel de actividad física", "${_usuario?.nivelActividad}",
                  (value) {
                setState(() {
                  _usuario?.nivelActividad = value;
                });
              }),
              buildTextField("Unidad de medición para la comida",
                  "${_usuario?.unidadComida}", (value) {
                setState(() {
                  _usuario?.unidadComida = value;
                });
              }),
              buildTextField("Unidad", "${_usuario?.unidad}", (value) {
                setState(() {
                  _usuario?.unidad = value;
                });
              }),
              buildTextField(
                  "Nivel de hiperglucemia", "${_usuario?.hiperglucemia}",
                  (value) {
                setState(() {
                  _usuario?.hiperglucemia = double.parse(value);
                });
              }),
              buildTextField(
                  "Nivel de hipoglucemia", "${_usuario?.hipoglucemia}",
                  (value) {
                setState(() {
                  _usuario?.hipoglucemia = double.parse(value);
                });
              }),
              buildTextField("Objetivo", "${_usuario?.objetivo}", (value) {
                setState(() {
                  _usuario?.objetivo = double.parse(value);
                });
              }),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {},
                      child: Text("Cancelar",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.black)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    child: ElevatedButton(
                      onPressed: _guardarCambiosUsuario,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        "Guardar",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    String placeholder,
    void Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.green, // Cambia este color según tus preferencias
            ),
          ),
        ),
      ),
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

  void _guardarCambiosUsuario() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(firebaseUser.uid)
            .update({
          'altura': _usuario?.altura,
          'peso': _usuario?.peso,
          'hiperglucemia': _usuario?.hiperglucemia,
          'hipoglucemia': _usuario?.hipoglucemia,
          'nivelActividad': _usuario?.nivelActividad,
          'objetivo': _usuario?.objetivo,
          'unidad': _usuario?.unidad,
          'unidadComida': _usuario?.unidadComida,
        });
        UserData usuarioModel = Provider.of<UserData>(context, listen: false);
        usuarioModel.actualizarUsuario(_usuario!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cambios guardados correctamente.'),
          ),
        );
      }
    } catch (error) {
      print('Error al guardar los cambios: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar los cambios.'),
        ),
      );
    }
  }
}
