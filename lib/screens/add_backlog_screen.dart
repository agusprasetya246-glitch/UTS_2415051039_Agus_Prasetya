import 'package:flutter/material.dart';

class AddBacklogScreen extends StatelessWidget {
  const AddBacklogScreen({super.key, required this.game});

  final Map<String, dynamic> game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah ke Backlog')),
      body: Center(
        child: Text(
          'Form tambah untuk ${game['title']}\ndibuat di Tahap 10',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
