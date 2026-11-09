class GenreOption {
  const GenreOption(this.label, this.category);

  final String label;
  final String? category;
}

const List<GenreOption> genreOptions = [
  GenreOption('Semua', null),
  GenreOption('Shooter', 'shooter'),
  GenreOption('MMORPG', 'mmorpg'),
  GenreOption('MOBA', 'moba'),
  GenreOption('ARPG', 'action-rpg'),
  GenreOption('Fighting', 'fighting'),
  GenreOption('Card Game', 'card'),
];
