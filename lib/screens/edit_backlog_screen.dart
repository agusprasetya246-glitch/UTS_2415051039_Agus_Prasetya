import 'package:flutter/material.dart';
import 'package:gameshelf/models/backlog_item.dart';

class EditBacklogScreen extends StatelessWidget {
  const EditBacklogScreen({super.key, required this.item});

  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Backlog')),
      body: Center(
        child: Text(
          'Form edit untuk ${item.title}\ndibuat di Tahap 11',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
