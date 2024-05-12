import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/deportes/buscador_actividad.dart';
import 'package:glucolife_app/vistas/deportes/lista_actividades.dart';

/// Esta clase representa la visualizacion detallada de las actividades que se quieren agregar
class VisualizarActividad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividad física'),
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
            child: ListaActividadesVista(),
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
                    builder: (context) => BuscadorActividadesVista(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search, // El icono que deseas usar
                    color: Colors.green, // Color del icono
                  ),
                  SizedBox(width: 10), // Espacio entre el icono y el texto
                  Text(
                    'Buscar actividad física',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}


