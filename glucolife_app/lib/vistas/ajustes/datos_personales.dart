import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DatosPersonales extends StatefulWidget {
  @override
  _DatosPersonalesState createState() => _DatosPersonalesState();
}

class _DatosPersonalesState extends State<DatosPersonales> {
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
        title: Text('Datos personales'),
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
              Container(
                alignment: Alignment.center,
                child:  CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(_usuario?.imagenUrl ?? ""),
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error cargando la imagen: $exception\n$stackTrace');
                  },
                ),

              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () => _pickImage(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  "Cambiar imagen de perfil",
                  style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2.2,
                      color: Colors.green),
                ),

              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Nombre", "${_usuario?.nombre}", false,
                  (value) {
                setState(() {
                  _usuario?.nombre = value;
                });
              }),
              buildTextField("Apellidos", "${_usuario?.apellidos}", false,
                      (value) {
                    setState(() {
                      _usuario?.apellidos = value;
                    });
                  }),
              buildTextField("Email", "${_usuario?.email}", false, (value) {
                setState(() {
                  _usuario?.email = value;
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
                            color: Colors.green),
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
    bool isPasswordTextField,
    void Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        obscureText: isPasswordTextField ? !showPassword : false,
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
        // Subir la nueva imagen a Firebase Storage
        String storagePath = 'usuarios/${firebaseUser.uid}/perfil.jpg';
        Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);
        await storageReference.putFile(File(_usuario?.imagenUrl ?? ''));
        String nuevaImagenUrl = await storageReference.getDownloadURL();

        // Actualizar la URL en Firebase Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(firebaseUser.uid)
            .update({
          'nombre': _usuario?.nombre,
          'email': _usuario?.email,
          'password': _usuario?.password,
          'fechaNacimiento': _usuario?.fechaNacimiento,
          'imagenUrl': nuevaImagenUrl,
        });

        // Actualizar el modelo local y mostrar un mensaje de éxito
        UserData usuarioModel = Provider.of<UserData>(context, listen: false);
        _usuario?.imagenUrl = nuevaImagenUrl;
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Actualizar la imagen en el estado
        setState(() {
          _usuario?.imagenUrl = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

}
