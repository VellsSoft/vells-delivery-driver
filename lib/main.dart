import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(DeliveryApp(isLoggedIn: token != null));
}

class DeliveryApp extends StatelessWidget {
  final bool isLoggedIn;

  const DeliveryApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allens Driver',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
