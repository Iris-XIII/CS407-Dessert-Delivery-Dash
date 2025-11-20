import 'package:flutter/material.dart';

class CustomerReceptionScreen extends StatefulWidget {
  final String characterAsset;
  final int initialDay;
  final int initialMoney;
  final int initialCustomers;
  final String initialTime;
  final List<List<String>> initialOrders;

  const CustomerReceptionScreen({
    super.key,
    required this.characterAsset,
    required this.initialDay,
    required this.initialMoney,
    required this.initialCustomers,
    required this.initialTime,
    required this.initialOrders,
  });

  @override
  State<CustomerReceptionScreen> createState() => _CustomerReceptionScreenState();
}

class _CustomerReceptionScreenState extends State<CustomerReceptionScreen> {
  late String characterAsset;
  late int day;
  late int money;
  late int customers;
  late String time;
  late List<List<String>> orders;

  @override
  void initState() {
    super.initState();
    characterAsset = widget.characterAsset;
    day = widget.initialDay;
    money = widget.initialMoney;
    time = widget.initialTime;
    customers = widget.initialCustomers;
    // make a copy so we can mutate safely
    orders = widget.initialOrders
        .map((row) => List<String>.from(row))
        .toList();
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
                'assets/images/$characterAsset',
                height: h * .55,
              ),
            ),
          ),
          // 2️⃣ Counter foreground overlay (ABOVE characters, BELOW UI)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              // IgnorePointer so it doesn't block taps on your GestureDetector
              child: Image.asset(
                'assets/images/Counter.png',
                fit: BoxFit.fitWidth,
                //width: w,
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {

                const edgePad = EdgeInsets.symmetric(horizontal: 0, vertical: 12);

                return Stack(children: [

                  Positioned(
                    left: w * 0.03,
                    top:  h * 0.80,
                    width:  w * 0.35,
                    height: h * 0.30,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pushNamed(context, '/recipe'),
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
                          Text('Day $day',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text('Time: $time',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black87)),
                          const SizedBox(height: 12),
                          OrderListPanel()
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
                              Text('Customers: $customers',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(width: 16),
                              Text('Money: $money',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600)),
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
                                      onQuit: () => Navigator.pushNamed(context, '/starting'),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              PinkIconButton(
                                icon: Icons.person,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/profile');
                                },
                              ),
                              SizedBox(width: 8),
                              PinkIconButton(
                                icon: Icons.kitchen_sharp,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/kitchen');
                                },
                              ),
                              SizedBox(width: 8),
                              PinkIconButton(
                                icon: Icons.crop_square_sharp,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/ending');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]);
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
  const OrderListPanel({super.key});

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
            'Order List',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const _OrderRow(items: ['🍞', '🧁']),
          const _OrderRow(items: ['🍞', '🍞', '🍪']),
          const _OrderRow(items: ['🧁']),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final List<String> items;
  const _OrderRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          ...items.map((e) => Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Text(e, style: const TextStyle(fontSize: 20)),
          )),
          const Spacer(),
          const Icon(Icons.more_horiz, size: 18),
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
      backgroundColor: Colors.transparent, // so our custom card shows
      insetPadding: const EdgeInsets.symmetric(horizontal: 200, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: pink.withOpacity(.35),              // ✅ same soft pink
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18), // ✅ soft shadow
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

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Secondary (outlined-ish) button
                _GhostPinkButton(
                  label: 'Home',
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog first
                    onQuit?.call();
                  },
                ),

                // Primary pink button
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
      color: pink, // solid pink like your icon button fill
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
        color: Colors.white.withOpacity(0.85),      // light, to contrast primary
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
