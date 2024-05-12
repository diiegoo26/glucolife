import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CaloriasConsumidasVista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Llamada al provider para poder mantener la vista actualizada
    final selectedDateModel = Provider.of<SeleccionarFechaProvider>(context);
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

        ///  Filtrar por fecha
        List<QueryDocumentSnapshot> filteredDocs =
            snapshot.data!.docs.where((document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String dateString = data['fechaRegistro'];
          DateTime foodDate = dateFormatter.parse(dateString);
          return dateFormatter.format(foodDate) ==
              dateFormatter.format(selectedDate);
        }).toList();

        double totalCalorias = filteredDocs.fold(
          0,
          (sum, document) =>
              sum + (document.data() as Map<String, dynamic>)['totalCalorias'],
        );

        double limiteCalorias = 3000;

        List<PieChartSectionData> pieChartData = [
          PieChartSectionData(
            color: Colors.blue,
            value: totalCalorias,
            radius: 50,
          ),
          PieChartSectionData(
            color: Colors.white70,
            value: limiteCalorias - totalCalorias,
            radius: 50,
          ),
        ];

        return Card(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sections: pieChartData,
                      centerSpaceRadius: 20,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
