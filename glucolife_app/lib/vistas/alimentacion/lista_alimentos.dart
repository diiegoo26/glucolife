import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:intl/intl.dart';
import 'package:glucolife_app/viewmodel/alimentos_viewmodel.dart';
import 'package:provider/provider.dart';

class ListaAlimentosVista extends StatelessWidget {
  final AlimentosViewModel viewModel = AlimentosViewModel();

  @override
  Widget build(BuildContext context) {
    return Consumer<SeleccionarFechaProvider>(
      builder: (context, selectedDateModel, _) {
        DateTime selectedDate = selectedDateModel.seleccionarFecha;
        final dateFormatter = DateFormat('yyyy-MM-dd');
        User? currentUser = FirebaseAuth.instance.currentUser;

        return StreamBuilder(
          /// Filtrar por usuario
          stream: FirebaseFirestore.instance
              .collection('alimentos')
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

            /// Filtrar por fecha los alimentos
            List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs
                .where((document) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              String dateString = data['fechaRegistro'];
              DateTime foodDate = dateFormatter.parse(dateString);
              return dateFormatter.format(foodDate) ==
                  dateFormatter.format(selectedDate);
            })
                .toList();

            return ListView(
              children: filteredDocs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage('assets/imagenes/comida.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                          /// Llamada al servicio para poder eliminar el alimento
                          viewModel.eliminarAlimento(document.id);
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
