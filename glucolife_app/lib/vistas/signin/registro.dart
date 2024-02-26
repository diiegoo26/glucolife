
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/viewmodel/registro_viewmodel.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  int _currentStep = 0;
  late String _imagePath;
  RegistroViewModel _viewModel = RegistroViewModel();

  // Campos de entrada para cada sección
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  final List<String> opcionesNivelActividad = [
    'Bajo',
    'Moderado',
    'Alto',
  ];
  TextEditingController _alturaController = TextEditingController();
  TextEditingController _pesoController = TextEditingController();

  String selectedNivelActividad = 'Bajo';

  String selectedUnidadComida = 'Porciones';
  String selectedUnidad = 'Unidades';

  final List<String> opcionesMedicionesComida = [
    'Raciones',
    'Gramos',
    'Porciones',
  ];

  final List<String> opcionesMedicionesUnidad = [
    'mg/dL',
    'Unidades',
  ];

  TextEditingController _hiperController = TextEditingController();
  TextEditingController _hipoController = TextEditingController();
  TextEditingController _objetivoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Registro'),
        backgroundColor: Colors.green,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            Usuario user = Usuario(
              nombre: _nombreController.text,
              apellidos: _apellidosController.text,
              email: _emailController.text,
              password: _passController.text,
              fechaNacimiento: selectedDate,
              nivelActividad: selectedNivelActividad,
              altura: double.parse(_alturaController.text),
              peso: double.parse(_pesoController.text),
              unidadComida: selectedUnidadComida,
              unidad: selectedUnidad,
              hiperglucemia: double.parse(_hiperController.text),
              hipoglucemia: double.parse(_hipoController.text),
              objetivo: double.parse(_objetivoController.text),
              imagenUrl: _imagePath,
            );


            await _viewModel.registerUser(user,_imagePath);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            print('Formulario enviado y usuario registrado en Firebase!');
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Sección 1'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seleccionar Imagen'),
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: Text('Seleccionar'),
                ),
                SizedBox(height: 10.0),
                Text('Nombre'),
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Ingrese su nombre'),
                ),
                SizedBox(height: 10.0),
                Text('Apellidos'),
                TextFormField(
                  controller: _apellidosController,
                  decoration:
                      InputDecoration(labelText: 'Ingrese sus apellidos'),
                ),
                SizedBox(height: 10.0),
                Text('Correo Electrónico'),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Ingrese su correo electrónico'),
                ),
                SizedBox(height: 10.0),
                Text('Contraseña'),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: 'Ingrese su contraseña'),
                ),
                SizedBox(height: 10.0),
                Text('Fecha de Nacimiento'),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Seleccione la fecha',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                        ),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Sección 2'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nivel de Actividad'),
                DropdownButton<String>(
                  value: selectedNivelActividad,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedNivelActividad = newValue!;
                    });
                  },
                  items: opcionesNivelActividad
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.0),
                Text('Altura'),
                TextFormField(
                  controller: _alturaController,
                  decoration: InputDecoration(labelText: 'Ingrese su altura'),
                ),
                SizedBox(height: 10.0),
                Text('Peso'),
                TextFormField(
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: 'Ingrese su peso'),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Sección 3'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seleccion de unidades de medida para los alimentos'),
                DropdownButton<String>(
                  value: selectedUnidadComida,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUnidadComida = newValue!;
                    });
                  },
                  items: opcionesMedicionesComida
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Text('Seleccion de unidades de medida de las lecturas'),
                DropdownButton<String>(
                  value: selectedUnidad,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUnidad = newValue!;
                    });
                  },
                  items: opcionesMedicionesUnidad
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.0),
                Text('Hiperglucemia'),
                TextFormField(
                  controller: _hiperController,
                  decoration: InputDecoration(
                      labelText: 'Ingrese el nivel de hiperglucemia'),
                ),
                SizedBox(height: 10.0),
                Text('Hipoglucemia'),
                TextFormField(
                  controller: _hipoController,
                  decoration: InputDecoration(
                      labelText: 'Ingrese su nivel de hipoglucemia'),
                ),
                SizedBox(height: 10.0),
                Text('Objetivo'),
                TextFormField(
                  controller: _objetivoController,
                  decoration: InputDecoration(
                      labelText: 'Ingrese su nivel a conseguir'),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }
}
