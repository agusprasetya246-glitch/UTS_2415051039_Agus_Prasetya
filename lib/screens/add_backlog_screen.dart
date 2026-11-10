import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/services/database_exception.dart';
import 'package:gameshelf/widgets/backlog_form.dart';
import 'package:gameshelf/config/app_tabs.dart';
import 'package:gameshelf/providers/navigation_provider.dart';

class AddBacklogScreen extends StatefulWidget {
  const AddBacklogScreen({super.key, required this.game});

  final Game game;

  @override
  State<AddBacklogScreen> createState() => _AddBacklogScreenState();
}

class _AddBacklogScreenState extends State<AddBacklogScreen> {
  bool _isSaving = false;

  Future<void> _save(BacklogFormData data) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final backlog = context.read<BacklogProvider>();
    final navigation = context.read<NavigationProvider>();

    setState(() => _isSaving = true);

    try {
      await backlog.add(
        game: widget.game,
        status: data.status,
        rating: data.rating,
        hoursPlayed: data.hoursPlayed,
        note: data.note,
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text('${widget.game.title} ditambahkan ke backlog'),
          action: SnackBarAction(
            label: 'Lihat',
            onPressed: () {
              backlog.setFilter(null); // pastikan game baru terlihat
              navigation.select(AppTab.backlog);
              navigator.popUntil((route) => route.isFirst);
            },
          ),
        ),
      );
      navigator.pop();
    } on DatabaseException catch (e) {
      _showError(messenger, e.message);
    } catch (_) {
      _showError(messenger, 'Gagal menyimpan. Periksa koneksi lalu coba lagi.');
    }
  }

  void _showError(ScaffoldMessengerState messenger, String message) {
    if (!mounted) return;
    setState(() => _isSaving = false);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah ke Backlog')),
      body: BacklogForm(
        header: BacklogFormHeader(
          title: game.title,
          subtitle: '${game.genre} · ${game.platform}',
          thumbnailUrl: game.thumbnail,
        ),
        submitLabel: 'Simpan ke Backlog',
        isSaving: _isSaving,
        onSubmit: _save,
      ),
    );
  }
}
