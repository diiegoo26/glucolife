import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/home/actividad_home.dart';

class TarjetaActividadHomeVista extends StatelessWidget {
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
              'Actividad',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Calorias quemadas por día',
              style: TextStyle(
                color: Colors.green.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            CaloriasQuemadasVista()
          ],
        ),
      ),
    );
  }
}