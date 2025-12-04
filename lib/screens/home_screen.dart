// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'starting_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/HomePage.jpeg'),
            fit: BoxFit.cover,
              alignment: Alignment(0, 0.3) //shift the image up slightly
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
                  Navigator.pushNamed(context, '/profile');
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StartPage()),
                  );
                   */
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