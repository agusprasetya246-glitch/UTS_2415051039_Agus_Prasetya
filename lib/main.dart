import 'package:flutter/material.dart';

const String studentName = 'Agus Prasetya';
const String studentId = '2415051039';
const String studentClass = 'PTI-5B';

void main() {
  runApp(const GameShelfApp());
}

class GameShelfApp extends StatelessWidget {
  const GameShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameShelf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sports_esports, size: 72),
                const SizedBox(height: 16),
                Text('GameShelf', style: textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Katalog game free-to-play dan backlog pribadi',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  '$studentName · $studentId · $studentClass',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
