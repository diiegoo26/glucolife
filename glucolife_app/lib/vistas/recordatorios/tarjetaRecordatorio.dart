import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/servicios/RecordatorioServicio.dart';
import 'package:glucolife_app/viewmodel/recordatorio_viewmodel.dart';

class TarjetaRecordatorioVista extends StatelessWidget {
  RecordatorioViewModel _recordatorioViewModel=RecordatorioViewModel(recordatorioServicio: RecordatorioServicio());
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      /// Filtrar por usuario
      stream: FirebaseFirestore
          .instance
          .collection('recordatorio')
          .where('usuario', isEqualTo: currentUser?.uid)
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

        final recordatorios = snapshot.data!.docs;

        return ListView.builder(
          itemCount: recordatorios.length,
          itemBuilder: (context, index) {
            final recordatorio = recordatorios[index];
            final descripcion = recordatorio['descripcion'];
            final fechaTimestamp = recordatorio['fecha'];
            final fecha = (fechaTimestamp as Timestamp).toDate();
            final fechaFormateada = DateFormat('dd MMMM, HH:mm').format(fecha);
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/imagenes/recordatorios.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Card(
                child: ListTile(
                  title: Text(descripcion),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: $fechaFormateada'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      /// Llamada al servicio para eliminar el recordatorio en Firebase
                      _recordatorioViewModel.eliminarRecordatorio(recordatorio.id);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}