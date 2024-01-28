import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:provider/provider.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Actividad ejercicio;

  ExerciseDetailScreen({required this.ejercicio});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late String _selectedTiempo;
  late String _selectedIntensidad;
  double _caloriasQuemadas = 0.0;

  List<String> intensidades = ['Baja', 'Moderada', 'Alta'];
  List<String> tiempos = [
    '15 min',
    '30 min',
    '45 min',
    '1 hora',
    '1.5 horas',
    '2 horas'
  ];

  @override
  void initState() {
    super.initState();
    _selectedTiempo = widget.ejercicio.tiempoRealizado;
    _selectedIntensidad = widget.ejercicio.intensidad;

    if (!tiempos.contains(_selectedTiempo)) {
      _selectedTiempo = tiempos.first;
    }

    if (!intensidades.contains(_selectedIntensidad)) {
      _selectedIntensidad = intensidades.first;
    }
  }

  double calcularCaloriasQuemadas(String tiempo, String intensidad) {
    double factorIntensidad =
        intensidad == 'Alta' ? 2.0 : (intensidad == 'Moderada' ? 1.5 : 1.0);
    double tiempoRealizado = double.tryParse(tiempo.split(' ')[0]) ?? 0.0;
    return tiempoRealizado * factorIntensidad;
  }

  void calcularYMostrarCalorias() {
    double caloriasQuemadas =
        calcularCaloriasQuemadas(_selectedTiempo, _selectedIntensidad);
    setState(() {
      _caloriasQuemadas = caloriasQuemadas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Ejercicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre del ejercicio:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.ejercicio.nombre,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Tiempo realizado:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedTiempo,
              items: tiempos.map((String tiempo) {
                return DropdownMenuItem<String>(
                  value: tiempo,
                  child: Text(tiempo),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedTiempo = value!;
                });
              },
            ),
            SizedBox(height: 8),
            Text(
              'Intensidad:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedIntensidad,
              items: intensidades.map((String intensidad) {
                return DropdownMenuItem<String>(
                  value: intensidad,
                  child: Text(intensidad),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedIntensidad = value!;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularYMostrarCalorias,
              child: Text('Calcular Calorías'),
            ),
            SizedBox(height: 16),
            Text(
              'Calorías Quemadas: $_caloriasQuemadas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  widget.ejercicio.tiempoRealizado = _selectedTiempo;
                  widget.ejercicio.intensidad = _selectedIntensidad;
                  widget.ejercicio.caloriasQuemadas = _caloriasQuemadas;
                });

                // Llamar al método para guardar cambios en Firebase
                await Provider.of<ActividadViewModel>(context, listen: false)
                    .guardarActividadEnFirebase(widget.ejercicio);

                // Puedes agregar código adicional después de guardar los cambios si es necesario
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
