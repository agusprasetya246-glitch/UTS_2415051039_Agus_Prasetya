import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/config/breakpoints.dart';
import 'package:gameshelf/config/genres.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/providers/game_provider.dart';
import 'package:gameshelf/screens/game_detail_screen.dart';
import 'package:gameshelf/widgets/category_chip.dart';
import 'package:gameshelf/widgets/game_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = Breakpoints.isExpanded(MediaQuery.sizeOf(context).width);
    final sidePadding = isWide ? 24.0 : 16.0;

    final provider = context.watch<GameProvider>();
    final backlog = context.watch<BacklogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog'),
        actions: isWide
            ? const [
                Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Center(
                    child: SizedBox(width: 400, child: _CatalogSearchBar()),
                  ),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          if (!isWide)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: _CatalogSearchBar(),
            ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(sidePadding, 12, 8, 12),
            child: Row(
              children: [
                for (final genre in genreOptions)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      label: genre.label,
                      selected: identical(genre, provider.selectedGenre),
                      onTap: () =>
                          context.read<GameProvider>().selectGenre(genre),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(child: _buildGrid(context, provider, backlog, sidePadding)),
        ],
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    GameProvider provider,
    BacklogProvider backlog,
    double sidePadding,
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

    final games = provider.games;
    if (games.isEmpty) {
      return const Center(child: Text('Tidak ada game yang cocok'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Breakpoints.catalogColumns(constraints.maxWidth);
        const spacing = 12.0;

        final itemWidth =
            (constraints.maxWidth - sidePadding * 2 - spacing * (columns - 1)) /
            columns;
        final textHeight = MediaQuery.textScalerOf(context).scale(36);
        final itemHeight = itemWidth * 9 / 16 + 28 + textHeight;

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(
            sidePadding,
            0,
            sidePadding,
            sidePadding,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            mainAxisExtent: itemHeight,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return GameCard(
              title: game.title,
              genre: game.genre,
              platform: game.platform,
              thumbnailUrl: game.thumbnail,
              status: backlog.statusOf(game.id),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GameDetailScreen(gameId: game.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CatalogSearchBar extends StatelessWidget {
  const _CatalogSearchBar();

  @override
  Widget build(BuildContext context) {
    return const SearchBar(
      hintText: 'Cari judul game…',
      leading: Icon(Icons.search),
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
    );
  }
}
