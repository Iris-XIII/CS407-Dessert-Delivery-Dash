import 'package:flutter/material.dart';
import '../services/audio_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioManager _audioManager = AudioManager();

  @override
  void initState() {
    super.initState();
    _playMusic();
  }

  Future<void> _playMusic() async {
    await _audioManager.playMusic('home_page.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/HomePage.jpeg'),
            fit: BoxFit.cover,
            alignment: Alignment(0, 0.3),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 170),
              Padding(
                padding: EdgeInsets.only(left: 170),
                child: InkWell(
                  onTap: () {
                    // Go to starting page, not profile
                    Navigator.pushNamed(context, '/starting');
                  },
                  child: Center(
                    child: Text(
                      'Enter',
                      style: const TextStyle(
                        fontFamily: 'Caveat',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF2F2F2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}