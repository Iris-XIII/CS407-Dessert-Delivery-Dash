import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_character.dart';
import '../models/player.dart';
import '../services/audio_manager.dart';
import '../models/recipe.dart';
import 'miniGames/cake.dart';
import 'miniGames/milk_tea.dart';

// ============================================================================
// KITCHEN GAME RESULT - What we return to reception screen
// ============================================================================
class KitchenGameResult {
  final int day;
  final int currCustomer;
  final int money;
  final GameCharacter customer;
  final String? cakeFrosting;
  final String? cakeTopping;
  final int cakeTries;
  final String? teaBase;
  final String? teaTopping;
  final int teaTries;
  final int timeElapsed;

  const KitchenGameResult({
    required this.day,
    required this.currCustomer,
    required this.money,
    required this.customer,
    required this.cakeTries,
    required this.teaTries,
    required this.timeElapsed,
    this.cakeFrosting,
    this.cakeTopping,
    this.teaBase,
    this.teaTopping,
  });
}

// ============================================================================
// HELPER FUNCTION - Build order string
// ============================================================================
String _buildOrderString(GameCharacter c) {
  final parts = <String>[];

  // Milk tea order
  if (c.milkTeaOrder != null) {
    final m = c.milkTeaOrder!;

    final sweetnessMap = {
      'none': '0% sweetness',
      'light': '25% sweetness',
      'regular': '50% sweetness',
      'extra': '100% sweetness',
    };

    final baseMap = {
      'black': 'Black tea',
      'green': 'Green tea',
      'oolong': 'Oolong tea',
      'taro': 'Taro milk tea',
    };

    final toppingMap = {
      'boba': 'Boba',
      'jelly': 'Jelly',
      'pudding': 'Pudding',
      'none': 'No topping',
    };

    parts.add('Milk tea: ${baseMap[m.base] ?? m.base}, '
        '${sweetnessMap[m.sweetness] ?? m.sweetness}, '
        '${toppingMap[m.topping] ?? m.topping}');
  }

  // Cake order
  if (c.cakeOrder != null) {
    final k = c.cakeOrder!;

    final creamMap = {
      'brown': 'Chocolate frosting',
      'pink': 'Pink frosting',
      'white': 'White frosting',
      'blue': 'Blue frosting',
    };

    final toppingMap = {
      'strawberry': 'Strawberry',
      'sprinkles': 'Sprinkles',
      'chocolate': 'Chocolate',
      'cherry': 'Cherry',
    };

    parts.add('Cake: ${creamMap[k.cake] ?? k.cake} with '
        '${toppingMap[k.topping] ?? k.topping}');
  }

  return parts.isEmpty ? 'No order' : parts.join('\n');
}

// ============================================================================
// KITCHEN SCREEN - Main widget
// ============================================================================
class KitchenScreen extends StatefulWidget {
  final int day;
  final int currCustomer;
  final int money;
  final GameCharacter customer;
  final String? cakeFrosting;
  final String? cakeTopping;
  final int cakeTries;
  final String? teaBase;
  final String? teaTopping;
  final int teaTries;
  final int initialTimeElapsed;
  final int totalCustomers;
  final int customersServed;

  const KitchenScreen({
    super.key,
    required this.day,
    required this.currCustomer,
    required this.money,
    required this.customer,
    required this.cakeTries,
    required this.teaTries,
    required this.initialTimeElapsed,
    required this.totalCustomers,
    required this.customersServed,
    this.cakeFrosting,
    this.cakeTopping,
    this.teaBase,
    this.teaTopping,
  });

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  final AudioManager _audioManager = AudioManager();

  // Timer
  late Timer _timer;
  int _secondsInKitchen = 0;

  // Current order state
  String? _cakeFrosting;
  String? _cakeTopping;
  String? _teaBase;
  String? _teaTopping;
  int _cakeTries = 0;
  int _teaTries = 0;

  // ============================================================================
  // LIFECYCLE
  // ============================================================================
  @override
  void initState() {
    super.initState();

    // Load existing state
    _cakeFrosting = widget.cakeFrosting;
    _cakeTopping = widget.cakeTopping;
    _teaBase = widget.teaBase;
    _teaTopping = widget.teaTopping;
    _cakeTries = widget.cakeTries;
    _teaTries = widget.teaTries;

    // Start timer and music
    _startTimer();
    _playMusic();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ============================================================================
  // TIMER
  // ============================================================================
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsInKitchen++);
    });
  }

  String _formatTime() {
    final totalSeconds = widget.initialTimeElapsed + _secondsInKitchen;
    final hours = (totalSeconds ~/ 3600) % 24;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final displayHour = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
    final ampm = hours >= 12 ? 'PM' : 'AM';
    return '${displayHour.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')} $ampm';
  }

  int _calculateTimeForCustomer() {
    // Work day: 9 AM to 5 PM = 8 hours = 28800 seconds
    const workDaySeconds = 8 * 3600;
    final secondsPerCustomer = workDaySeconds ~/ widget.totalCustomers;
    return secondsPerCustomer;
  }

  // ============================================================================
  // AUDIO
  // ============================================================================
  Future<void> _playMusic() async {
    await _audioManager.playMusic('game_pages.mp3');
  }

  // ============================================================================
  // ORDER CHECKING
  // ============================================================================
  bool get _hasCakeReady => _cakeFrosting != null && _cakeTopping != null;
  bool get _hasMilkTeaReady => _teaBase != null && _teaTopping != null;

  bool _milkTeaMatches() {
    final expected = widget.customer.milkTeaOrder;
    if (expected == null) return !_hasMilkTeaReady;
    if (!_hasMilkTeaReady) return false;
    return expected.base == _teaBase && expected.topping == _teaTopping;
  }

  bool _cakeMatches() {
    final expected = widget.customer.cakeOrder;
    if (expected == null) return !_hasCakeReady;
    if (!_hasCakeReady) return false;
    return expected.cake == _cakeFrosting && expected.topping == _cakeTopping;
  }

  int _calculatePayout() {
    int coins = 0;
    if (widget.customer.milkTeaOrder != null) coins += 6;
    if (widget.customer.cakeOrder != null) coins += 8;
    return coins;
  }

  // ============================================================================
  // SUBMIT ORDER
  // ============================================================================
  void _submitOrder() {
    final bool teaCorrect = _milkTeaMatches();
    final bool cakeCorrect = _cakeMatches();
    final bool orderCorrect = teaCorrect && cakeCorrect;

    int earned = orderCorrect ? _calculatePayout() : 0;

    // Calculate total time
    final timeForCustomer = _calculateTimeForCustomer();
    final totalTimeElapsed = widget.initialTimeElapsed + timeForCustomer + _secondsInKitchen;

    final result = KitchenGameResult(
      day: widget.day,
      currCustomer: widget.currCustomer,
      money: widget.money + earned,
      customer: widget.customer,
      cakeFrosting: _cakeFrosting,
      cakeTopping: _cakeTopping,
      cakeTries: _cakeTries,
      teaBase: _teaBase,
      teaTopping: _teaTopping,
      teaTries: _teaTries,
      timeElapsed: totalTimeElapsed,
    );

    Navigator.pop(context, result);
  }

  // ============================================================================
  // MINI-GAMES
  // ============================================================================
  Future<void> _openCakeGame() async {
    // Get the actual cake order from the customer
    final cakeOrder = widget.customer.cakeOrder;

    // If no cake order, just return (customer didn't order cake)
    if (cakeOrder == null) {
      // Show a message that customer didn't order cake
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This customer didn\'t order a cake!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push<CakeMiniGameResult>(
      context,
      MaterialPageRoute(
        builder: (context) => CakeGameScreen(
          targetRecipe: CakeRecipe(
            creamColor: cakeOrder.cake,
            topping: cakeOrder.topping,
          ),
          day: widget.day,
          currCustomer: widget.currCustomer,
          customer: widget.customer,
          money: widget.money,
          cakeFrosting: _cakeFrosting,
          cakeTopping: _cakeTopping,
          teaBase: _teaBase,
          teaTopping: _teaTopping,
          teaTries: _teaTries,
          cakeTries: _cakeTries,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _cakeFrosting = result.creamColor;
        _cakeTopping = result.topping;
        _cakeTries = result.cakeTries;
      });
    }
  }

  Future<void> _openMilkTeaGame() async {
    // Get the actual milk tea order from the customer
    final milkTeaOrder = widget.customer.milkTeaOrder;

    // If no milk tea order, just return (customer didn't order milk tea)
    if (milkTeaOrder == null) {
      // Show a message that customer didn't order milk tea
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This customer didn\'t order milk tea!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push<MilkTeaMiniGameResult>(
      context,
      MaterialPageRoute(
        builder: (context) => MilkTeaGameScreen(
          targetRecipe: MilkTeaRecipe(
            teaBase: milkTeaOrder.base,
            sweetness: milkTeaOrder.sweetness,
            topping: milkTeaOrder.topping,
          ),
          day: widget.day,
          currCustomer: widget.currCustomer,
          customer: widget.customer,
          money: widget.money,
          cakeFrosting: _cakeFrosting,
          cakeTopping: _cakeTopping,
          teaBase: _teaBase,
          teaTopping: _teaTopping,
          teaTries: _teaTries,
          cakeTries: _cakeTries,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _teaBase = result.teaBase;
        _teaTopping = result.topping;
        _teaTries = result.teaTries;
      });
    }
  }

  // ============================================================================
  // BUILD UI
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/KitchenPage.jpeg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildKitchenArea()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // TOP BAR
  // ============================================================================
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day & Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Day ${widget.day}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Caveat',
                  color: Color(0xFF8B6F8F),
                ),
              ),
              Text(
                'Time: ${_formatTime()}',
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Caveat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B6F8F),
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Customer & Money
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer #${widget.currCustomer + 1}',
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Caveat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B6F8F),
                ),
              ),
              Text(
                'Money: \$${widget.money}',
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Caveat',
                  color: Color(0xFF87D68D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Order panel
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB6C1).withOpacity(.75),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _buildOrderString(widget.customer),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Caveat',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          Row(
            children: [
              _buildIconButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 8),
              _buildIconButton(
                icon: Icons.receipt_long,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/recipe',
                    arguments: Player.fromGameState(
                      day: widget.day,
                      money: widget.money,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFB6C1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 24,
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }

  // ============================================================================
  // KITCHEN AREA
  // ============================================================================
  Widget _buildKitchenArea() {
    return Stack(
      children: [
        // Serving tray (tap to submit)
        Positioned(
          left: 40,
          top: -30,
          child: GestureDetector(
            onTap: _submitOrder,
            child: SizedBox(
              width: 250,
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show cake if ready
                  if (_hasCakeReady)
                    Image.asset(
                      'assets/images/cake_${_cakeFrosting}_${_cakeTopping}.png',
                      width: 85,
                      height: 85,
                      fit: BoxFit.contain,
                    ),
                  const SizedBox(width: 20),
                  // Show milk tea if ready
                  if (_hasMilkTeaReady)
                    Image.asset(
                      'assets/images/milk_tea_${_teaBase}_${_teaTopping}.png',
                      width: 75,
                      height: 75,
                      fit: BoxFit.contain,
                    ),
                ],
              ),
            ),
          ),
        ),

        // Cake station
        Positioned(
          right: 175,
          top: 45,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _openCakeGame,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'assets/images/cake.png',
                    width: 95,
                    height: 95,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                'Cake',
                style: TextStyle(
                  fontFamily: 'Caveat',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B6F8F),
                ),
              ),
            ],
          ),
        ),

        // Milk tea station
        Positioned(
          right: 0,
          top: 10,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _openMilkTeaGame,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    'assets/images/milk_tea.png',
                    width: 190,
                    height: 290,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                'Milk Tea',
                style: TextStyle(
                  fontFamily: 'Caveat',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B6F8F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}