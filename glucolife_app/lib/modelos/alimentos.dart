class Alimentos {
   int fdcId;
   String description;
   List<Nutriente> foodNutrients;
   DateTime fechaRegistro;

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
