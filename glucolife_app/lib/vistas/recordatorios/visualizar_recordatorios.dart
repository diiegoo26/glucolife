import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/viewmodel/medicaciones_viewmodel.dart';
import 'package:glucolife_app/vistas/medicacion/medicamentos.dart';
import 'package:glucolife_app/vistas/recordatorios/agregar_recordatorio.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class VisualizarRecordatorios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedDateModel = Provider.of<SelectedDateModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios'), // Mostrar la fecha seleccionada
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
            child: ListaRecordatorios(),
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
                    builder: (context) => AgregarRecordatorio(),
                  ),
                );
              },
              child: Text('Agregar recordatorio'),
            ),
          ),
        ],
      ),
    );
  }
}

class ListaRecordatorios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('recordatorio')
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
        final recordatorios = snapshot.data!.docs;

        return ListView.builder(
          itemCount: recordatorios.length,
          itemBuilder: (context, index) {
            final recordatorio = recordatorios[index];
            final descripcion = recordatorio['descripcion'];
            final fecha = recordatorio['fecha'];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(descripcion),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha: $fecha'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Llama a la función para eliminar el medicamento
                    LocalNotifications.eliminar(context, recordatorio.id);
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



