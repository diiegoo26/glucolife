import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/vistas/deportes/buscador_actividad.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../provider/provider_fecha.dart';

class VisualizarActividad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedDateModel = Provider.of<SelectedDateModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividad física'), // Mostrar la fecha seleccionada
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
  @override
  Widget build(BuildContext context) {
    final selectedDateModel = Provider.of<SelectedDateModel>(context);
    DateTime selectedDate = selectedDateModel.selectedDate;

    final dateFormatter = DateFormat('yyyy-MM-dd');

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('actividades')
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
                title: Text(data['nombre']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Intensidad: ${data['intensidad']}'),
                    Text('Duración: ${data['tiempoRealizado']}'),
                    Text('Calorias quemadas: ${data['caloriasQuemadas']} kcal'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Llamar a la función para eliminar el medicamento
                    eliminar(context, document.id);
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void eliminar(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('actividades')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Actividad eliminada con éxito'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la actividad'),
        ),
      );
    }
  }
}


