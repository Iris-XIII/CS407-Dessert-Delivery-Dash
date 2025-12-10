import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/audio_manager.dart';
import '../services/progress_repository.dart';
import '../models/player.dart';

class EndingScreen extends StatefulWidget {
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

  int _currentMoney = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _playMusic();
    _loadCurrentProgress();
  }

  Future<void> _loadCurrentProgress() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final progress = await ProgressRepository().loadProgress(user.uid);
        setState(() {
          _currentMoney = progress.money;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint('Error loading progress: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _playMusic() async {
    await _audioManager.playMusic('ending_page.mp3');
  }

  Player _createPlayer() {
    return Player.fromGameState(
      day: widget.dayNumber + 1,
      money: _currentMoney,
      userId: FirebaseAuth.instance.currentUser?.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.pinkAccent),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/ReceptionPage.jpg',
              fit: BoxFit.cover,
              alignment: Alignment(0, 0.3),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 450,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE3DC).withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Day ${widget.dayNumber} is over!',
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Caveat',
                        color: Color(0xFFFF69B4),
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xFF8B6F8F),
                          fontFamily: 'Caveat',
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Money Earned: ',
                          ),
                          TextSpan(
                            text: '\$${widget.moneyEarned.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color(0xFF87D68D),
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xFF8B6F8F),
                          fontFamily: 'Caveat',
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Total Money: ',
                          ),
                          TextSpan(
                            text: '\$$_currentMoney',
                            style: const TextStyle(
                              color: Color(0xFF87D68D),
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 24,
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
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildButton(
                          context,
                          label: 'Home',
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/starting');
                          },
                        ),

                        _buildButton(
                          context,
                          label: 'Profile',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/profile',
                              arguments: _createPlayer(),
                            );
                          },
                        ),

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
          horizontal: 18,
          vertical: 10,
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