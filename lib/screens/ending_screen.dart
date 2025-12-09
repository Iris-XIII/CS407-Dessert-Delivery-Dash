import 'package:flutter/material.dart';
import '../services/audio_manager.dart';

class EndingScreen extends StatefulWidget {
  // Placeholder values - will be replaced with actual game data later
  final int dayNumber;
  final double moneyEarned;
  final int customersServed;

  const EndingScreen({
    Key? key,
    this.dayNumber = 1,
    this.moneyEarned = 0.0,
    this.customersServed = 0,
  }) : super(key: key);

  @override
  State<EndingScreen> createState() => _EndingScreenState();
}

class _EndingScreenState extends State<EndingScreen> {
  final AudioManager _audioManager = AudioManager();

  @override
  void initState() {
    super.initState();
    _playMusic();
  }

  Future<void> _playMusic() async {
    await _audioManager.playMusic('Ending Page.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/ReceptionPage.jpg',
              fit: BoxFit.cover,
              alignment: Alignment(0, 0.3),
            ),
          ),

          // Main content
          Center(
            child: Container(
              width: 500,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Color(0xFFFFE3DC).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Day ${widget.dayNumber} is over!',
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Caveat',
                      color: Color(0xFFFF69B4),
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  // Money Earned
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 26,
                        color: Color(0xFF8B6F8F),
                        fontFamily: 'Caveat',
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Money Earned: ',
                        ),
                        TextSpan(
                          text: '\$${widget.moneyEarned.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF87D68D),
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Customers Served
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 26,
                        color: Color(0xFF8B6F8F),
                        fontFamily: 'Caveat',
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Customers Served: ',
                        ),
                        TextSpan(
                          text: '${widget.customersServed}',
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Go to Starting button
                      _buildButton(
                        context,
                        label: 'Home',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/starting');
                        },
                      ),

                      // Profile button
                      _buildButton(
                        context,
                        label: 'Profile',
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),

                      // New Day button
                      _buildButton(
                        context,
                        label: 'New Day',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/starting');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFB6C1),
        foregroundColor: Color(0xFFFFFFFF),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Caveat',
        ),
      ),
    );
  }
}