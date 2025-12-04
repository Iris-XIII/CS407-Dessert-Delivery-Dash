import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/starting_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ending_screen.dart';
import 'screens/kitchen_screen.dart';
import 'screens/customer_reception_screen.dart';
import 'screens/recipe_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(DessertDeliveryDash());
}

class DessertDeliveryDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dessert Delivery Dash',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/starting': (context) => StartPage(),
        // TODO change these after implement each screen
        // '/profile': (context) => ProfileScreen(),
        '/ending': (context) => EndingScreen(),
        //'/kitchen': (context) => KitchenScreen(),
        '/customer-reception': (context) => CustomerReceptionScreen(
          initialDay: 2,
          initialMoney: 100,
          initialCustomers: 7,
          initialTime: '8:00',
        ),
        // '/recipe': (context) => RecipeScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}