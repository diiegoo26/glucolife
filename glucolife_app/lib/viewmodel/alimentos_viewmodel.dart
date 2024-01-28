import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
