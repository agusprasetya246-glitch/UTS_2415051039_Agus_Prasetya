import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameshelf/config/breakpoints.dart';
import 'package:gameshelf/config/genres.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/providers/backlog_provider.dart';
import 'package:gameshelf/providers/game_provider.dart';
import 'package:gameshelf/screens/game_detail_screen.dart';
import 'package:gameshelf/utils/error_message.dart';
import 'package:gameshelf/widgets/category_chip.dart';
import 'package:gameshelf/widgets/game_card.dart';
import 'package:gameshelf/widgets/state_view.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = context.read<GameProvider>().query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<GameProvider>().setQuery('');
  }

  void _resetFilters() {
    _searchController.clear();
    context.read<GameProvider>().resetFilters();
  }

  Future<void> _refresh() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<GameProvider>().refreshGames();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(friendlyErrorMessage(e))));
    }
  }

  void _openDetail(Game game) {
    FocusScope.of(context).unfocus(); // tutup keyboard dulu
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameDetailScreen(gameId: game.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final backlog = context.watch<BacklogProvider>();

    // MediaQuery: keputusan tingkat layar (letak search bar).
    final isWide = Breakpoints.isExpanded(MediaQuery.sizeOf(context).width);
    final padding = isWide ? 24.0 : 16.0;

    final searchBar = _CatalogSearchBar(
      controller: _searchController,
      onChanged: context.read<GameProvider>().setQuery,
      onClear: _clearSearch,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog'),
        toolbarHeight: isWide ? 88 : null,
        actions: [
          if (isWide)
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SizedBox(width: 420, child: searchBar),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isWide)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: searchBar,
            ),
          _buildGenres(provider, padding, wrap: isWide),
          Expanded(child: _buildGrid(provider, backlog, padding)),
        ],
      ),
    );
  }

  Widget _buildGenres(
    GameProvider provider,
    double padding, {
    required bool wrap,
  }) {
    final chips = [
      for (final genre in genreOptions)
        CategoryChip(
          label: genre.label,
          selected: identical(genre, provider.selectedGenre),
          onTap: () => provider.selectGenre(genre),
        ),
    ];

    if (wrap) {
      return Padding(
        padding: EdgeInsets.fromLTRB(padding, 8, padding, 16),
        child: Wrap(spacing: 8, runSpacing: 8, children: chips),
      );
    }

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
        itemCount: chips.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) => chips[index],
      ),
    );
  }

  Widget _buildGrid(
    GameProvider provider,
    BacklogProvider backlog,
    double padding,
  ) {
    if (provider.isLoading) {
      return const StateView.loading(message: 'Memuat katalog game…');
    }

    final error = provider.error;
    if (error != null) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: StateView.error(
          title: 'Gagal memuat katalog',
          message: error,
          onRetry: () => context.read<GameProvider>().loadGames(),
        ),
      );
    }

    final games = provider.games;
    if (games.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: StateView.empty(
          icon: Icons.search_off,
          title: 'Tidak ada game yang cocok',
          message: 'Coba kata kunci lain atau pilih genre Semua.',
          actionLabel: 'Reset filter',
          onAction: _resetFilters,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Breakpoints.catalogColumns(constraints.maxWidth);
        final spacing = columns > 2 ? 16.0 : 12.0;
        final itemWidth =
            (constraints.maxWidth - padding * 2 - spacing * (columns - 1)) /
            columns;
        final textScaler = MediaQuery.textScalerOf(context);
        final itemHeight = itemWidth * 9 / 16 + 28 + textScaler.scale(36);

        return RefreshIndicator(
          onRefresh: _refresh,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            // Keyboard tertutup saat grid digulir.
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(padding, 4, padding, padding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
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
                onTap: () => _openDetail(game),
              );
            },
          ),
        );
      },
    );
  }
}

class _CatalogSearchBar extends StatelessWidget {
  const _CatalogSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      hintText: 'Cari judul game…',
      leading: const Icon(Icons.search),
      trailing: [
        if (controller.text.isNotEmpty)
          IconButton(
            tooltip: 'Hapus pencarian',
            icon: const Icon(Icons.close),
            onPressed: onClear,
          ),
      ],
      onChanged: onChanged,
      elevation: const WidgetStatePropertyAll(0),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
