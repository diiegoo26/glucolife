import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/viewmodel/login_viewmodel.dart';
import 'package:glucolife_app/vistas/deportes/visualizar_actividad.dart';
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

  double calcularCaloriasQuemadas(String tiempo, String intensidad, double peso, double altura) {
    double factorIntensidad = intensidad == 'Alta' ? 2.0 : (intensidad == 'Moderada' ? 1.5 : 1.0);
    double tiempoRealizado = double.tryParse(tiempo.split(' ')[0]) ?? 0.0;

    // Fórmula de Harris-Benedict para el metabolismo basal (MB)
    double mb = 66.5 + (13.75 * peso) + (5.003 * altura) - (6.75 * 25); // En hombres
    // Para mujeres, el cálculo sería ligeramente diferente

    // Calorías quemadas por minuto
    double caloriasPorMinuto = mb / tiempoRealizado; // 1440 es el número de minutos en un día

    // Calorías quemadas durante el ejercicio
    double caloriasQuemadas = caloriasPorMinuto * tiempoRealizado * factorIntensidad;

    return caloriasQuemadas;
  }


  void calcularYMostrarCalorias() {
    double caloriasQuemadas =
    calcularCaloriasQuemadas(_selectedTiempo, _selectedIntensidad,98,180);
    setState(() {
      _caloriasQuemadas = caloriasQuemadas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Ejercicio'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            SizedBox(height: 24),
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
            SizedBox(height: 24),
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
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: calcularYMostrarCalorias,
              child: Text('Calcular Calorías'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Calorías Quemadas: $_caloriasQuemadas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisualizarActividad(),
                  ),
                );
              },
              child: Text('Guardar Cambios'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
