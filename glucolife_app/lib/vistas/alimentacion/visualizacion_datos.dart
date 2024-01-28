import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucolife_app/vistas/alimentacion/buscador_alimentos.dart';

class VisualizarAlimentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualización de Alimentos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListaAlimentos(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuscadorAlimentos(),
                  ),
                );
              },
              child: Text('Agregar alimentos'),
            ),
          ),
        ],
      ),
    );
  }
}

class ListaAlimentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('alimentos').snapshots(),
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
                title: Text(data['descripcion']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calorías: ${data['totalCalorias']} kcal'),
                    Text('Proteínas: ${data['proteinas']} g'),
                    Text('Carbohidratos: ${data['carbohidratos']} g'),
                    Text('Grasas: ${data['grasas']} g'),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
