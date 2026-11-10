import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/screens/edit_backlog_screen.dart';
import 'package:gameshelf/services/database_exception.dart';
import 'package:gameshelf/utils/date_formatter.dart';
import 'package:gameshelf/widgets/backlog_tile.dart';
import 'package:gameshelf/widgets/category_chip.dart';
import 'package:gameshelf/widgets/confirm_delete_dialog.dart';

class BacklogScreen extends StatelessWidget {
  const BacklogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backlog = context.watch<BacklogProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Backlog Saya')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilters(context, backlog),
          const SizedBox(height: 8),
          Expanded(child: _buildList(context, backlog)),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, BacklogProvider backlog) {
    final provider = context.read<BacklogProvider>();

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CategoryChip(
            label: 'Semua (${backlog.items.length})',
            selected: backlog.filter == null,
            onTap: () => provider.setFilter(null),
          ),
          for (final status in BacklogStatus.values) ...[
            const SizedBox(width: 8),
            CategoryChip(
              label: '${status.label} (${backlog.countOf(status)})',
              selected: backlog.filter == status,
              onTap: () => provider.setFilter(status),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, BacklogProvider backlog) {
    if (backlog.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final provider = context.read<BacklogProvider>();
    Future<void> refresh() => provider.loadBacklog(showLoading: false);

    final error = backlog.error;
    if (error != null) {
      return RefreshIndicator(
        onRefresh: refresh,
        child: _ScrollableMessage(error),
      );
    }

    if (backlog.items.isEmpty) {
      return RefreshIndicator(
        onRefresh: refresh,
        child: const _ScrollableMessage(
          'Backlog masih kosong.\n'
          'Simpan game dari Katalog untuk mulai mencatat progres main kamu.',
        ),
      );
    }

    final items = backlog.filteredItems;
    final filter = backlog.filter;
    if (items.isEmpty && filter != null) {
      return RefreshIndicator(
        onRefresh: refresh,
        child: _ScrollableMessage(
          'Belum ada game berstatus "${filter.label}".',
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.separated(
        // Selalu bisa ditarik walaupun isinya sedikit.
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: items.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(
              '${items.length} game · tarik ke bawah untuk memuat ulang',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            );
          }

          final item = items[index - 1];
          final createdAt = item.createdAt;

          return BacklogTile(
            title: item.title,
            status: item.status,
            rating: item.rating,
            hoursPlayed: item.hoursPlayed,
            addedLabel: createdAt == null
                ? 'baru saja'
                : formatShortDate(createdAt),
            thumbnailUrl: item.thumbnail,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditBacklogScreen(item: item),
              ),
            ),
            onDelete: () => _confirmDelete(context, item),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, BacklogItem item) async {
    // Ambil semua yang butuh context SEBELUM await.
    final messenger = ScaffoldMessenger.of(context);
    final backlog = context.read<BacklogProvider>();

    final confirmed = await showConfirmDeleteDialog(
      context,
      itemName: item.title,
    );
    if (!confirmed) return;

    try {
      await backlog.remove(item);
      messenger.showSnackBar(
        SnackBar(content: Text('${item.title} dihapus dari backlog')),
      );
    } on DatabaseException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus. Periksa koneksi lalu coba lagi.'),
        ),
      );
    }
  }
}

class _ScrollableMessage extends StatelessWidget {
  const _ScrollableMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
