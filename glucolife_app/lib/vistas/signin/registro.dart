
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/viewmodel/registro_viewmodel.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegistroVista extends StatefulWidget {
  @override
  _RegistroVistaState createState() => _RegistroVistaState();
}

class _RegistroVistaState extends State<RegistroVista> {
  int _currentStep = 0;
  String? _imagePath;
  RegistroViewModel _registroViewModel = RegistroViewModel();

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
          /// Llamada al servicio para comprobar que el formato del correo es el correcto
          bool formatoInvalido = _registroViewModel.verificarFormatoCorreo(_emailController.text);
          /// Llamada al servicio para comprobar que el formato de la contraseña es el correcto
          bool passIncorrecta = _registroViewModel.verificarFormatoPass(_passController.text);
          if (!formatoInvalido) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Correo electrónico inválido'),
                  content: Text('Por favor, ingrese un correo electrónico válido.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar'),
                    ),
                  ],
                );
              },
            );
            return;
          }else if (!passIncorrecta) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Contraseña incorrecta'),
                  content: Text('Por favor, ingrese una contraseña válida.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar'),
                    ),
                  ],
                );
              },
            );
            return;
          }
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
              unidadMedida: selectedUnidad,
              hiperglucemia: double.parse(_hiperController.text),
              hipoglucemia: double.parse(_hipoController.text),
              nivel_objetivo: double.parse(_objetivoController.text),
              imagenUrl: _imagePath!,
            );

            /// Llamada al servicio para almacenar al usuario en Firebase
            await _registroViewModel.registrarUsuario(user,_imagePath!);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeVista()),
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
            title: Flexible(
              child: Text(
                'Personal',
                style: _currentStep == 0 ? TextStyle(color: Colors.green, fontWeight: FontWeight.bold) : null,
              ),
            ),
            isActive: _currentStep == 0,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _imagePath != null
                    ? ClipOval(
                  child: Image.file(
                    File(_imagePath!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: Text('Seleccionar Imagen'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Ingrese su correo electrónico',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Formato de Correo Electrónico'),
                              content: Text('El formato del correo electrónico debe ser correo@ejemplo.com'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 10.0),
                Text('Contraseña'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passController,
                        decoration: InputDecoration(
                          labelText: 'Ingrese su contraseña',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Formato de la contraseña'),
                              content: Text('Debe contener al menos 7 caracteres, incluyendo una letra minúscula, una letra mayúscula, un número y un carácter especial.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
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
            title: Flexible(
              child: Text(
                'Física',
                style: _currentStep == 1 ? TextStyle(color: Colors.green, fontWeight: FontWeight.bold) : null,
              ),
            ),
            isActive: _currentStep == 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nivel de Actividad'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuTheme(
                    data: PopupMenuThemeData(
                      color: Colors.grey[200],
                    ),
                    child: DropdownButton<String>(
                      value: selectedNivelActividad,
                      items: opcionesNivelActividad.map((String actividad) {
                        return DropdownMenuItem<String>(
                          value: actividad,
                          child: Text(
                            actividad,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedNivelActividad = value!;
                        });
                      },
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 32,
                      elevation: 16,
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      dropdownColor: Colors.grey[200],
                      selectedItemBuilder: (BuildContext context) {
                        return opcionesNivelActividad.map<Widget>((String actividad) {
                          return Center(
                            child: Text(
                              selectedNivelActividad,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
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
            title: Flexible(
              child: Text(
                'Medica',
                style: _currentStep == 2 ? TextStyle(color: Colors.green, fontWeight: FontWeight.bold) : null,
              ),
            ),
            isActive: _currentStep == 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seleccion de unidades de medida para los alimentos'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuTheme(
                    data: PopupMenuThemeData(
                      color: Colors.grey[200],
                    ),
                    child: DropdownButton<String>(
                      value: selectedUnidadComida,
                      items: opcionesMedicionesComida.map((String comida) {
                        return DropdownMenuItem<String>(
                          value: comida,
                          child: Text(
                            comida,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedUnidadComida = value!;
                        });
                      },
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 32,
                      elevation: 16,
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      dropdownColor: Colors.grey[200],
                      selectedItemBuilder: (BuildContext context) {
                        return opcionesMedicionesComida.map<Widget>((String comida) {
                          return Center(
                            child: Text(
                              selectedUnidadComida,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
                Text('Seleccion de unidades de medida de las lecturas'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuTheme(
                    data: PopupMenuThemeData(
                      color: Colors.grey[200],
                    ),
                    child: DropdownButton<String>(
                      value: selectedUnidad,
                      items: opcionesMedicionesUnidad.map((String unidad) {
                        return DropdownMenuItem<String>(
                          value: unidad,
                          child: Text(
                            unidad,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedUnidad = value!;
                        });
                      },
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 32,
                      elevation: 16,
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      dropdownColor: Colors.grey[200],
                      selectedItemBuilder: (BuildContext context) {
                        return opcionesMedicionesComida.map<Widget>((String unidad) {
                          return Center(
                            child: Text(
                              selectedUnidad,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text('Hiperglucemia'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hiperController,
                        decoration: InputDecoration(
                          labelText: 'Ingrese el valor numerico de hiperglucemia',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Informacion'),
                              content: Text('La hiperglucemia es un término médico que se refiere a niveles elevados de glucosa en la sangre.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text('Hipoglucemia'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hipoController,
                        decoration: InputDecoration(
                          labelText: 'Ingrese el valor numerico de hipoglucemia',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Informacion'),
                              content: Text('La hipoglucemia es un término médico que se refiere a niveles bajos de glucosa en la sangre.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text('Valor ideal'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _objetivoController,
                        decoration: InputDecoration(
                          labelText: 'Ingrese el valor numerico de su nivel ideal de glucosa ',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Informacion'),
                              content: Text('Con este valor se considerará que el usuario posee un nivel de glucosa bueno.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
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
