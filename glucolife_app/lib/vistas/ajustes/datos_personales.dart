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
import 'package:intl/intl.dart';

class DatosPersonales extends StatefulWidget {
  @override
  _DatosPersonalesState createState() => _DatosPersonalesState();
}

class _DatosPersonalesState extends State<DatosPersonales> {
  final LoginViewModel _viewModel = LoginViewModel();
  Usuario? _usuario;
  String? _imagePath;

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
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.grey,
                  child: FutureBuilder<ImageProvider?>(
                    future: _getImageProvider(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        print('Error cargando la imagen: ${snapshot.error}');
                        return Text('Error al cargar la imagen');
                      } else {
                        return ClipOval(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Image(
                              image: snapshot.data ?? AssetImage('assets/placeholder_image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: _pickImage,
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
                height: 25,
              ),
              buildTextField("Nombre", "${_usuario?.nombre}", (value) {
                setState(() {
                  _usuario?.nombre = value;
                });
              }),
              buildTextField("Apellidos", "${_usuario?.apellidos}", (value) {
                setState(() {
                  _usuario?.apellidos = value;
                });
              }),
              SizedBox(height: 10.0),
              buildTextFieldCalendar(
                "Fecha de nacimiento",
                _usuario?.fechaNacimiento,
                    (selectedDate) {
                  setState(() {
                    _usuario?.fechaNacimiento = selectedDate;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(width: 20),
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
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldCalendar(
      String labelText,
      DateTime? value,
      void Function(DateTime) onDateSelected,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
          text: value != null ? DateFormat('yyyy-MM-dd').format(value) : '',
        ),
        onTap: () {
          _selectDate(context, onDateSelected);
        },
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  void _selectDate(
      BuildContext context,
      void Function(DateTime) onDateSelected,
      ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _usuario?.fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
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

  void _guardarCambiosUsuario() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        String storagePath = 'usuarios/${firebaseUser.uid}/perfil.jpg';
        Reference storageReference =
        FirebaseStorage.instance.ref().child(storagePath);
        await storageReference.putFile(File(_imagePath ?? ''));
        String nuevaImagenUrl = await storageReference.getDownloadURL();
        await FirebaseFirestore.instance.collection('usuarios').doc(firebaseUser.uid).update({
          'imagenUrl': nuevaImagenUrl,
          'nombre': _usuario?.nombre,
          'apellidos': _usuario?.apellidos,
          'fechaNacimiento': _usuario?.fechaNacimiento,
          'imagenUrl':nuevaImagenUrl
        });
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

  void _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  Future<ImageProvider?> _getImageProvider() async {
    if (_imagePath != null) {
      return FileImage(File(_imagePath!));
    } else if (_usuario?.imagenUrl != null && _usuario!.imagenUrl!.isNotEmpty) {
      return NetworkImage(_usuario!.imagenUrl!);
    }
    return null;
  }

}
