import 'package:flutter/material.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/vistas/deportes/agregar_actividad.dart';
import 'package:provider/provider.dart';

class BuscadorActividadesVista extends StatefulWidget {
  @override
  _BuscadorActividadesVistaState createState() =>
      _BuscadorActividadesVistaState();
}

class _BuscadorActividadesVistaState extends State<BuscadorActividadesVista> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Llamada al provider para poder mantener la vista actualizada
    Provider.of<ActividadViewModel>(context, listen: false)
        .obtenerActividades();
  }

  @override
  Widget build(BuildContext context) {
    /// Llamada al provider para poder mantener la vista actualizada
    final actividadViewModel = Provider.of<ActividadViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                /// Llamada al servicio para realizar la busqueda de ejercicios
                actividadViewModel.filterejercicios(query);
              },
              decoration: InputDecoration(
                labelText: 'Buscar ejercicio',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: actividadViewModel.filtrar.length,
              itemBuilder: (context, index) {
                final ejercicio = actividadViewModel.filtrar[index];
                return ListTile(
                  title: Text(ejercicio.nombre),
                  onTap: () {
                    // Navegar a la pantalla de detalles del ejercicio
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgregarActividadVista(
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
