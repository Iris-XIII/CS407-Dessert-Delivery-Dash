class Player {
  final String userId;
  final double money;
  final int dayNumber;

  Player({
    required this.userId,
    this.money = 0.0,
    this.dayNumber = 1,
  });

  // Constructor to create a model from a Firestore map
  factory Player.fromMap(Map<String, dynamic> map, String id) {
    return Player(
      userId: id,
      money: (map['money'] ?? 0.0).toDouble(), // Safely handle null and type
      dayNumber: map['dayNumber'] ?? 1,
    );
  }

  // Method to convert the model to a map for Firestore saving
  Map<String, dynamic> toMap() {
    return {
      'money': money,
      'dayNumber': dayNumber,
      // Add other progress fields here (e.g., 'upgrades')
    };
  }
}