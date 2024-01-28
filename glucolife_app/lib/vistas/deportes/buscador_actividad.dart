// exercise_screen.dart
import 'package:flutter/material.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/vistas/deportes/agregar_actividad.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ActividadViewModel>(context, listen: false).fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ActividadViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                viewModel.filterExercises(query);
              },
              decoration: InputDecoration(
                labelText: 'Buscar ejercicio',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.filteredExercises.length,
              itemBuilder: (context, index) {
                final ejercicio = viewModel.filteredExercises[index];
                return ListTile(
                  title: Text(ejercicio.nombre),
                  onTap: () {
                    // Navegar a la pantalla de detalles del ejercicio
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(
                          ejercicio: ejercicio,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
