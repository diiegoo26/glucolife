import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:intl/intl.dart';

class AlimentosServicio {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Agrega un alimento a la base de datos de Firebase.
  ///
  /// [producto]: El alimento a ser agregado.
  /// [cantidadUnidades]: La cantidad de unidades del alimento.
  /// [fechaSeleccionada]: Indica la fecha de cuando ha sido registrada
  ///
  /// Muestra excepciones cuando el usuario no se encuentra autentificado o cuando no se puede almacenar el alimento en Firebase
  Future<void> agregarAlimentoAFirebase(
      Alimentos producto, int cantidadUnidades,DateTime fechaSeleccionada) async {
    try {
      double totalCalorias = calcularCaloriasTotales([producto]) * cantidadUnidades;
      
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference alimentosCollection =
        firestore.collection('alimentos');
        
        await alimentosCollection.add({
          'usuario': uid,
          'descripcion': producto.descripcion,
          'proteinas': producto.nutrientes
              .where((nutriente) => nutriente.nombre_nutriente == 'Protein')
              .map((nutriente) => nutriente.valor*cantidadUnidades)
              .join(', '),
          'carbohidratos': producto.nutrientes
              .where((nutriente) =>
          nutriente.nombre_nutriente == 'Carbohydrate, by difference')
              .map((nutriente) => nutriente.valor*cantidadUnidades)
              .join(', '),
          'grasas': producto.nutrientes
              .where((nutriente) => nutriente.nombre_nutriente == 'Total lipid (fat)')
              .map((nutriente) => nutriente.valor*cantidadUnidades)
              .join(', '),
          'totalCalorias': totalCalorias,
          'cantidadUnidades': cantidadUnidades,
          'fechaRegistro': DateFormat('yyyy-MM-dd').format(fechaSeleccionada),
        });

      } else {
        print('Usuario no autenticado');
      }
    } catch (error) {
      print('Error al almacenar en Firebase: $error');
    }
  }


  /// Elimina un alimento de la base de datos de Firebase.
  ///
  /// [documentId]: ID del documento del alimento a ser eliminado.
  ///
  /// Muestra excepciones cuando no se puede eliminar de Firebase
  Future<void> eliminarAlimento(String documentId) async {
    try {
      await _firestore.collection('alimentos').doc(documentId).delete();
    } catch (error) {
      print("Error al eliminar");
      throw error;
    }
  }

  /// Obtiene los valores nutricionales totales de los alimentos
  ///
  /// Retorna un mapa con los valores
  ///
  /// Devuelve excepciones cuando el usuario no se encuentra autentificado o no se encuantra dichos valores nutricionales
  Future<Map<String, double>> obtenerValoresTotal() async {
    try {
      // Obtener el usuario actualmente autenticado
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        CollectionReference alimentosCollection =
        FirebaseFirestore.instance.collection('alimentos');

        QuerySnapshot querySnapshot = await alimentosCollection
            .where('usuario', isEqualTo: uid)
            .get();

        double grasasTotales = querySnapshot.docs
            .map((doc) => double.tryParse(doc['grasas'] ?? '0') ?? 0.0)
            .fold(0, (previous, current) => previous + current);

        double proteinasTotales = querySnapshot.docs
            .map((doc) => double.tryParse(doc['proteinas'] ?? '0') ?? 0.0)
            .fold(0, (previous, current) => previous + current);

        double carboTotales = querySnapshot.docs
            .map((doc) => double.tryParse(doc['carbohidratos'] ?? '0') ?? 0.0)
            .fold(0, (previous, current) => previous + current);

        return {
          'grasasTotales': grasasTotales,
          'proteinasTotales': proteinasTotales,
          'carboTotales': carboTotales,
        };
      } else {
        print('Usuario no autenticado');
        return {
          'grasasTotales': 0.0,
          'proteinasTotales': 0.0,
          'carboTotales': 0.0,
        };
      }
    } catch (error) {
      print('Error al obtener los valores totales: $error');
      return {
        'grasasTotales': 0.0,
        'proteinasTotales': 0.0,
        'carboTotales': 0.0,
      };
    }
  }

  /// Calcula las calorías totales de una lista de alimentos.
  ///
  /// [alimentos]: Lista de alimentos para calcular las calorías totales.
  ///
  /// Retorna la cantidad total de calorías.
  double calcularCaloriasTotales(List<Alimentos> alimentos) {
    double totalCalorias = 0.0;

    for (var alimento in alimentos) {
      for (var nutriente in alimento.nutrientes) {
        if (nutriente.nombre_nutriente == 'Protein' ||
            nutriente.nombre_nutriente == 'Carbohydrate, by difference' ||
            nutriente.nombre_nutriente == 'Total lipid (fat)') {
          totalCalorias += nutriente.valor;
        }
      }
    }

    return totalCalorias;
  }

  /// Calcula el total de proteínas consumidas de una lista de alimentos.
  ///
  /// [alimentos]: Lista de alimentos para calcular las proteínas totales.
  ///
  /// Retorna la cantidad total de proteínas.
  double calcularTotalProteinas(List<Alimentos> alimentos) {
    double totalProteinas = 0.0;

    for (var alimento in alimentos) {
      for (var nutriente in alimento.nutrientes) {
        if (nutriente.nombre_nutriente == 'Protein') {
          totalProteinas += nutriente.valor;
        }
      }
    }

    return totalProteinas;
  }

  /// Calcula el total de carbohidratos consumidos de una lista de alimentos.
  ///
  /// [alimentos]: Lista de alimentos para calcular los carbohidratos totales.
  ///
  /// Retorna la cantidad total de carbohidratos.
  double calcularTotalCarbohidratos(List<Alimentos> alimentos) {
    double totalCarbohidratos = 0.0;

    for (var alimento in alimentos) {
      for (var nutriente in alimento.nutrientes) {
        if (nutriente.nombre_nutriente == 'Carbohydrate, by difference') {
          totalCarbohidratos += nutriente.valor;
        }
      }
    }

    return totalCarbohidratos;
  }

  /// Calcula el total de grasas consumidas de una lista de alimentos.
  ///
  /// [alimentos]: Lista de alimentos para calcular las grasas totales.
  ///
  /// Retorna la cantidad total de grasas.
  double calcularTotalGrasas(List<Alimentos> alimentos) {
    double totalGrasas = 0.0;

    for (var alimento in alimentos) {
      for (var nutriente in alimento.nutrientes) {
        if (nutriente.nombre_nutriente == 'Total lipid (fat)') {
          totalGrasas += nutriente.valor;
        }
      }
    }

    return totalGrasas;
  }
}
