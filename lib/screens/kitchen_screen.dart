import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_character.dart';
import '../services/audio_manager.dart';
import 'customer_reception_screen.dart';
import '../models/recipe.dart';
import 'miniGames/cake.dart';
import 'miniGames/milk_tea.dart';

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

  const KitchenGameResult({
    required this.day,
    required this.currCustomer,
    required this.money,
    required this.customer,
    required this.cakeTries,
    required this.teaTries,
    this.cakeFrosting,
    this.cakeTopping,
    this.teaBase,
    this.teaTopping,
  });
}

String _buildOrderString(GameCharacter c) {
  final parts = <String>[];

  // Milk tea description
  if (c.milkTeaOrder != null) {
    final m = c.milkTeaOrder!;
    String sweetnessLabel;
    switch (m.sweetness) {
      case 'none':
        sweetnessLabel = '0% sweetness';
        break;
      case 'light':
        sweetnessLabel = '25% sweetness';
        break;
      case 'extra':
        sweetnessLabel = '100% sweetness';
        break;
      case 'regular':
      default:
        sweetnessLabel = '50% sweetness';
        break;
    }

    String baseLabel;
    switch (m.base) {
      case 'green':
        baseLabel = 'Green tea';
        break;
      case 'oolong':
        baseLabel = 'Oolong tea';
        break;
      case 'taro':
        baseLabel = 'Taro milk tea';
        break;
      case 'black':
      default:
        baseLabel = 'Black tea';
        break;
    }

    String toppingLabel;
    switch (m.topping) {
      case 'jelly':
        toppingLabel = 'Jelly';
        break;
      case 'pudding':
        toppingLabel = 'Pudding';
        break;
      case 'none':
        toppingLabel = 'No topping';
        break;
      case 'boba':
      default:
        toppingLabel = 'Boba';
        break;
    }

    parts.add('Milk tea: $baseLabel, $sweetnessLabel, $toppingLabel');
  }

  // Cake description
  if (c.cakeOrder != null) {
    final k = c.cakeOrder!;
    String creamLabel;
    switch (k.cake) {
      case 'pink':
        creamLabel = 'Pink frosting';
        break;
      case 'white':
        creamLabel = 'White frosting';
        break;
      case 'blue':
        creamLabel = 'Blue frosting';
        break;
      case 'brown':
      default:
        creamLabel = 'Chocolate frosting';
        break;
    }

    String toppingLabel;
    switch (k.topping) {
      case 'sprinkles':
        toppingLabel = 'Sprinkles';
        break;
      case 'chocolate':
        toppingLabel = 'Chocolate';
        break;
      case 'cherry':
        toppingLabel = 'Cherry';
        break;
      case 'strawberry':
      default:
        toppingLabel = 'Strawberry';
        break;
    }

    parts.add('Cake: $creamLabel with $toppingLabel');
  }

  if (parts.isEmpty) {
    return 'No order';
  }

  return parts.join('\n');
}

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

  const KitchenScreen({
    super.key,
    required this.day,
    required this.currCustomer,
    required this.money,
    required this.customer,
    required this.cakeTries,
    required this.teaTries,
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
  late int _seconds;
  late Timer _timer;

  String? _cakeFrosting;
  String? _cakeTopping;
  String? _teaBase;
  String? _teaTopping;
  int _cakeTries = 0;
  int _teaTries = 0;

  bool get _hasCakeReady => _cakeFrosting != null && _cakeTopping != null;
  bool get _hasMilkTeaReady => _teaBase != null && _teaTopping != null;

  /// Compare served milk tea (from tray) with what the customer ordered.
  /// We currently match on base + topping. Sweetness is ignored because we
  /// don't store it in the tray right now.
  bool _milkTeaMatches(GameCharacter customer) {
    final expected = customer.milkTeaOrder;
    final hasTea = _hasMilkTeaReady;

    // Customer didn't order milk tea → correct only if we didn't serve it.
    if (expected == null) return !hasTea;
    if (!hasTea) return false;

    return expected.base == _teaBase && expected.topping == _teaTopping;
  }

  /// Compare served cake (from tray) with what the customer ordered.
  bool _cakeMatches(GameCharacter customer) {
    final expected = customer.cakeOrder;
    final hasCake = _hasCakeReady;

    // Customer didn't order cake → correct only if we didn't serve it.
    if (expected == null) return !hasCake;
    if (!hasCake) return false;

    return expected.cake == _cakeFrosting && expected.topping == _cakeTopping;
  }

  /// How much money to give for a correct order.
  int _payoutFor(GameCharacter customer) {
    int coins = 0;
    if (customer.milkTeaOrder != null) coins += 6; // or whatever you want
    if (customer.cakeOrder != null) coins += 8;
    return coins;
  }

  void _onTrayTap() {
    final customer = widget.customer;

    final bool teaCorrect = _milkTeaMatches(customer);
    final bool cakeCorrect = _cakeMatches(customer);
    final bool orderCorrect = teaCorrect && cakeCorrect;

    int earned = 0;
    if (orderCorrect) {
      earned = _payoutFor(customer);
    }

    final result = KitchenGameResult(
      day: widget.day,
      currCustomer: widget.currCustomer,
      money: widget.money + earned,
      customer: customer,
      cakeFrosting: _cakeFrosting,
      cakeTopping: _cakeTopping,
      cakeTries: _cakeTries,
      teaBase: _teaBase,
      teaTopping: _teaTopping,
      teaTries: _teaTries,
    );

    Navigator.pop(context, result);
  }

  @override
  void initState() {
    super.initState();
    _seconds = 720;
    _startTimer();

    _cakeFrosting = widget.cakeFrosting;
    _cakeTopping = widget.cakeTopping;
    _teaBase = widget.teaBase;
    _teaTopping = widget.teaTopping;
    _cakeTries = widget.cakeTries;
    _teaTries = widget.teaTries;

    _playMusic();
  }

  Future<void> _playMusic() async {
    await _audioManager.playMusic('Game Pages.mp3');
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String _formatTime() {
    final minutes = _seconds ~/ 60;
    final seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/KitchenPage.jpeg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day ${widget.day}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                          Text(
                            'Time: ${_formatTime()}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer #${widget.currCustomer}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                          Text(
                            'Money: \$${widget.money}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Caveat',
                              color: Color(0xFF87D68D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: OrderListPanel(
                          order: _buildOrderString(widget.customer),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          _buildIconButton(
                            icon: Icons.person,
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.receipt_long,
                            onPressed: () {
                              Navigator.pushNamed(context, '/recipe');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        left: 40,
                        top: -30,
                        child: GestureDetector(
                          onTap: _onTrayTap,
                          child: SizedBox(
                            width: 250,
                            height: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_cakeFrosting != null &&
                                    _cakeTopping != null)
                                  Image.asset(
                                    'assets/images/cake_${_cakeFrosting}_${_cakeTopping}.png',
                                    width: 85,
                                    height: 85,
                                    fit: BoxFit.contain,
                                  ),
                                const SizedBox(width: 20),
                                if (_teaBase != null && _teaTopping != null)
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
                      Positioned(
                        right: 175,
                        top: 45,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCakeButton(
                              onTap: () async {
                                // TODO: in the future, you can derive this
                                // from widget.customer.cakeOrder instead of
                                // hardcoding.
                                final order = CakeRecipe(
                                  creamColor: 'pink',
                                  topping: 'strawberry',
                                );
                                final result =
                                await Navigator.push<CakeMiniGameResult>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CakeGameScreen(
                                      targetRecipe: order,
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
                              },
                            ),
                            const SizedBox(height: 0),
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
                      Positioned(
                        right: 0,
                        top: 10,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildMilkTeaButton(
                              onTap: () async {
                                // TODO: in the future, derive from customer.milkTeaOrder
                                final order = MilkTeaRecipe(
                                  teaBase: 'taro',
                                  sweetness: 'regular',
                                  topping: 'boba',
                                );
                                final result =
                                await Navigator.push<MilkTeaMiniGameResult>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MilkTeaGameScreen(
                                      targetRecipe: order,
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
                              },
                            ),
                            const SizedBox(height: 0),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCakeButton({required VoidCallback onTap}) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 100,
      height: 100,
      child: Center(
        child: Image.asset(
          'assets/images/cake.png',
          width: 95,
          height: 95,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );

  Widget _buildMilkTeaButton({required VoidCallback onTap}) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 200,
      height: 200,
      child: Center(
        child: Image.asset(
          'assets/images/milk_tea.png',
          width: 190,
          height: 290,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFB6C1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
}

// OrderListPanel widget
class OrderListPanel extends StatelessWidget {
  final String order;
  const OrderListPanel({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    const edgePad = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    return Container(
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
      padding: edgePad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
