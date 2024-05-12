import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/home/grafica_no_actual.dart';

class TarjetaGraficoNoActualVista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(30),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sensor',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            LecturaNoActualVista(),
          ],
        ),
      ),
    );
  }
}