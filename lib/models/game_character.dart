class GameCharacter {
  final String id;            // unique key for reference
  final String sprite;        // asset filename
  final MilkTeaOrder? milkTeaOrder;
  final CakeOrder? cakeOrder;

  const GameCharacter({
    required this.id,
    required this.sprite,
    this.milkTeaOrder,
    this.cakeOrder,
  });
}

class MilkTeaOrder {
  final String sweetness;
  final String base;
  final String topping;

  const MilkTeaOrder({
    required this.sweetness,
    required this.base,
    required this.topping,
  });

  @override
  String toString() => 'MilkTeaOrder(sweetness: $sweetness, base: $base, topping: $topping)';
}

class CakeOrder {
  final String cake;
  final String topping;

  const CakeOrder({
    required this.cake,
    required this.topping,
  });

  @override
  String toString() => 'CakeOrder(cake: $cake, topping: $topping)';
}