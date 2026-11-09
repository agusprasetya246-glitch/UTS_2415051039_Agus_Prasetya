import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/config/app_info.dart';
import 'package:gameshelf/config/app_tabs.dart';
import 'package:gameshelf/config/genres.dart';
import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/providers/game_provider.dart';
import 'package:gameshelf/screens/game_detail_screen.dart';
import 'package:gameshelf/theme/app_colors.dart';
import 'package:gameshelf/widgets/category_chip.dart';
import 'package:gameshelf/widgets/game_card.dart';
import 'package:gameshelf/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onOpenTab});

  final ValueChanged<int>? onOpenTab;

  void _openDetail(BuildContext context, int gameId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GameDetailScreen(gameId: gameId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final firstName = AppInfo.studentName.split(' ').first;

    final games = context.watch<GameProvider>();
    final backlog = context.watch<BacklogProvider>();
    final firstWant = backlog.firstWantToPlay;

    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: 'Game',
            children: [
              TextSpan(
                text: 'Shelf',
                style: TextStyle(color: colorScheme.primary),
              ),
            ],
          ),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text('Halo, $firstName', style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Mau main apa hari ini?',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _StatusCount(
                  count: backlog.countOf(BacklogStatus.wantToPlay),
                  label: BacklogStatus.wantToPlay.label,
                  color: AppColors.wantToPlay,
                  onTap: () => onOpenTab?.call(AppTab.backlog),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusCount(
                  count: backlog.countOf(BacklogStatus.playing),
                  label: BacklogStatus.playing.label,
                  color: AppColors.playing,
                  onTap: () => onOpenTab?.call(AppTab.backlog),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusCount(
                  count: backlog.countOf(BacklogStatus.done),
                  label: BacklogStatus.done.label,
                  color: AppColors.done,
                  onTap: () => onOpenTab?.call(AppTab.backlog),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _RandomGameCard(
            onTap: firstWant == null
                ? null
                : () => _openDetail(context, firstWant.gameId),
          ),
          const SizedBox(height: 24),

          const SectionHeader(title: 'Jelajahi genre'),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final genre in genreOptions.skip(1))
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      label: genre.label,
                      onTap: () {
                        context.read<GameProvider>().selectGenre(genre);
                        onOpenTab?.call(AppTab.catalog);
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SectionHeader(
            title: 'Populer',
            actionLabel: 'Lihat semua',
            onAction: () => onOpenTab?.call(AppTab.catalog),
          ),
          const SizedBox(height: 4),
          SizedBox(height: 210, child: _buildPopular(context, games, backlog)),
        ],
      ),
    );
  }

  Widget _buildPopular(
    BuildContext context,
    GameProvider games,
    BacklogProvider backlog,
  ) {
    if (games.isLoadingPopular) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = games.popularError;
    if (error != null) {
      return Center(child: Text(error, textAlign: TextAlign.center));
    }

    final popular = games.popularGames;
    if (popular.isEmpty) {
      return const Center(child: Text('Belum ada game populer'));
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: popular.length,
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final game = popular[index];
        return SizedBox(
          width: 220,
          child: Align(
            alignment: Alignment.topCenter,
            child: GameCard(
              title: game.title,
              genre: game.genre,
              platform: game.platform,
              thumbnailUrl: game.thumbnail,
              status: backlog.statusOf(game.id),
              onTap: () => _openDetail(context, game.id),
            ),
          ),
        );
      },
    );
  }
}

class _StatusCount extends StatelessWidget {
  const _StatusCount({
    required this.count,
    required this.label,
    required this.color,
    this.onTap,
  });

  final int count;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RandomGameCard extends StatelessWidget {
  const _RandomGameCard({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                child: const Icon(Icons.casino_outlined),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bingung mau main apa?',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Acak satu game dari backlog Ingin main',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSecondaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
