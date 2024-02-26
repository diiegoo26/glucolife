import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucolife_app/servicios/WgerService.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/vistas/deportes/buscador_actividad.dart';

class VisualizarActividad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualización de Actividad'),
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
            child: ListaActividades(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuscadorActividades(),
                  ),
                );
              },
              child: Text('Agregar actividad'),
            ),
          ),
        ],
      ),
    );
  }
}

class ListaActividades extends StatelessWidget {
  ActividadViewModel _viewModel = ActividadViewModel(
    exerciseService: WgerService(), // Reemplaza con tu instancia de WgerService
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('actividades').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            return Card(
              elevation: 3, // Añadir sombra
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(data['nombre']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  /*children: [
                    Text('Calorías: ${data['totalCalorias']} kcal'),
                    Text('Proteínas: ${data['proteinas']} g'),
                    Text('Carbohidratos: ${data['carbohidratos']} g'),
                    Text('Grasas: ${data['grasas']} g'),
                  ],*/
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Llamar a la función para eliminar el medicamento
                    _viewModel.eliminar(context, document.id);
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
