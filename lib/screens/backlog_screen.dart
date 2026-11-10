import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/config/app_tabs.dart';
import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/providers/navigation_provider.dart';
import 'package:gameshelf/screens/edit_backlog_screen.dart';
import 'package:gameshelf/services/database_exception.dart';
import 'package:gameshelf/utils/date_formatter.dart';
import 'package:gameshelf/utils/error_message.dart';
import 'package:gameshelf/widgets/backlog_tile.dart';
import 'package:gameshelf/widgets/category_chip.dart';
import 'package:gameshelf/widgets/confirm_delete_dialog.dart';
import 'package:gameshelf/widgets/state_view.dart';

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
    final provider = context.read<BacklogProvider>();

    if (backlog.isLoading) {
      return const StateView.loading(message: 'Memuat backlog…');
    }

    final error = backlog.error;
    if (error != null) {
      return RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: StateView.error(
          title: 'Gagal memuat backlog',
          message: error,
          onRetry: () => provider.loadBacklog(),
        ),
      );
    }

    if (backlog.items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: StateView.empty(
          icon: Icons.bookmark_add_outlined,
          title: 'Backlog masih kosong',
          message: 'Simpan game dari Katalog untuk mulai mencatat progres main kamu.',
          actionLabel: 'Jelajahi Katalog',
          actionIcon: Icons.grid_view_rounded,
          prominentAction: true,
          onAction: () =>
              context.read<NavigationProvider>().select(AppTab.catalog),
        ),
      );
    }

    final items = backlog.filteredItems;
    final filter = backlog.filter;
    if (items.isEmpty && filter != null) {
      return RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: StateView.empty(
          icon: Icons.filter_list_off,
          title: 'Belum ada game berstatus "${filter.label}"',
          message:
              'Pilih filter lain, atau ubah status game lewat halaman Edit.',
          actionLabel: 'Tampilkan semua',
          onAction: () => provider.setFilter(null),
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () => _refresh(context),
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

  Future<void> _refresh(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<BacklogProvider>();
    try {
      await provider.refresh();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(friendlyErrorMessage(e))));
    }
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
