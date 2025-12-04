class GameCharacter {
  final String id;            // unique key for reference
  final String sprite;        // asset filename
  final String? milkTeaOrder; // one or the other, or both
  final String? cakeOrder;

  const GameCharacter({
    required this.id,
    required this.sprite,
    this.milkTeaOrder,
    this.cakeOrder,
  });
}