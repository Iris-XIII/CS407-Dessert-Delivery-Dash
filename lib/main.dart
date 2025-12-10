import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/starting_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ending_screen.dart';
import 'screens/kitchen_screen.dart';
import 'screens/customer_reception_screen.dart';
import 'screens/recipe_screen.dart';
import 'screens/settings_screen.dart';
import 'models/player.dart';
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
      // Use onGenerateRoute instead of routes to support arguments
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => HomeScreen(),
            );

          case '/starting':
            return MaterialPageRoute(
              builder: (context) => StartPage(),
            );

          case '/profile':
          // Get Player from arguments, or create default
            final player = settings.arguments as Player? ?? Player.newPlayer();
            return MaterialPageRoute(
              builder: (context) => ProfileScreen(player: player),
            );

          case '/ending':
            return MaterialPageRoute(
              builder: (context) => EndingScreen(),
            );

          case '/customer-reception':
            return MaterialPageRoute(
              builder: (context) => CustomerReceptionScreen(
                initialDay: 1,
                initialMoney: 0,
                initialCustomers: 0,
                initialTime: '09:00 AM',
              ),
            );

          case '/recipe':
          // Get Player from arguments, or create default
            final player = settings.arguments as Player? ?? Player.newPlayer();
            return MaterialPageRoute(
              builder: (context) => RecipeScreen(player: player),
            );

          case '/settings':
            return MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            );

        // Fallback for unknown routes
          default:
            return MaterialPageRoute(
              builder: (context) => HomeScreen(),
            );
        }
      },
    );
  }
}