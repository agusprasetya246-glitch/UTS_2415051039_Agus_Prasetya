import 'package:flutter/material.dart';

import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/widgets/game_thumbnail.dart';
import 'package:gameshelf/widgets/rating_stars.dart';

/// Nilai yang diisi pengguna di BacklogForm.
class BacklogFormData {
  const BacklogFormData({
    this.status = BacklogStatus.wantToPlay,
    this.rating = 0,
    this.hoursPlayed = 0,
    this.note = '',
  });

  final BacklogStatus status;
  final int rating;
  final int hoursPlayed;
  final String note;
}

/// Form backlog: status, rating, jam main, catatan. Dipakai di Tambah dan Edit.
class BacklogForm extends StatefulWidget {
  const BacklogForm({
    super.key,
    required this.header,
    required this.submitLabel,
    required this.onSubmit,
    this.initialData = const BacklogFormData(),
    this.isSaving = false,
  });

  final Widget header;
  final String submitLabel;
  final ValueChanged<BacklogFormData> onSubmit;
  final BacklogFormData initialData;
  final bool isSaving;

  @override
  State<BacklogForm> createState() => _BacklogFormState();
}

class _BacklogFormState extends State<BacklogForm> {
  static const int _maxNoteLength = 200;

  final _formKey = GlobalKey<FormState>();
  late BacklogStatus _status;
  late int _rating;
  late final TextEditingController _hoursController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _status = widget.initialData.status;
    _rating = widget.initialData.rating;
    _hoursController = TextEditingController(
      text: '${widget.initialData.hoursPlayed}',
    );
    _noteController = TextEditingController(text: widget.initialData.note);
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _validateHours(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Jam main wajib diisi';

    final hours = int.tryParse(text);
    if (hours == null) return 'Jam main harus berupa angka';
    if (hours < 0) return 'Jam main tidak boleh negatif';
    if (hours > 10000) return 'Jam main maksimal 10.000';
    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    widget.onSubmit(
      BacklogFormData(
        status: _status,
        rating: _rating,
        hoursPlayed: int.parse(_hoursController.text.trim()),
        note: _noteController.text.trim(),
      ),
    );
  }

  InputDecoration _decoration(
    String label, {
    String? helper,
    String? suffix,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      suffixText: suffix,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final mutedSmall = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Form(
      key: _formKey,
      // Pesan error muncul begitu pengguna mulai mengisi field.
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              children: [
                widget.header,
                const SizedBox(height: 24),

                // Status (wajib)
                DropdownButtonFormField<BacklogStatus>(
                  initialValue: _status,
                  decoration: _decoration('Status'),
                  items: [
                    for (final status in BacklogStatus.values)
                      DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      ),
                  ],
                  validator: (value) =>
                      value == null ? 'Status wajib dipilih' : null,
                  onChanged: widget.isSaving
                      ? null
                      : (value) {
                          if (value != null) setState(() => _status = value);
                        },
                ),
                const SizedBox(height: 24),

                // Rating (opsional)
                Text('Rating (opsional)', style: mutedSmall),
                RatingStars(
                  rating: _rating,
                  size: 32,
                  onChanged: widget.isSaving
                      ? null
                      : (value) => setState(() => _rating = value),
                ),
                Text(
                  _rating == 0
                      ? 'Belum dinilai · ketuk bintang untuk memberi nilai'
                      : '$_rating dari 5',
                  style: mutedSmall,
                ),
                const SizedBox(height: 24),

                // Jam main (wajib, angka ≥ 0)
                TextFormField(
                  controller: _hoursController,
                  enabled: !widget.isSaving,
                  keyboardType: TextInputType.number,
                  decoration: _decoration(
                    'Jam main',
                    helper: 'Isi 0 kalau belum pernah dimainkan',
                    suffix: 'jam',
                  ),
                  validator: _validateHours,
                ),
                const SizedBox(height: 24),

                // Catatan (opsional, maks. 200 karakter)
                TextFormField(
                  controller: _noteController,
                  enabled: !widget.isSaving,
                  maxLength: _maxNoteLength,
                  maxLines: 3,
                  decoration: _decoration(
                    'Catatan (opsional)',
                    hint: 'Contoh: main bareng teman akhir pekan',
                  ),
                ),
              ],
            ),
          ),

          // Tombol simpan selalu terlihat di bawah
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.isSaving ? null : _submit,
                  child: widget.isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.submitLabel),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu ringkas game di atas form (thumbnail + judul + keterangan).
class BacklogFormHeader extends StatelessWidget {
  const BacklogFormHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.thumbnailUrl,
  });

  final String title;
  final String subtitle;
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 96,
              child: GameThumbnail(
                title: title,
                imageUrl: thumbnailUrl,
                borderRadius: 8,
                initialsSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
