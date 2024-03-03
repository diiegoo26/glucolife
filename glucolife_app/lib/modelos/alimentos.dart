import 'package:cloud_firestore/cloud_firestore.dart';

class Alimentos {
  final int fdcId;
  final String description;
  final List<Nutriente> foodNutrients;
  final DateTime fechaRegistro;

  Alimentos({
    required this.fdcId,
    required this.description,
    required this.foodNutrients,
    required this.fechaRegistro,
  });
}


class Nutriente {
  final int nutrientId;
  final String nutrientName;
  final double value;

  Nutriente({
    required this.nutrientId,
    required this.nutrientName,
    required this.value,
  });
}
