import 'package:flutter/material.dart';

import 'package:gameshelf/config/app_info.dart';
import 'package:gameshelf/config/genres.dart';
import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/theme/app_colors.dart';
import 'package:gameshelf/widgets/category_chip.dart';
import 'package:gameshelf/widgets/game_card.dart';
import 'package:gameshelf/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  int _countStatus(String status) =>
      dummyBacklog.where((item) => item['status'] == status).length;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final firstName = AppInfo.studentName.split(' ').first;
    final popular = dummyGames.take(5).toList();

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

          // Ringkasan jumlah game per status
          Row(
            children: [
              Expanded(
                child: _StatusCount(
                  count: _countStatus('ingin_main'),
                  label: 'Ingin main',
                  color: AppColors.wantToPlay,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusCount(
                  count: _countStatus('sedang_main'),
                  label: 'Sedang main',
                  color: AppColors.playing,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusCount(
                  count: _countStatus('selesai'),
                  label: 'Selesai',
                  color: AppColors.done,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const _RandomGameCard(),
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
                    child: CategoryChip(label: genre.label, onTap: () {}),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SectionHeader(
            title: 'Populer',
            actionLabel: 'Lihat semua',
            onAction: () {},
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 210,
            child: ListView.separated(
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
                      title: game['title'] as String,
                      genre: game['genre'] as String,
                      platform: game['platform'] as String,
                      thumbnailUrl: game['thumbnail'] as String?,
                      status: dummyStatusOf(game['id'] as int),
                    ),
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

class _StatusCount extends StatelessWidget {
  const _StatusCount({
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

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
    );
  }
}

class _RandomGameCard extends StatelessWidget {
  const _RandomGameCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
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
