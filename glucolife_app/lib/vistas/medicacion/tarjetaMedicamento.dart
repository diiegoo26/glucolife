import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/servicios/MedicamentoServicio.dart';
import 'package:glucolife_app/viewmodel/medicamentos_viewmodel.dart';

class TarjetaMedicamentoVista extends StatelessWidget {
  final MedicamentoViewModel _medicamentoViewModel=MedicamentoViewModel(medicamentoServicio: MedicamentoServicio());
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      /// Filtra por usuario
      stream: FirebaseFirestore
          .instance
          .collection('medicamentos')
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

        final medicamentos = snapshot.data!.docs;

        return ListView.builder(
          itemCount: medicamentos.length,
          itemBuilder: (context, index) {
            final medicamento = medicamentos[index];
            final nombre = medicamento['nombre'];
            final dosis = medicamento['dosis'];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/imagenes/medicamentos.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Card(
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
                      /// Llamada al servicio para eliminar el medicamente de Firebase
                      _medicamentoViewModel.eliminarMedicamento(medicamento.id);
                    },
                  ),
                ),
              )
            );
          },
        );
      },
    );
  }
}