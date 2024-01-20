import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/deportes/buscador_deportes.dart';


class VisualizacionActividad extends StatefulWidget {
  const VisualizacionActividad({Key? key}) : super(key: key);

  @override
  _VisualizacionActividadState createState() => _VisualizacionActividadState();
}

class _VisualizacionActividadState extends State<VisualizacionActividad> {
  DateTime? fechaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividad'),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 20),
              
              SizedBox(height: 20),
               _construirBoton('Registrar Actividad', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuscadorDeportes(),
                  ),
                );
              }),
              SizedBox(height: 20),
              _construirBoton('Sugerencias', () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirBoton(String texto, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(texto),
    );
  }
}
