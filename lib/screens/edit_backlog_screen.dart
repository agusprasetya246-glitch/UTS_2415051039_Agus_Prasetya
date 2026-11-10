import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/services/database_exception.dart';
import 'package:gameshelf/utils/date_formatter.dart';
import 'package:gameshelf/widgets/backlog_form.dart';

class EditBacklogScreen extends StatefulWidget {
  const EditBacklogScreen({super.key, required this.item});

  final BacklogItem item;

  @override
  State<EditBacklogScreen> createState() => _EditBacklogScreenState();
}

class _EditBacklogScreenState extends State<EditBacklogScreen> {
  bool _isSaving = false;

  bool _isUnchanged(BacklogFormData data) {
    final item = widget.item;
    return data.status == item.status &&
        data.rating == item.rating &&
        data.hoursPlayed == item.hoursPlayed &&
        data.note == item.note;
  }

  Future<void> _save(BacklogFormData data) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final backlog = context.read<BacklogProvider>();

    if (_isUnchanged(data)) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Tidak ada perubahan')),
      );
      navigator.pop();
      return;
    }

    final changed = widget.item.copyWith(
      status: data.status,
      rating: data.rating,
      hoursPlayed: data.hoursPlayed,
      note: data.note,
    );

    setState(() => _isSaving = true);

    try {
      await backlog.update(changed);
      messenger.showSnackBar(
        const SnackBar(content: Text('Perubahan disimpan')),
      );
      navigator.pop();
    } on DatabaseException catch (e) {
      _showError(messenger, e.message);
    } catch (_) {
      _showError(
        messenger,
        'Gagal menyimpan perubahan. Periksa koneksi lalu coba lagi.',
      );
    }
  }

  void _showError(ScaffoldMessengerState messenger, String message) {
    if (!mounted) return;
    setState(() => _isSaving = false);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final createdAt = item.createdAt;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Backlog')),
      body: BacklogForm(
        header: BacklogFormHeader(
          title: item.title,
          subtitle: createdAt == null
              ? 'Ada di backlog kamu'
              : 'Ditambahkan ${formatShortDate(createdAt)}',
          thumbnailUrl: item.thumbnail,
        ),
        submitLabel: 'Simpan Perubahan',
        // Form terisi data lama.
        initialData: BacklogFormData(
          status: item.status,
          rating: item.rating,
          hoursPlayed: item.hoursPlayed,
          note: item.note,
        ),
        isSaving: _isSaving,
        onSubmit: _save,
      ),
    );
  }
}
