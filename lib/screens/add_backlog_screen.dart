import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';

class AddBacklogScreen extends StatelessWidget {
  const AddBacklogScreen({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah ke Backlog')),
      body: Center(
        child: Text(
          'Form tambah untuk ${game.title}\ndibuat di Tahap 10',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
