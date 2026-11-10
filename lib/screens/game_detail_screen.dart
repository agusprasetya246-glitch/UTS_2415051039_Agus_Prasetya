import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/config/breakpoints.dart';
import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/models/game_detail.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/providers/game_detail_provider.dart';
import 'package:gameshelf/repositories/game_repository.dart';
import 'package:gameshelf/screens/add_backlog_screen.dart';
import 'package:gameshelf/screens/edit_backlog_screen.dart';
import 'package:gameshelf/widgets/game_thumbnail.dart';
import 'package:gameshelf/widgets/info_card.dart';
import 'package:gameshelf/widgets/section_header.dart';
import 'package:gameshelf/widgets/status_badge.dart';

class GameDetailScreen extends StatelessWidget {
  const GameDetailScreen({super.key, required this.gameId});

  final int gameId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          GameDetailProvider(context.read<GameRepository>(), gameId)..load(),
      child: const _GameDetailView(),
    );
  }
}

class _GameDetailView extends StatelessWidget {
  const _GameDetailView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameDetailProvider>();
    final backlogItem = context.watch<BacklogProvider>().itemForGame(
      provider.gameId,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Game')),
      body: _buildBody(context, provider, backlogItem),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GameDetailProvider provider,
    BacklogItem? backlogItem,
  ) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = provider.error;
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(error, textAlign: TextAlign.center),
        ),
      );
    }

    final detail = provider.detail;
    if (detail == null) return const SizedBox.shrink();

    return LayoutBuilder(
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
                      ..._header(context, detail, backlogItem),
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
            ..._header(context, detail, backlogItem),
            const SizedBox(height: 24),
            ..._about(context, detail),
            const SizedBox(height: 16),
            ..._screenshots(detail),
            ..._infoSections(detail),
          ],
        );
      },
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

  List<Widget> _header(
    BuildContext context,
    GameDetail detail,
    BacklogItem? backlogItem,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return [
      Text(detail.title, style: textTheme.headlineSmall),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (backlogItem != null) StatusBadge(status: backlogItem.status),
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
        child: backlogItem == null
            ? FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddBacklogScreen(game: detail),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Tambah ke Backlog'),
              )
            : FilledButton.tonalIcon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditBacklogScreen(item: backlogItem),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit di Backlog'),
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
