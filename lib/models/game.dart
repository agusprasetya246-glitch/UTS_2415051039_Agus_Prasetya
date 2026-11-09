class Game {
  const Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.shortDescription,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.gameUrl,
  });

  final int id;
  final String title;
  final String thumbnail;
  final String shortDescription;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final String gameUrl;

  bool get isBrowserGame => platform.toLowerCase().contains('browser');

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      genre: (json['genre'] as String? ?? '').trim(),
      platform: json['platform'] as String? ?? '',
      publisher: json['publisher'] as String? ?? '',
      developer: json['developer'] as String? ?? '',
      releaseDate: json['release_date'] as String? ?? '',
      gameUrl: json['game_url'] as String? ?? '',
    );
  }
}
