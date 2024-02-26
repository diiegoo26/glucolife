import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:glucolife_app/servicios/NutritionixService.dart';

class AlimentosViewModel {
  USDAFood usdaFood = USDAFood();

  // Obtener la instancia de FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> agregarAlimentoAFirebase(
      Alimentos product, int cantidadUnidades) async {
    try {
      double totalCalorias =
          usdaFood.calcularCaloriasTotales([product]) * cantidadUnidades;

      // Obtener el usuario actualmente autenticado
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Si hay un usuario autenticado, obtener su UID
        String uid = currentUser.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference alimentosCollection =
            firestore.collection('alimentos');

        await alimentosCollection.add({
          'usuario': uid, // Añadir el UID del usuario al documento
          'descripcion': product.description,
          'proteinas': product.foodNutrients
              .where((nutriente) => nutriente.nutrientName == 'Protein')
              .map((nutriente) => nutriente.value)
              .join(', '),
          'carbohidratos': product.foodNutrients
              .where((nutriente) =>
                  nutriente.nutrientName == 'Carbohydrate, by difference')
              .map((nutriente) => nutriente.value)
              .join(', '),
          'grasas': product.foodNutrients
              .where(
                  (nutriente) => nutriente.nutrientName == 'Total lipid (fat)')
              .map((nutriente) => nutriente.value)
              .join(', '),
          'totalCalorias': totalCalorias,
          'cantidadUnidades': cantidadUnidades,
        });

        // Mensaje de éxito o realizar otras acciones después de almacenar en Firebase
      } else {
        print('Usuario no autenticado');
        // Manejar el caso en el que no haya usuario autenticado según tus necesidades
      }
    } catch (error) {
      print('Error al almacenar en Firebase: $error');
      // Manejar el error según tus necesidades
    }
  }

  Future<void> eliminar(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('alimentos')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alimento eliminado con éxito'),
        ),
      );
      obtenerValoresTotal();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el alimento'),
        ),
      );
    }
  }

  Future<Map<String, double>> obtenerValoresTotal() async {
    try {
      // Obtener el usuario actualmente autenticado
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Si hay un usuario autenticado, obtener su UID
        String uid = currentUser.uid;

        // Obtener la referencia a la colección de alimentos
        CollectionReference alimentosCollection =
        FirebaseFirestore.instance.collection('alimentos');

        // Obtener documentos que pertenecen al usuario
        QuerySnapshot querySnapshot = await alimentosCollection
            .where('usuario', isEqualTo: uid)
            .get();

        // Sumar las grasas, proteínas y carbohidratos de todos los alimentos del usuario
        double grasasTotales = querySnapshot.docs
            .map((doc) => double.tryParse(doc['grasas'] ?? '0') ?? 0.0)
            .fold(0, (previous, current) => previous + current);

        double proteinasTotales = querySnapshot.docs
            .map((doc) => double.tryParse(doc['proteinas'] ?? '0') ?? 0.0)
            .fold(0, (previous, current) => previous + current);

        double carboTotales = querySnapshot.docs
            .map((doc) => double.tryParse(doc['carbohidratos'] ?? '0') ?? 0.0)
            .fold(0, (previous, current) => previous + current);

        // Devolver un mapa con los valores totales
        return {
          'grasasTotales': grasasTotales,
          'proteinasTotales': proteinasTotales,
          'carboTotales': carboTotales,
        };
      } else {
        // Manejar el caso en el que no haya usuario autenticado según tus necesidades
        print('Usuario no autenticado');
        return {
          'grasasTotales': 0.0,
          'proteinasTotales': 0.0,
          'carboTotales': 0.0,
        }; // O cualquier otro valor predeterminado
      }
    } catch (error) {
      // Manejar el error según tus necesidades
      print('Error al obtener los valores totales: $error');
      return {
        'grasasTotales': 0.0,
        'proteinasTotales': 0.0,
        'carboTotales': 0.0,
      }; // O cualquier otro valor predeterminado
    }
  }

}
