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
  final String creamColor; // 'white', 'pink', 'brown', 'blue'
  final String topping;    // 'strawberry', 'sprinkles', 'chocolate', 'cherry'

  CakeRecipe({
    required this.creamColor,
    required this.topping,
  });

  // Check if two recipes match
  bool matches(CakeRecipe other) {
    return creamColor == other.creamColor &&
        topping == other.topping;
  }
}