import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/medicacion/agregar_medicamentos.dart';
import 'package:glucolife_app/vistas/medicacion/tarjetaMedicamento.dart';

class VisualizarMedicamentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicación'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: TarjetaMedicamentoVista(),
          ),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgregarMedicamentos(),
                  ),
                );
              },
              child: Text('Agregar medicación'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



