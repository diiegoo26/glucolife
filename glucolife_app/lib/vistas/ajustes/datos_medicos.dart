import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/viewmodel/ajustes_viewmodel.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';

class DatosMedicosVista extends StatefulWidget {
  @override
  _DatosMedicosVistaState createState() => _DatosMedicosVistaState();
}

class _DatosMedicosVistaState extends State<DatosMedicosVista> {
  bool showPassword = false;
  final LoginViewModel _loginViewModel = LoginViewModel();
  final AjustesViewModel _ajustesViewModel = AjustesViewModel();
  Usuario? _usuario;

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
        title: const Text('Datos medicos'),
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              construirCampos("Altura", "${_usuario?.altura}", (value) {
                setState(() {
                  _usuario?.altura = double.parse(value);
                });
              }),
              construirCampos("Peso", "${_usuario?.peso}", (value) {
                setState(() {
                  _usuario?.peso = double.parse(value);
                });
              }),
              construirCampos(
                  "Nivel de actividad física", "${_usuario?.nivelActividad}",
                      (value) {
                    setState(() {
                      _usuario?.nivelActividad = value;
                    });
                  }),
              construirCampos("Unidad de medición para la comida",
                  "${_usuario?.unidadComida}", (value) {
                    setState(() {
                      _usuario?.unidadComida = value;
                    });
                  }),
              construirCampos("Unidad", "${_usuario?.unidadMedida}", (value) {
                setState(() {
                  _usuario?.unidadMedida = value;
                });
              }),
              construirCampos(
                  "Nivel de hiperglucemia", "${_usuario?.hiperglucemia}",
                      (value) {
                    setState(() {
                      _usuario?.hiperglucemia = double.parse(value);
                    });
                  }),
              construirCampos(
                  "Nivel de hipoglucemia", "${_usuario?.hipoglucemia}",
                      (value) {
                    setState(() {
                      _usuario?.hipoglucemia = double.parse(value);
                    });
                  }),
              construirCampos("Nivel ideal", "${_usuario?.nivel_objetivo}", (value) {
                setState(() {
                  _usuario?.nivel_objetivo = double.parse(value);
                });
              }),
              const SizedBox(
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
                      child: const Text("Cancelar",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.black)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    child: ElevatedButton(
                      onPressed: () {
                        /// Llamada al servicio para almacenar los cambios
                        _ajustesViewModel.guardarDatosMedicos(_usuario,context);
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

  Widget construirCampos(
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
}
