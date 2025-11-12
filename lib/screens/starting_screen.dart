import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
              'assets/images/StartPage.jpeg',
              fit: BoxFit.cover,
              alignment: Alignment(0, 0.4)
          ),

          // Buttons positioned over the background
          SafeArea(
            child: Stack(
              children: [
                // "Play" button - Upper left (reception desk)
                Positioned(
                  top: 120,
                  left: 90,
                  child: _buildButton(
                    context,
                    'Play',
                        () {
                      Navigator.pushNamed(context, '/customer-reception');
                      print('Play button pressed');
                    },
                    fontSize: 60, // Larger font size for Play button
                  ),
                ),

                // "Kitchen" button - Upper right (kitchen area)
                Positioned(
                  top: 120,
                  right: 80,
                  child: _buildButton(
                    context,
                    'Kitchen',
                        () {
                          Navigator.pushNamed(context, '/kitchen');
                      print('Kitchen button pressed');
                    },
                  ),
                ),

                // "Recipes" button - Lower left (recipe book)
                Positioned(
                  bottom: 10,
                  left: 80,
                  child: _buildButton(
                    context,
                    'Recipes',
                        () {
                          Navigator.pushNamed(context, '/recipe');
                      print('Recipes button pressed');
                    },
                  ),
                ),

                // "Setting" button - Lower right (candy jars)
                Positioned(
                  bottom: 10,
                  right: 125,
                  child: _buildButton(
                    context,
                    'Setting',
                        () {
                          Navigator.pushNamed(context, '/settings');
                      print('Setting button pressed');
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
      VoidCallback onPressed,
      {double fontSize = 32} // Default font size is 32, can be overridden
      ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.transparent,
        overlayColor: const Color(0x33F2F2F2), // Slight overlay on press
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Caveat',
          fontSize: fontSize, // Use the parameter
          fontWeight: FontWeight.bold,
          color: Color(0xFF424658),
        ),
      ),
    );
  }
}