import 'package:flutter/material.dart';

import 'package:gameshelf/config/breakpoints.dart';
import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/widgets/game_thumbnail.dart';
import 'package:gameshelf/widgets/info_card.dart';
import 'package:gameshelf/widgets/section_header.dart';
import 'package:gameshelf/screens/add_backlog_screen.dart';

class GameDetailScreen extends StatelessWidget {
  const GameDetailScreen({super.key, required this.gameId});

  final int gameId;

  @override
  Widget build(BuildContext context) {
    final detail = dummyDetailOf(gameId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Game')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (Breakpoints.isExpanded(constraints.maxWidth)) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _thumbnail(detail, wide: true),
                        const SizedBox(height: 16),
                        ..._screenshots(detail),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ..._header(context, detail),
                        const SizedBox(height: 24),
                        ..._about(context, detail),
                        const SizedBox(height: 16),
                        ..._infoSections(detail),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              _thumbnail(detail, wide: false),
              const SizedBox(height: 20),
              ..._header(context, detail),
              const SizedBox(height: 24),
              ..._about(context, detail),
              const SizedBox(height: 16),
              ..._screenshots(detail),
              ..._infoSections(detail),
            ],
          );
        },
      ),
    );
  }

  Widget _thumbnail(Map<String, dynamic> detail, {required bool wide}) {
    return GameThumbnail(
      title: detail['title'] as String,
      imageUrl: detail['thumbnail'] as String?,
      borderRadius: wide ? 16 : 12,
      initialsSize: wide ? 64 : 44,
    );
  }

  List<Widget> _header(BuildContext context, Map<String, dynamic> detail) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final platform = detail['platform'] as String;

    return [
      Text(detail['title'] as String, style: textTheme.headlineSmall),
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
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddBacklogScreen(game: detail),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Tambah ke Backlog'),
        ),
      ),
    ];
  }

  List<Widget> _about(BuildContext context, Map<String, dynamic> detail) {
    return [
      const SectionHeader(title: 'Tentang game'),
      const SizedBox(height: 8),
      Text(
        detail['description'] as String,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton(onPressed: () {}, child: const Text('Selengkapnya')),
      ),
    ];
  }

  List<Widget> _screenshots(Map<String, dynamic> detail) {
    final screenshots = (detail['screenshots'] as List)
        .cast<Map<String, dynamic>>();
    if (screenshots.isEmpty) return [];

    return [
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
              title: detail['title'] as String,
              imageUrl: screenshots[index]['image'] as String?,
              borderRadius: 8,
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _infoSections(Map<String, dynamic> detail) {
    final requirements =
        detail['minimum_system_requirements'] as Map<String, dynamic>?;

    return [
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
    ];
  }
}
