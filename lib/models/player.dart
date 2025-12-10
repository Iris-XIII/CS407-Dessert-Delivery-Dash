/// Player model to track game progress and state
/// This centralizes player data so it can be easily passed between screens
class Player {
  final int day;
  final int money;
  final int level;
  final String? userId;  // Optional Firebase user ID

  const Player({
    required this.day,
    required this.money,
    this.level = 1,
    this.userId,
  });

  /// Create a copy of Player with updated values
  Player copyWith({
    int? day,
    int? money,
    int? level,
    String? userId,
  }) {
    return Player(
      day: day ?? this.day,
      money: money ?? this.money,
      level: level ?? this.level,
      userId: userId ?? this.userId,
    );
  }

  /// Calculate level based on day (example formula)
  /// You can adjust this formula to match your game design
  static int calculateLevel(int day) {
    if (day <= 5) return 1;
    if (day <= 10) return 2;
    if (day <= 15) return 3;
    if (day <= 20) return 4;
    if (day <= 25) return 5;
    return 6; // Level 6 for days 26-30
  }

  /// Create Player from current game state
  factory Player.fromGameState({
    required int day,
    required int money,
    String? userId,
  }) {
    return Player(
      day: day,
      money: money,
      level: calculateLevel(day),
      userId: userId,
    );
  }

  /// Create default new player
  factory Player.newPlayer({String? userId}) {
    return Player(
      day: 1,
      money: 0,
      level: 1,
      userId: userId,
    );
  }

  /// Convert to Map for easier passing through routes
  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'money': money,
      'level': level,
      'userId': userId,
    };
  }

  /// Create Player from Map (useful for navigation arguments)
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      day: map['day'] as int? ?? 1,
      money: map['money'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      userId: map['userId'] as String?,
    );
  }

  @override
  String toString() {
    return 'Player(day: $day, money: \$$money, level: $level, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.day == day &&
        other.money == money &&
        other.level == level &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return day.hashCode ^ money.hashCode ^ level.hashCode ^ userId.hashCode;
  }
}