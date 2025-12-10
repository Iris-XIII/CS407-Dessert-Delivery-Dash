import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/audio_manager.dart';
import '../models/player.dart';
import 'kitchen_screen.dart';
import '../data/characters.dart';
import '../data/days.dart';
import '../models/game_character.dart';
import '../models/day_plan.dart';
import 'ending_screen.dart';
import '../services/progress_repository.dart';

String _buildOrderString(GameCharacter c) {
  final parts = <String>[];

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

  if (parts.isEmpty) return 'No order';
  return parts.join('\n');
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
    this.deltaMoney,
  });

  @override
  State<CustomerReceptionScreen> createState() =>
      _CustomerReceptionScreenState();
}

class _CustomerReceptionScreenState extends State<CustomerReceptionScreen> {
  final AudioManager _audioManager = AudioManager();

  late int currCustomer;
  late int day;
  late int money;
  late int totalCustomers;
  late int customersServed;
  late int startingMoney;

  // Timer
  late int _totalSecondsElapsed;
  late Timer _timer;

  late List<GameCharacter> todaysCustomers;

  @override
  void initState() {
    super.initState();

    day = widget.initialDay;
    startingMoney = widget.initialMoney;
    money = widget.initialMoney;

    // Start at 9:00 AM
    _totalSecondsElapsed = 9 * 3600;

    final int dayIndex = (day - 1).clamp(0, kDays.length - 1) as int;
    final day_plan dayData = kDays[dayIndex];

    todaysCustomers =
        dayData.characterIds.map((id) => kCharacters[id]!).toList();

    totalCustomers = todaysCustomers.length;
    customersServed = 0;
    currCustomer = 0;

    _playMusic();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _totalSecondsElapsed++;
      });
    });
  }

  String _formatTime() {
    final hours = (_totalSecondsElapsed ~/ 3600) % 24;
    final minutes = (_totalSecondsElapsed % 3600) ~/ 60;

    final displayHour = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
    final ampm = hours >= 12 ? 'PM' : 'AM';

    return '${displayHour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $ampm';
  }

  Future<void> _playMusic() async {
    await _audioManager.playMusic('game_pages.mp3');
  }

  void _goToEnding() {
    _timer.cancel();

    debugPrint('>>> _goToEnding called: day=$day, '
        'start=$startingMoney, money=$money, '
        'customersServed=$customersServed');

    final int moneyEarnedToday = money - startingMoney;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      ProgressRepository()
          .saveProgress(
        uid: user.uid,
        day: day + 1,
        money: money,
      )
          .catchError((e, st) {
        debugPrint('saveProgress failed: $e\n$st');
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EndingScreen(
          dayNumber: day,
          moneyEarned: moneyEarnedToday.toDouble(),
          customersServed: customersServed,
        ),
      ),
    );
  }

  Player _createPlayer() {
    return Player.fromGameState(
      day: day,
      money: money,
      userId: FirebaseAuth.instance.currentUser?.uid,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            bottom: h * .05,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/${todaysCustomers[currCustomer].sprite}',
                height: h * .55,
              ),
            ),
          ),
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
                return Stack(
                  children: [
                    // Recipe book tap area
                    Positioned(
                      left: w * 0.03,
                      top: h * 0.80,
                      width: w * 0.35,
                      height: h * 0.30,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/recipe',
                            arguments: _createPlayer(),
                          );
                        },
                        child: const SizedBox.expand(),
                      ),
                    ),

                    // LONG WHITE BAR - Like kitchen screen
                    Positioned(
                      left: 10,
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
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
                                  'Day $day',
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

                            // Customers & Money
                            Row(
                              children: [
                                Text(
                                  'Customers: $customersServed',
                                  // made customer count consistent
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Caveat',
                                    color: Color(0xFF8B6F8F),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  'Money: \$$money',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Caveat',
                                    color: Color(0xFF87D68D),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 20),

                            // Buttons
                            Row(
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
                                    Navigator.pushNamed(
                                      context,
                                      '/profile',
                                      arguments: _createPlayer(),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                PinkIconButton(
                                  icon: Icons.kitchen_sharp,
                                  onPressed: () async {
                                    _timer.cancel();

                                    final result = await Navigator.push<KitchenGameResult>(
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
                                          initialTimeElapsed: _totalSecondsElapsed,
                                          totalCustomers: totalCustomers,
                                          customersServed: customersServed,
                                        ),
                                      ),
                                    );

                                    if (mounted) {
                                      _startTimer();
                                    }

                                    if (result == null) return;

                                    _totalSecondsElapsed = result.timeElapsed;

                                    final int newMoney = result.money;
                                    final int newCustomersServed = customersServed + 1;
                                    final bool finishedAll = newCustomersServed >= totalCustomers;

                                    debugPrint('served one: newCustomersServed=$newCustomersServed / '
                                        '$totalCustomers, finishedAll=$finishedAll');

                                    setState(() {
                                      money = newMoney;
                                      customersServed = newCustomersServed;

                                      if (!finishedAll) {
                                        currCustomer =
                                            (currCustomer + 1).clamp(0, totalCustomers - 1);
                                      }
                                    });

                                    if (finishedAll && mounted) {
                                      _goToEnding();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ORDER BOX - Separate pink box (not inside white bar)
                    Positioned(
                      left: 10,
                      top: 150,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB6C1).withOpacity(.75),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        constraints: BoxConstraints(
                          maxWidth: w * 0.25,
                        ),
                        child: Text(
                          _buildOrderString(todaysCustomers[currCustomer]),
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Caveat',
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
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
        color: const Color(0xFFFFB6C1).withOpacity(.9),
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
        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 200, vertical: 24),
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
                fontFamily: 'Caveat',
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Be right back… kneading a break.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'Caveat',
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Caveat',
              fontSize: 22,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Caveat',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}