import 'package:flutter/material.dart';

import 'package:gameshelf/config/genres.dart';
import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/widgets/category_chip.dart';
import 'package:gameshelf/widgets/game_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Katalog')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: SearchBar(
              hintText: 'Cari judul game…',
              leading: Icon(Icons.search),
              elevation: WidgetStatePropertyAll(0),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
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
                const columns = 2;
                const spacing = 12.0;
                const sidePadding = 16.0;

                final itemWidth =
                    (constraints.maxWidth -
                        sidePadding * 2 -
                        spacing * (columns - 1)) /
                    columns;
                // Tinggi kartu = thumbnail 16:9 + padding + dua baris teks
                final textHeight = MediaQuery.textScalerOf(context).scale(36);
                final itemHeight = itemWidth * 9 / 16 + 28 + textHeight;

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
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
