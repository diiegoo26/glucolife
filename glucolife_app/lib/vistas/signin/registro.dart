import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:glucolife_app/viewmodel/registro_viewmodel.dart';
import 'package:intl/intl.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  int _currentStep = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RegistroViewModel _registroViewModel = RegistroViewModel();

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
  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

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

  TextEditingController hiperController = TextEditingController();
  TextEditingController hipoController = TextEditingController();
  TextEditingController objetivoController = TextEditingController();

  void _registrarUsuario() async {
    // Obtener los valores del TextField
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    String nombre = _nombreController.text.trim();
    String apellidos = _apellidosController.text.trim();

    // Validar los campos (puedes agregar más validaciones según tus necesidades)

    // Crear un objeto Usuario
    Usuario usuario = Usuario(
        email: email, password: password, nombre: nombre, apellidos: apellidos);

    try {
      // Llamar al método del ViewModel para registrar el usuario
      await _registroViewModel.registrarUsuario(usuario);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      // Registro exitoso, puedes navegar a otra pantalla o realizar otras acciones
      print('Usuario registrado con éxito');
    } catch (error) {
      // Manejar el error (puedes mostrar un mensaje al usuario)
      print('Error durante el registro: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Registro'),
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
            _registrarUsuario();
            print('Formulario enviado!');
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
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {},
                        child: Text('Seleccionar imagen'),
                      ),
                    ],
                  ),
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
                  controller: alturaController,
                  decoration: InputDecoration(labelText: 'Ingrese su altura'),
                ),
                SizedBox(height: 10.0),
                Text('Peso'),
                TextFormField(
                  controller: pesoController,
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
                  controller: hiperController,
                  decoration: InputDecoration(
                      labelText: 'Ingrese el nivel de hiperglucemia'),
                ),
                SizedBox(height: 10.0),
                Text('Hipoglucemia'),
                TextFormField(
                  controller: hipoController,
                  decoration: InputDecoration(
                      labelText: 'Ingrese su nivel de hipoglucemia'),
                ),
                SizedBox(height: 10.0),
                Text('Objetivo'),
                TextFormField(
                  controller: objetivoController,
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
}
