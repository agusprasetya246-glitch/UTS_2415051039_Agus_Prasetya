import 'package:flutter/material.dart';

import 'package:gameshelf/config/breakpoints.dart';
import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/models/game_detail.dart';
import 'package:gameshelf/screens/add_backlog_screen.dart';
import 'package:gameshelf/widgets/game_thumbnail.dart';
import 'package:gameshelf/widgets/info_card.dart';
import 'package:gameshelf/widgets/section_header.dart';

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
          // Expanded (≥ 840): dua kolom
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

  Widget _thumbnail(GameDetail detail, {required bool wide}) {
    return GameThumbnail(
      title: detail.title,
      imageUrl: detail.thumbnail,
      borderRadius: wide ? 16 : 12,
      initialsSize: wide ? 64 : 44,
    );
  }

  List<Widget> _header(BuildContext context, GameDetail detail) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return [
      Text(detail.title, style: textTheme.headlineSmall),
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
            label: Text(detail.genre),
          ),
          Chip(
            avatar: Icon(
              detail.isBrowserGame
                  ? Icons.language
                  : Icons.desktop_windows_outlined,
              size: 18,
              color: colorScheme.primary,
            ),
            label: Text(detail.platform),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        detail.shortDescription,
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

  List<Widget> _about(BuildContext context, GameDetail detail) {
    return [
      const SectionHeader(title: 'Tentang game'),
      const SizedBox(height: 8),
      Text(
        detail.description,
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

  List<Widget> _screenshots(GameDetail detail) {
    if (detail.screenshots.isEmpty) return [];

    return [
      const SectionHeader(title: 'Screenshot'),
      const SizedBox(height: 12),
      SizedBox(
        height: 124,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: detail.screenshots.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) => SizedBox(
            width: 220,
            child: GameThumbnail(
              title: detail.title,
              imageUrl: detail.screenshots[index],
              borderRadius: 8,
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _infoSections(GameDetail detail) {
    final requirements = detail.minimumSystemRequirements;

    return [
      const SectionHeader(title: 'Informasi'),
      const SizedBox(height: 12),
      InfoCard(
        items: {
          'Developer': detail.developer,
          'Publisher': detail.publisher,
          'Tanggal rilis': detail.releaseDate,
          'Status': detail.status,
        },
      ),
      if (requirements != null) ...[
        const SizedBox(height: 24),
        const SectionHeader(title: 'Spesifikasi minimum'),
        const SizedBox(height: 12),
        InfoCard(
          items: {
            'OS': requirements.os,
            'Prosesor': requirements.processor,
            'Memori': requirements.memory,
            'Grafis': requirements.graphics,
            'Penyimpanan': requirements.storage,
          },
        ),
      ],
    ];
  }
}
