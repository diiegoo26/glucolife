import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucolife_app/viewmodel/medicacion.viewmodel.dart';
import 'package:glucolife_app/vistas/alimentacion/buscador_alimentos.dart';
import 'package:glucolife_app/vistas/medicacion/agregar_medicamento.dart';

class VisualizarMedicacion extends StatelessWidget {
  MedicamentoViewModel _viewModel=MedicamentoViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualización de medicación'),
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
            child: ListaMedicamentos(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgregarMedicamento(),
                  ),
                );
              },
              child: Text('Agregar medicación'),
            ),
          ),
        ],
      ),
    );
  }
}

class ListaMedicamentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MedicamentoViewModel viewModel=MedicamentoViewModel();
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('medicamentos').snapshots(),
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
                  children: [
                    Text('Dosis: ${data['dosis']}'),
                    Text('Fecha de inicio: ${data['fechaInicio']}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Llamar a la función para eliminar el medicamento
                    viewModel.eliminar(context, document.id);
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

