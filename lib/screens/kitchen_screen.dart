import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'miniGames/cake.dart'; // Assuming this imports CakeGameScreen
import 'miniGames/milk_tea.dart';  // import milk tea game screen
import 'dart:async';


class KitchenScreen extends StatefulWidget {
  final int dayNumber;
  final int level;
  final double money;

  const KitchenScreen({
    Key? key,
    this.dayNumber = 1,
    this.level = 1,
    this.money = 0.0,
  }) : super(key: key);

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  late int _seconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _seconds = 720; // 12 minutes = 720 seconds (12:00)
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
          // TODO: Navigate to ending screen when timer ends
        }
      });
    });
  }

  String _formatTime() {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Helper widget for the clickable cake image/button (now uses cake.png)
  Widget _buildCakeButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Retaining dimensions for tap target size
        width: 100,
        height: 100,
        child: Center(
          // Replaced Icon with the Image.asset using the new asset path
          child: Image.asset(
            'assets/images/cake.png',
            width: 95, // Image size slightly smaller than container for padding
            height: 95,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }


  // Helper widget for the clickable milk tea image/button
  Widget _buildMilkTeaButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top bar with info
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2),
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
                            'Day ${widget.dayNumber}',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                          Text(
                            'Time: ${_formatTime()}',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                        ],
                      ),

                      // Middle - Level and Money
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level: ${widget.level}',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Caveat',
                              color: Color(0xFF8B6F8F),
                            ),
                          ),
                          Text(
                            'Money: \$${widget.money.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Caveat',
                              color: Color(0xFF87D68D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Right side - Navigation buttons
                      Row(
                        children: [
                          _buildIconButton(
                            icon: Icons.person,
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                          ),
                          SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.receipt_long,
                            onPressed: () {
                              Navigator.pushNamed(context, '/recipe');
                            },
                          ),
                          SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.home,
                            onPressed: () {
                              Navigator.pushNamed(context, '/starting');
                            },
                          ),
                          SizedBox(width: 8),
                          _buildIconButton(
                            icon: Icons.people,
                            onPressed: () {
                              Navigator.pushNamed(context, '/customer-reception');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Kitchen workspace area - Both Dessert Buttons
                Expanded(
                  child: Stack(
                    children: [
                      // CAKE BUTTON - Left side
                      Positioned(
                        left: 195,
                        top: 45,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCakeButton(
                              onTap: () async {
                                // TODO: Get actual order from customer
                                final order = CakeRecipe(
                                  creamColor: 'pink',
                                  topping: 'strawberry',
                                );

                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CakeGameScreen(targetRecipe: order),
                                  ),
                                );

                                if (result != null) {
                                  if (result == true) {
                                    // TODO maybe customer will react differently based on order
                                    print('Correct cake! Customer happy!');
                                  } else {
                                    // TODO maybe customer will react differently based on order
                                    print('Wrong cake order!');
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 0),
                            Text(
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

                      // MILK TEA BUTTON - Right side (larger and more to the right)
                      Positioned(
                        right: 40,
                        top: 10,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildMilkTeaButton(
                              onTap: () async {
                                // TODO: Get actual order from customer
                                final order = MilkTeaRecipe(
                                  teaBase: 'taro',
                                  sweetness: 'regular',
                                  topping: 'boba',
                                );

                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MilkTeaGameScreen(targetRecipe: order),
                                  ),
                                );

                                if (result != null) {
                                  if (result == true) {
                                    // TODO maybe customer will react differently based on order
                                    print('Correct milk tea! Customer happy!');
                                  } else {
                                    // TODO maybe customer will react differently based on order
                                    print('Wrong milk tea order!');
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 0),
                            Text(
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

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFB6C1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 24,
        onPressed: onPressed,
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(),
      ),
    );
  }
}