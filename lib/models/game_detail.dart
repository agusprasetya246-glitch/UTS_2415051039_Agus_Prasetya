import 'package:gameshelf/models/game.dart';

class GameDetail extends Game {
  const GameDetail({
    required super.id,
    required super.title,
    required super.thumbnail,
    required super.shortDescription,
    required super.genre,
    required super.platform,
    required super.publisher,
    required super.developer,
    required super.releaseDate,
    required super.gameUrl,
    required this.status,
    required this.description,
    required this.screenshots,
    this.minimumSystemRequirements,
  });

  final String status;
  final String description;

  final List<String> screenshots;

  final SystemRequirements? minimumSystemRequirements;

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    final game = Game.fromJson(json);
    final requirements = json['minimum_system_requirements'];
    final screenshots = json['screenshots'];

    return GameDetail(
      id: game.id,
      title: game.title,
      thumbnail: game.thumbnail,
      shortDescription: game.shortDescription,
      genre: game.genre,
      platform: game.platform,
      publisher: game.publisher,
      developer: game.developer,
      releaseDate: game.releaseDate,
      gameUrl: game.gameUrl,
      status: json['status'] as String? ?? '-',
      description: (json['description'] as String? ?? '')
          .replaceAll('\r\n', '\n')
          .trim(),
      screenshots: screenshots is List
          ? screenshots
                .whereType<Map<String, dynamic>>()
                .map((shot) => shot['image'] as String? ?? '')
                .toList()
          : const [],
      minimumSystemRequirements: requirements is Map<String, dynamic>
          ? SystemRequirements.fromJson(requirements)
          : null,
    );
  }
}

class SystemRequirements {
  const SystemRequirements({
    required this.os,
    required this.processor,
    required this.memory,
    required this.graphics,
    required this.storage,
  });

  final String os;
  final String processor;
  final String memory;
  final String graphics;
  final String storage;

  factory SystemRequirements.fromJson(Map<String, dynamic> json) {
    return SystemRequirements(
      os: json['os'] as String? ?? '-',
      processor: json['processor'] as String? ?? '-',
      memory: json['memory'] as String? ?? '-',
      graphics: json['graphics'] as String? ?? '-',
      storage: json['storage'] as String? ?? '-',
    );
  }
}
