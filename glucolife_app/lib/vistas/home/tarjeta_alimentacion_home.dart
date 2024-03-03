import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/home/alimentos_home.dart';

class TarjetaAlimentacionHome extends StatelessWidget {
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
              'Alimentación',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Calorias consumidas',
              style: TextStyle(
                color: Colors.green.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CaloriasConsumidas()
          ]
        ),
      ),
    );
  }
}