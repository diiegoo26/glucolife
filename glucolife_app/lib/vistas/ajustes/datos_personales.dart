import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/viewmodel/ajustes_viewmodel.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DatosPersonalesVista extends StatefulWidget {
  @override
  _DatosPersonalesVistaState createState() => _DatosPersonalesVistaState();
}

class _DatosPersonalesVistaState extends State<DatosPersonalesVista> {
  final LoginViewModel _loginViewModel = LoginViewModel();
  final AjustesViewModel _ajustesViewModel = AjustesViewModel();

  Usuario? _usuario;
  String? _imagePath;

  @override
  /// Inicializacion de las llamadas a los servicios
  void initState() {
    super.initState();
    _obtenerUsuarioActual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos personales'),
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
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
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        print('Error cargando la imagen: ${snapshot.error}');
                        return const Text('Error al cargar la imagen');
                      } else {
                        return ClipOval(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Image(
                              image: snapshot.data ??
                                  AssetImage('assets/placeholder_image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  "Cambiar imagen de perfil",
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 2.2, color: Colors.green),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              contruirCampos("Nombre", "${_usuario?.nombre}", (value) {
                setState(() {
                  _usuario?.nombre = value;
                });
              }),
              contruirCampos("Apellidos", "${_usuario?.apellidos}", (value) {
                setState(() {
                  _usuario?.apellidos = value;
                });
              }),
              const SizedBox(height: 10.0),
              contruirCalendario(
                "Fecha de nacimiento",
                _usuario?.fechaNacimiento,
                    (selectedDate) {
                  setState(() {
                    _usuario?.fechaNacimiento = selectedDate;
                  });
                },
              ),
              const SizedBox(height: 20),
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
                      child: const Text("Cancelar",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    child: ElevatedButton(
                      onPressed: () {
                        /// Llamada al servicio para guardar los cambios
                        _ajustesViewModel.guardarDatosPersonales(
                            context, _imagePath, _usuario);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        "Guardar",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget contruirCampos(
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
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget contruirCalendario(
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
          _ajustesViewModel.seleccionarFecha(
              context, onDateSelected, DateTime(2024));
        },
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  /// Comunicacion con el servico para poder recuperar al usuario logueado
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

  /// Abre la galería para seleccionar una imagen de perfil.
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

  /// Obtiene un Future de ImageProvider basado en la ruta de la imagen o la URL de la imagen del usuario.
  Future<ImageProvider?> _getImageProvider() async {
    if (_imagePath != null) {
      return FileImage(File(_imagePath!));
    } else if (_usuario?.imagenUrl != null && _usuario!.imagenUrl!.isNotEmpty) {
      return NetworkImage(_usuario!.imagenUrl!);
    }
    return null;
  }
}
