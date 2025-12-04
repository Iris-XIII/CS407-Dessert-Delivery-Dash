import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_character.dart';

import 'customer_reception_screen.dart';
import '../models/recipe.dart';
import 'miniGames/cake.dart';
import 'miniGames/milk_tea.dart';
import 'customer_reception_screen.dart';

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
  // final bool correctOrder;
  // final int deltaMoney;

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
    // required this.correctOrder,
    // required this.deltaMoney,
  });
}

String _buildOrderString(GameCharacter c) {
  final parts = <String>[];

  if (c.milkTeaOrder != null && c.milkTeaOrder!.isNotEmpty) {
    parts.add('Milk Tea: ${c.milkTeaOrder}');
  }
  if (c.cakeOrder != null && c.cakeOrder!.isNotEmpty) {
    parts.add('Cake: ${c.cakeOrder}');
  }

  if (parts.isEmpty) {
    return 'No order';
  }

  // Each part on its own line
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
    this.teaTopping
  });

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  late int _seconds;
  late Timer _timer;
  String? _cakeFrosting;
  String? _cakeTopping;
  String? _teaBase;
  String? _teaTopping;
  int _cakeTries = 0;
  int _teaTries = 0;

  bool get _hasCakeReady =>
      widget.cakeFrosting != null && widget.cakeTopping != null;

  bool get _hasMilkTeaReady =>
      widget.teaBase != null && widget.teaTopping != null;

  void _onTrayTap() {
    // Example: simple correctness + price logic
    final customer = widget.customer;

    final bool wantsCake =
        customer.cakeOrder != null && customer.cakeOrder!.isNotEmpty;
    final bool wantsTea =
        customer.milkTeaOrder != null && customer.milkTeaOrder!.isNotEmpty;

    final bool hasCake =
        widget.cakeFrosting != null && widget.cakeTopping != null;
    final bool hasTea =
        widget.teaBase != null && widget.teaTopping != null;

    // Basic correctness rule: they get exactly what they ordered
    final bool correctOrder = (wantsCake == hasCake) && (wantsTea == hasTea);

    const int cakePrice = 8;
    const int teaPrice = 6;

    int earned = 0;
    if (correctOrder) {
      if (wantsCake) earned += cakePrice;
      if (wantsTea) earned += teaPrice;
    }

    final result = KitchenGameResult(
      day: widget.day,
      currCustomer: widget.currCustomer,
      money: widget.money + earned,   // NEW TOTAL
      customer: widget.customer,
      cakeFrosting: widget.cakeFrosting,
      cakeTopping: widget.cakeTopping,
      cakeTries: widget.cakeTries,
      teaBase: widget.teaBase,
      teaTopping: widget.teaTopping,
      teaTries: widget.teaTries,
    );

    // however you're currently navigating back – e.g.:
    Navigator.pop(context, result);
  }

  @override
  void initState() {
    super.initState();
    _seconds = 720; // 12:00 minutes in seconds
    _startTimer();

    _cakeFrosting = widget.cakeFrosting;
    _cakeTopping = widget.cakeTopping;
    _teaBase = widget.teaBase;
    _teaTopping = widget.teaTopping;
    _cakeTries = widget.cakeTries;
    _teaTries = widget.teaTries;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
          // TODO: navigate to ending screen
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

  // ---- UI ----

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
                // Top bar
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
                      // Left side - Day and Timer
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
                      SizedBox(width: 20),
                      // Middle - current customer + money
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
                      SizedBox(width: 20),
                      Expanded(
                        child: OrderListPanel(order: _buildOrderString(widget.customer)),
                      ),
                      SizedBox(width: 20),
                      // Right side - nav buttons
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
                          // const SizedBox(width: 8),
                          // _buildIconButton(
                          //   icon: Icons.home,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, '/starting');
                          //   },
                          // ),
                          // const SizedBox(width: 8),
                          // _buildIconButton(
                          //   icon: Icons.people,
                          //   onPressed: () {
                          //     Navigator.pushNamed(
                          //         context, '/customer-reception');
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Kitchen workspace area
                Expanded(
                  child: Stack(
                    children: [
                      //  Cake
                      Positioned(
                        left: 40,
                        top: -30,
                        child: GestureDetector(
                            onTap: _onTrayTap,
                            child: SizedBox(
                              width: 250, // tweak to match your tray art
                              height: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_cakeFrosting != null && _cakeTopping != null)
                                    Image.asset(
                                      'assets/images/cake_${_cakeFrosting}_${_cakeTopping}.png',
                                      width: 85,
                                      height: 85,
                                      fit: BoxFit.contain,
                                    ),
                                  SizedBox(width: 20),
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
                        )
                      ),
                      // Cake
                      Positioned(
                        right: 175,
                        top: 45,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCakeButton(
                              onTap: () async {
                                final order = CakeRecipe(
                                  creamColor: 'pink',
                                  topping: 'strawberry',
                                );
                                final result = await Navigator.push<CakeMiniGameResult>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CakeGameScreen(
                                      targetRecipe: order,
                                     day: widget.day,
                                      currCustomer: widget.currCustomer,
                                      customer: widget.customer,
                                      money: widget.money,
                                      cakeFrosting: widget.cakeFrosting,
                                      cakeTopping: widget.cakeTopping,
                                      teaBase: widget.teaBase,
                                      teaTopping: widget.teaTopping,
                                      teaTries: widget.teaTries,
                                      cakeTries: widget.cakeTries,
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

                      // Milk tea
                      Positioned(
                        right: 0,
                        top: 10,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildMilkTeaButton(
                              onTap: () async {
                                final order = MilkTeaRecipe(
                                  teaBase: 'taro',
                                  sweetness: 'regular',
                                  topping: 'boba',
                                );
                                final result = await Navigator.push<MilkTeaMiniGameResult>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MilkTeaGameScreen(
                                          targetRecipe: order,
                                          day: widget.day,
                                          currCustomer: widget.currCustomer,
                                          customer: widget.customer,
                                          money: widget.money,
                                          cakeFrosting: widget.cakeFrosting,
                                          cakeTopping: widget.cakeTopping,
                                          teaBase: widget.teaBase,
                                          teaTopping: widget.teaTopping,
                                          teaTries: widget.teaTries,
                                          cakeTries: widget.cakeTries,),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    _teaBase = result.teaBase;
                                    _teaTopping = result.topping;
                                    _teaTries = result.teaTries;
                                    // you can store result.sweetness too if you want
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

  // helpers

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
