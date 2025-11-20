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

class MilkTeaRecipe {
  final String teaBase;     // 'black', 'green', 'oolong', 'taro'
  final String sweetness;   // 'none', 'light', 'regular', 'extra'
  final String topping;     // 'boba', 'jelly', 'pudding', 'none'

  MilkTeaRecipe({
    required this.teaBase,
    required this.sweetness,
    required this.topping,
  });

  // Check if two recipes match
  bool matches(MilkTeaRecipe other) {
    return teaBase == other.teaBase &&
        sweetness == other.sweetness &&
        topping == other.topping;
  }

  // Helper to get display names
  String getTeaBaseName() {
    switch (teaBase) {
      case 'black':
        return 'Black Tea';
      case 'green':
        return 'Green Tea';
      case 'oolong':
        return 'Oolong Tea';
      case 'taro':
        return 'Taro Milk Tea';
      default:
        return teaBase;
    }
  }

  String getSweetnessName() {
    switch (sweetness) {
      case 'none':
        return 'No Sugar';
      case 'light':
        return '25% Sweet';
      case 'regular':
        return '50% Sweet';
      case 'extra':
        return '100% Sweet';
      default:
        return sweetness;
    }
  }

  String getToppingName() {
    switch (topping) {
      case 'boba':
        return 'Boba Pearls';
      case 'jelly':
        return 'Grass Jelly';
      case 'pudding':
        return 'Pudding';
      case 'none':
        return 'No Topping';
      default:
        return topping;
    }
  }

  // Format for order display
  String getFullOrderDescription() {
    return '${getTeaBaseName()}\n${getSweetnessName()}\n+ ${getToppingName()}';
  }
}