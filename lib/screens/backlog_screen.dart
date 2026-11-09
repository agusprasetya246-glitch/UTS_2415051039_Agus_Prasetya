import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/screens/edit_backlog_screen.dart';
import 'package:gameshelf/utils/date_formatter.dart';
import 'package:gameshelf/widgets/backlog_tile.dart';
import 'package:gameshelf/widgets/category_chip.dart';

class BacklogScreen extends StatelessWidget {
  const BacklogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final backlog = context.watch<BacklogProvider>();
    final items = backlog.items;

    final filters = [
      'Semua (${items.length})',
      for (final status in BacklogStatus.values)
        '${status.label} (${backlog.countOf(status)})',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Backlog Saya')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 12),
            child: Row(
              children: [
                for (var i = 0; i < filters.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      label: filters[i],
                      selected: i == 0,
                      onTap: () {},
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: _buildList(context, backlog, textTheme, colorScheme)),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    BacklogProvider backlog,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    if (backlog.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = backlog.error;
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(error, textAlign: TextAlign.center),
        ),
      );
    }

    final items = backlog.items;
    if (items.isEmpty) {
      return const Center(child: Text('Backlog masih kosong'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: items.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(
            '${items.length} game · tarik ke bawah untuk memuat ulang',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          );
        }

        final item = items[index - 1];
        final createdAt = item.createdAt;

        return BacklogTile(
          title: item.title,
          thumbnailUrl: item.thumbnail,
          status: item.status,
          rating: item.rating,
          hoursPlayed: item.hoursPlayed,
          addedLabel: createdAt == null ? '-' : formatShortDate(createdAt),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditBacklogScreen(item: item),
            ),
          ),
        );
      },
    );
  }
}
