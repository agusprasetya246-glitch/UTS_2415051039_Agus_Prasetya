import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required String itemName,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDeleteDialog(itemName: itemName),
  );
  return confirmed ?? false;
}

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key, required this.itemName});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(Icons.delete_outline, color: colorScheme.error),
      title: Text('Hapus $itemName?'),
      content: Text(
        '$itemName akan dihapus dari backlog kamu. '
        'Tindakan ini tidak bisa dibatalkan.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
