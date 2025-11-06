// models/recipe.dart
class Recipe {
  final String name;
  final List<String> ingredients;
  final int preparationTime;
  final int price;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.preparationTime,
    required this.price,
  });
}