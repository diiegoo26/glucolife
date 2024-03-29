import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucolife_app/viewmodel/alimentos_viewmodel.dart';
import 'package:glucolife_app/vistas/alimentacion/buscador_alimentos.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../provider/provider_fecha.dart';

class VisualizarAlimentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedDateModel = Provider.of<SelectedDateModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Alimentación'), // Mostrar la fecha seleccionada
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
            child: ListaAlimentos(),
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
  AlimentosViewModel _viewModel = AlimentosViewModel();

  @override
  Widget build(BuildContext context) {
    final selectedDateModel = Provider.of<SelectedDateModel>(context);
    DateTime selectedDate = selectedDateModel.selectedDate;

    final dateFormatter = DateFormat('yyyy-MM-dd');

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('alimentos')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Filtrar los documentos por fecha en Flutter (no en Firestore)
        List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs
            .where((document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String dateString = data['fechaRegistro'];
          // Convertir la cadena de fecha a DateTime
          DateTime foodDate = dateFormatter.parse(dateString);
          // Comparar las fechas
          return dateFormatter.format(foodDate) == dateFormatter.format(selectedDate);
        })
            .toList();

        return ListView(
          children: filteredDocs.map((DocumentSnapshot document) {
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





