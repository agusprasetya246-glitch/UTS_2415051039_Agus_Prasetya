import 'package:flutter/material.dart';

class AddBacklogScreen extends StatelessWidget {
  const AddBacklogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah ke Backlog')),
      body: const Center(child: Text('Form tambah backlog dibuat di Tahap 10')),
    );
  }
}
