import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/audio_manager.dart';
import '../services/progress_repository.dart';
import '../screens/customer_reception_screen.dart';
import '../models/player.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final AudioManager _audioManager = AudioManager();

  bool _loading = true;
  int _initialDay = 1;
  int _initialMoney = 0;

  @override
  void initState() {
    super.initState();
    _playMusic();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('No Firebase user, using default progress');
        _initialDay = 1;
        _initialMoney = 0;
        return;
      }

      final repo = ProgressRepository();
      final progress = await repo.loadProgress(user.uid);

      _initialDay = progress.day;
      _initialMoney = progress.money;
      debugPrint('Loaded progress: day=$_initialDay money=$_initialMoney');
    } catch (e, st) {
      debugPrint('Error loading progress: $e');
      debugPrint('$st');

      _initialDay = 1;
      _initialMoney = 0;
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _playMusic() async {
    await _audioManager.playMusic('starting_page.mp3');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(color: Colors.pinkAccent)
        ),
      );
    }

    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/StartPage.jpeg',
            fit: BoxFit.cover,
            alignment: Alignment(0, 0.4),
          ),

          SafeArea(
            child: Stack(
              children: [
                // PLAY BUTTON
                Positioned(
                  top: 120,
                  left: 90,
                  child: _buildButton(
                    context,
                    'Play',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerReceptionScreen(
                            initialDay: _initialDay,
                            initialMoney: _initialMoney,
                            initialCustomers: 0,
                            initialTime: "09:00 AM",
                          ),
                        ),
                      );
                    },
                    fontSize: 60,
                  ),
                ),

                // PROFILE BUTTON (was Kitchen)
                Positioned(
                  top: 120,
                  right: 80,
                  child: _buildButton(
                    context,
                    'Profile',
                        () {
                      final player = Player.fromGameState(
                        day: _initialDay,
                        money: _initialMoney,
                        userId: user?.uid,
                      );
                      Navigator.pushNamed(
                        context,
                        '/profile',
                        arguments: player,
                      );
                    },
                  ),
                ),

                // RECIPES
                Positioned(
                  bottom: 10,
                  left: 80,
                  child: _buildButton(
                    context,
                    'Recipes',
                        () {
                      final player = Player.fromGameState(
                        day: _initialDay,
                        money: _initialMoney,
                        userId: user?.uid,
                      );
                      Navigator.pushNamed(
                        context,
                        '/recipe',
                        arguments: player,
                      );
                    },
                  ),
                ),

                // SETTINGS
                Positioned(
                  bottom: 10,
                  right: 125,
                  child: _buildButton(
                    context,
                    'Setting',
                        () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context,
      String text,
      VoidCallback onPressed, {
        double fontSize = 32,
      }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.transparent,
        overlayColor: const Color(0x33F2F2F2),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Caveat',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color(0xFF424658),
        ),
      ),
    );
  }
}