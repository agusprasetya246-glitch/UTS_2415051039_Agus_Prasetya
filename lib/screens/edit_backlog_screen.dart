import 'package:flutter/material.dart';

class EditBacklogScreen extends StatelessWidget {
  const EditBacklogScreen({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Backlog')),
      body: Center(
        child: Text(
          'Form edit untuk ${item['title']}\ndibuat di Tahap 11',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
