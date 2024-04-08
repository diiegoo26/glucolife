import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/viewmodel/medicaciones_viewmodel.dart';
import 'package:glucolife_app/vistas/medicacion/medicamentos.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class VisualizarMedicamentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedDateModel = Provider.of<SelectedDateModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicación'), // Mostrar la fecha seleccionada
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
                    builder: (context) => AgregarMedicamentos(),
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

class ListaActividades extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('medicamentos')
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

        // Si la consulta tiene éxito y hay datos disponibles
        final medicamentos = snapshot.data!.docs;

        return ListView.builder(
          itemCount: medicamentos.length,
          itemBuilder: (context, index) {
            final medicamento = medicamentos[index];
            final nombre = medicamento['nombre'];
            final dosis = medicamento['dosis'];

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre: $nombre'),
                    Text('Dosis: $dosis'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Llama a la función para eliminar el medicamento
                    LocalNotifications.eliminar(context, medicamento.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}



