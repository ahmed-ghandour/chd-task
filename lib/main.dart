import 'package:chd_auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'presentation/screens/user_details_screen.dart';


void main() {
 
  runApp(const MainApp());
 
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:LoginScreen(),
    );
  }
}
