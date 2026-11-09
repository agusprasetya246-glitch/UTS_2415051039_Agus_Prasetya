import 'package:flutter/material.dart';

import 'package:gameshelf/config/breakpoints.dart';
import 'package:gameshelf/config/genres.dart';
import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/widgets/category_chip.dart';
import 'package:gameshelf/widgets/game_card.dart';
import 'package:gameshelf/screens/game_detail_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = Breakpoints.isExpanded(MediaQuery.sizeOf(context).width);
    final sidePadding = isWide ? 24.0 : 16.0;

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
                      selected: genre.category == null,
                      onTap: () {},
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = Breakpoints.catalogColumns(
                  constraints.maxWidth,
                );
                const spacing = 12.0;

                final itemWidth =
                    (constraints.maxWidth -
                        sidePadding * 2 -
                        spacing * (columns - 1)) /
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
                  itemCount: dummyGames.length,
                  itemBuilder: (context, index) {
                    final game = dummyGames[index];
                    return GameCard(
                      title: game['title'] as String,
                      genre: game['genre'] as String,
                      platform: game['platform'] as String,
                      thumbnailUrl: game['thumbnail'] as String?,
                      status: dummyStatusOf(game['id'] as int),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              GameDetailScreen(gameId: game['id'] as int),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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
