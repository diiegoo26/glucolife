import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:provider/provider.dart';

class ListaActividadesVista extends StatelessWidget {
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
              .collection('actividades')
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

            /// Filtrar por fecha
            List<QueryDocumentSnapshot> filteredDocs =
                snapshot.data!.docs.where((document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String dateString = data['fechaRegistro'];
              DateTime activityDate = dateFormatter.parse(dateString);
              return dateFormatter.format(activityDate) ==
                  dateFormatter.format(selectedDate);
            }).toList();

            return ListView(
              children: filteredDocs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage('assets/imagenes/actividad.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(data['nombre']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Intensidad: ${data['intensidad']}'),
                          Text('Duración: ${data['tiempoRealizado']}'),
                          Text(
                              'Calorías quemadas: ${data['caloriasQuemadas']} kcal'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          /// Llamada al provider para poder mantener la vista actualizada
                          ActividadViewModel actividadViewModel =
                              Provider.of<ActividadViewModel>(context,
                                  listen: false);

                          /// Llamada al servicio para eliminar la actividad
                          actividadViewModel.eliminarActividad(document.id);
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
