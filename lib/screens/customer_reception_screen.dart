import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/audio_manager.dart';
import 'kitchen_screen.dart';
import '../data/characters.dart';   // contains kCharacters
import '../data/days.dart';         // contains kDays
import '../models/game_character.dart';
import '../models/day_plan.dart';   // or day_data.dart, as long as it defines DayData

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

class KitchenScreenArgs {
  final int day;
  final int customer;
  final int money;

  KitchenScreenArgs({
    required this.day,
    required this.customer,
    required this.money
  });
}

class CustomerReceptionScreen extends StatefulWidget {
  final int initialDay;
  final int initialMoney;
  final int initialCustomers;
  final String initialTime;
  final int? currCustomer;
  final bool? correctOrder;
  final int? deltaMoney;

  const CustomerReceptionScreen({
    super.key,
    required this.initialDay,
    required this.initialMoney,
    required this.initialCustomers,
    required this.initialTime,
    this.currCustomer,
    this.correctOrder,
    this.deltaMoney
  });

  @override
  State<CustomerReceptionScreen> createState() =>
      _CustomerReceptionScreenState();
}

class _CustomerReceptionScreenState extends State<CustomerReceptionScreen> {
  final AudioManager _audioManager = AudioManager();

  // Core state driven by your day + character data
  late int currCustomer;
  late int day;
  late int money;
  late int customers;
  late String time;

  // legacy orders list (not really used now, but kept so the class still has it)
  late List<List<String>> orders;

  late List<GameCharacter> todaysCustomers;
  late List<String> orderStrings; // one string per customer

  @override
  void initState() {
    super.initState();
    currCustomer = 0;
    day = widget.initialDay;
    money = widget.initialMoney;
    time = widget.initialTime;

    final int dayIndex = (day - 1).clamp(0, kDays.length - 1) as int;
    final day_plan dayData = kDays[dayIndex];

    todaysCustomers = dayData.characterIds
        .map((id) => kCharacters[id]!)
        .toList();

    customers = todaysCustomers.length;

    _playMusic();
  }

  Future<void> _playMusic() async {
    await _audioManager.playMusic('Game Pages.mp3');
  }

  @override
  Widget build(BuildContext context) {
    const beige = Color(0xFFE6D3B8);
    const panel = Color(0xFFFFF3D6);
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    Future<void> showPauseDialog(
        BuildContext context, {
          VoidCallback? onQuit,
        }) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PauseDialog(onQuit: onQuit),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/ReceptionPage.jpg',
            fit: BoxFit.cover,
          ),
          Positioned(
            left: -70,
            right: 0,
            bottom: h * .05, // tweak until they sit right at the counter
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/${todaysCustomers[currCustomer].sprite}',
                height: h * .55,
              ),
            ),
          ),
          // Counter foreground overlay (ABOVE characters, BELOW UI)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/Counter.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                const edgePad =
                EdgeInsets.symmetric(horizontal: 0, vertical: 12);

                return Stack(
                  children: [
                    Positioned(
                      left: w * 0.03,
                      top: h * 0.80,
                      width: w * 0.35,
                      height: h * 0.30,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            Navigator.pushNamed(context, '/recipe'),
                        child: const SizedBox.expand(),
                      ),
                    ),

                    Positioned(
                      left: 0,
                      top: 12,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: w * 0.2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Day + Time
                            Text(
                              'Day $day',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Time: $time',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            OrderListPanel(order: _buildOrderString(todaysCustomers[currCustomer])),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      right: 6,
                      top: 12,
                      child: SizedBox(
                        width: w * 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Customers: ${customers-currCustomer}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Money: $money',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PinkIconButton(
                                  icon: Icons.pause,
                                  onPressed: () {
                                    showPauseDialog(
                                      context,
                                      onQuit: () => Navigator.pushNamed(
                                          context, '/starting'),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                PinkIconButton(
                                  icon: Icons.person,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/profile');
                                  },
                                ),
                                const SizedBox(width: 8),
                                PinkIconButton(
                                  icon: Icons.kitchen_sharp,
                                  onPressed: () async {
                                    final result =
                                    await Navigator.push<KitchenGameResult>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => KitchenScreen(
                                          day: day,
                                          currCustomer: currCustomer,
                                          customer: todaysCustomers[currCustomer],
                                          money: money,
                                          cakeFrosting: null,
                                          cakeTopping: null,
                                          cakeTries: 0,
                                          teaBase: null,
                                          teaTopping: null,
                                          teaTries: 0,
                                        ),
                                      ),
                                    );

                                    // result comes from _onTrayTap in KitchenScreen
                                    if (result != null) {
                                      setState(() {
                                        // money that KitchenScreen computed (base + price for order)
                                        money = result.money;

                                        // Move to next customer (you can later gate this on "correctness")
                                        if (currCustomer < customers - 1) {
                                          currCustomer++;
                                        } else {
                                          // last customer of the day – you can go to ending or next day here
                                          // Navigator.pushNamed(context, '/ending');
                                        }
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                PinkIconButton(
                                  icon: Icons.crop_square_sharp,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/ending');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PinkIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const PinkIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFB6C1).withOpacity(.75),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
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
        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}

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

class PauseDialog extends StatelessWidget {
  final VoidCallback? onQuit;
  const PauseDialog({super.key, this.onQuit});

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFFB6C1);
    const edgePad = EdgeInsets.symmetric(horizontal: 20, vertical: 18);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 200, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: pink.withOpacity(.35),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: edgePad,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Paused',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Be right back… kneading a break.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _GhostPinkButton(
                  label: 'Home',
                  onPressed: () {
                    Navigator.of(context).pop();
                    onQuit?.call();
                  },
                ),
                _PinkFilledButton(
                  label: 'Resume',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PinkFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PinkFilledButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFFB6C1);
    return Material(
      color: pink,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostPinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _GhostPinkButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFFB6C1);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pink.withOpacity(0.9), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}