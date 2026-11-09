import 'package:flutter/material.dart';

import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/utils/date_formatter.dart';
import 'package:gameshelf/widgets/backlog_tile.dart';
import 'package:gameshelf/widgets/category_chip.dart';

class BacklogScreen extends StatelessWidget {
  const BacklogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    int count(String status) =>
        dummyBacklog.where((item) => item['status'] == status).length;

    final filters = [
      'Semua (${dummyBacklog.length})',
      'Ingin main (${count('ingin_main')})',
      'Sedang main (${count('sedang_main')})',
      'Selesai (${count('selesai')})',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              '${dummyBacklog.length} game · tarik ke bawah untuk memuat ulang',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: dummyBacklog.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = dummyBacklog[index];
                return BacklogTile(
                  title: item['title'] as String,
                  thumbnailUrl: item['thumbnail'] as String?,
                  status: item['status'] as String,
                  rating: item['rating'] as int,
                  hoursPlayed: item['hours_played'] as int,
                  addedLabel: formatShortDate(
                    DateTime.parse(item['created_at'] as String),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
