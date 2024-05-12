import 'package:flutter/material.dart';

class TarjetaAlimentacionVista extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  TarjetaAlimentacionVista(this.title, this.value, this.unit);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.green[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              offset: Offset(0, 3),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              '$value $unit',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
