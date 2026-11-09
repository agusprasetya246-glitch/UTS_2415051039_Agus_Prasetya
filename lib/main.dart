import 'package:flutter/material.dart';

import 'package:gameshelf/config/app_info.dart';
import 'package:gameshelf/screens/home_screen.dart';
import 'package:gameshelf/theme/app_theme.dart';

void main() {
  runApp(const GameShelfApp());
}

class GameShelfApp extends StatelessWidget {
  const GameShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
