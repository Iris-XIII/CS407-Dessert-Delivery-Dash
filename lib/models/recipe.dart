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

class CakeRecipe {
  final String baseShape;  // 'round', 'square'
  final String creamColor; // 'white', 'pink', 'brown'
  final String topping;    // 'strawberry', 'sprinkles', 'chocolate'

  CakeRecipe({
    required this.baseShape,
    required this.creamColor,
    required this.topping,
  });

  // Check if two recipes match
  bool matches(CakeRecipe other) {
    return baseShape == other.baseShape &&
        creamColor == other.creamColor &&
        topping == other.topping;
  }
}