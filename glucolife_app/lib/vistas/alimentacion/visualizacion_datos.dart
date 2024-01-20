import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/alimentacion/buscador_alimentos.dart';

class VisualizacionAlimentacion extends StatefulWidget {
  @override
  _VisualizacionAlimentacionState createState() => _VisualizacionAlimentacionState();
}

class _VisualizacionAlimentacionState extends State<VisualizacionAlimentacion> {
  TextEditingController _carbsController = TextEditingController();
  TextEditingController _proteinsController = TextEditingController();
  TextEditingController _fatsController = TextEditingController();

  List<NutrientData> _nutrientData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrición'),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNutrientInput(_carbsController, 'Carbohidratos', Colors.red),
            _buildNutrientInput(_proteinsController, 'Proteínas', Colors.blue),
            _buildNutrientInput(_fatsController, 'Grasas', Colors.green),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculatePercentage,
              child: Text('Calculador'),
            ),
            SizedBox(height: 20),
            if (_nutrientData.isNotEmpty) ...[
              _buildNutrientData(),
              SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuscadorAlimentos()),
                );
              },
              child: Text('Agregar comida'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInput(
      TextEditingController controller, String nutrient, Color color) {
    return Column(
      children: [
        Container(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: nutrient,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void _calculatePercentage() {
    double total = double.parse(_carbsController.text) +
        double.parse(_proteinsController.text) +
        double.parse(_fatsController.text);

    setState(() {
      _nutrientData = [
        NutrientData(
          'Carbohidratos',
          double.parse(_carbsController.text),
          Colors.red,
          double.parse(_carbsController.text) / total * 100,
        ),
        NutrientData(
          'Proteínas',
          double.parse(_proteinsController.text),
          Colors.blue,
          double.parse(_proteinsController.text) / total * 100,
        ),
        NutrientData(
          'Grasas',
          double.parse(_fatsController.text),
          Colors.green,
          double.parse(_fatsController.text) / total * 100,
        ),
      ];
    });
  }

  Widget _buildNutrientData() {
    return Column(
      children: _nutrientData.map((nutrient) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '${nutrient.nutrient}: ${nutrient.quantity.toStringAsFixed(2)}g, ${nutrient.percentage.toStringAsFixed(2)}%',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class NutrientData {
  final String nutrient;
  final double quantity;
  final double percentage;
  final Color color;

  NutrientData(this.nutrient, this.quantity, this.color, this.percentage);
}
