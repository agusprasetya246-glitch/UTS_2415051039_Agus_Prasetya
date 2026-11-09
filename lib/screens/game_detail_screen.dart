import 'package:flutter/material.dart';

import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/widgets/game_thumbnail.dart';
import 'package:gameshelf/widgets/info_card.dart';
import 'package:gameshelf/widgets/section_header.dart';

class GameDetailScreen extends StatelessWidget {
  const GameDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    const detail = dummyGameDetail;
    final title = detail['title'] as String;
    final platform = detail['platform'] as String;
    final screenshots = (detail['screenshots'] as List)
        .cast<Map<String, dynamic>>();
    final requirements =
        detail['minimum_system_requirements'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Game')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          GameThumbnail(
            title: title,
            imageUrl: detail['thumbnail'] as String?,
            borderRadius: 12,
            initialsSize: 44,
          ),
          const SizedBox(height: 20),

          Text(title, style: textTheme.headlineSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: Icon(
                  Icons.sports_esports_outlined,
                  size: 18,
                  color: colorScheme.primary,
                ),
                label: Text(detail['genre'] as String),
              ),
              Chip(
                avatar: Icon(
                  platform.contains('Browser')
                      ? Icons.language
                      : Icons.desktop_windows_outlined,
                  size: 18,
                  color: colorScheme.primary,
                ),
                label: Text(platform),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            detail['short_description'] as String,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Tambah ke Backlog'),
            ),
          ),
          const SizedBox(height: 24),

          const SectionHeader(title: 'Tentang game'),
          const SizedBox(height: 8),
          Text(
            detail['description'] as String,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              child: const Text('Selengkapnya'),
            ),
          ),
          const SizedBox(height: 16),

          if (screenshots.isNotEmpty) ...[
            const SectionHeader(title: 'Screenshot'),
            const SizedBox(height: 12),
            SizedBox(
              height: 124,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: screenshots.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) => SizedBox(
                  width: 220,
                  child: GameThumbnail(
                    title: title,
                    imageUrl: screenshots[index]['image'] as String?,
                    borderRadius: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          const SectionHeader(title: 'Informasi'),
          const SizedBox(height: 12),
          InfoCard(
            items: {
              'Developer': detail['developer'] as String,
              'Publisher': detail['publisher'] as String,
              'Tanggal rilis': detail['release_date'] as String,
              'Status': detail['status'] as String,
            },
          ),

          if (requirements != null) ...[
            const SizedBox(height: 24),
            const SectionHeader(title: 'Spesifikasi minimum'),
            const SizedBox(height: 12),
            InfoCard(
              items: {
                'OS': requirements['os'] as String? ?? '-',
                'Prosesor': requirements['processor'] as String? ?? '-',
                'Memori': requirements['memory'] as String? ?? '-',
                'Grafis': requirements['graphics'] as String? ?? '-',
                'Penyimpanan': requirements['storage'] as String? ?? '-',
              },
            ),
          ],
        ],
      ),
    );
  }
}
