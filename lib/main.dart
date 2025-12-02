import 'package:dessert_delivery_dash/firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/starting_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ending_screen.dart';
import 'screens/kitchen_screen.dart';
import 'screens/customer_reception_screen.dart';
import 'screens/recipe_screen.dart';
import 'screens/settings_screen.dart';
// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/profile': (context) => ProfileScreen(),
        '/ending': (context) => EndingScreen(),
        '/kitchen': (context) => KitchenScreen(),
        '/customer-reception': (context) => CustomerReceptionScreen(
          characterAsset: 'Deer.png',
          initialDay: 2,
          initialMoney: 100,
          initialCustomers: 7,
          initialTime: '8:00',
          initialOrders: const [
            ['🍞', '🧁'],
            ['🍞', '🍞', '🍪'],
            ['🧁'],
          ],
        ),
        '/recipe': (context) => RecipeScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}