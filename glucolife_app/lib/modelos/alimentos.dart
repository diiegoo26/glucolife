class Alimentos {
  final int fdcId;
  final String description;
  final List<Nutriente> foodNutrients;

  Alimentos({
    required this.fdcId,
    required this.description,
    required this.foodNutrients,
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
