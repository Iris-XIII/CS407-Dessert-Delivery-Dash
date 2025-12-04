import 'package:flutter/material.dart';
import 'starting_screen.dart';
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
    await _audioManager.playMusic('Home Page.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/HomePage.jpeg'),
            fit: BoxFit.cover,
            alignment: Alignment(0, 0.3), //shift the image up slightly
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 170), // Adjust to position on door
              Padding(
                padding: EdgeInsets.only(left: 170),
                // Round "Enter" button
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartPage()),
                    );
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