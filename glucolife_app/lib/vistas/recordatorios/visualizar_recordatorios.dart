import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/recordatorios/agregar_recordatorio.dart';
import 'package:glucolife_app/vistas/recordatorios/tarjetaRecordatorio.dart';

class VisualizarRecordatorios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios'),
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
            child: TarjetaRecordatorioVista(),
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
                    builder: (context) => AgregarRecordatorio(),
                  ),
                );
              },
              child: Text('Agregar recordatorio'),
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



