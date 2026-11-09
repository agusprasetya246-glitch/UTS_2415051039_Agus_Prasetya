import 'package:flutter_test/flutter_test.dart';
import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/game_detail.dart';

void main() {
  test('Game.fromJson membaca respons /api/games', () {
    final game = Game.fromJson({
      'id': 540,
      'title': 'Overwatch',
      'thumbnail': 'https://www.freetogame.com/g/540/thumbnail.jpg',
      'short_description': 'A hero-focused first-person team shooter from Blizzard Entertainment.',
      'genre': 'Shooter',
      'platform': 'PC (Windows)',
      'publisher': 'Activision Blizzard',
      'developer': 'Blizzard Entertainment',
      'release_date': '2022-10-04',
    });

    expect(game.id, 540);
    expect(game.title, 'Overwatch');
    expect(game.isBrowserGame, isFalse);
  });

  test('GameDetail.fromJson membaca spesifikasi dan screenshot', () {
    final detail = GameDetail.fromJson({
      'id': 452,
      'title': 'Call of Duty: Warzone',
      'status': 'Live',
      'description': 'Paragraf satu.\r\n\r\nParagraf dua.',
      'platform': 'Windows',
      'minimum_system_requirements': {
        'os': 'Windows 10 64-Bit',
        'memory': '8GB RAM',
      },
      'screenshots': [
        {
          'id': 1124,
          'image':
              'https://www.freetogame.com/g/452/Call-of-Duty-Warzone-1.jpg',
        },
      ],
    });

    expect(detail.description, 'Paragraf satu.\n\nParagraf dua.');
    expect(detail.minimumSystemRequirements?.memory, '8GB RAM');
    expect(detail.minimumSystemRequirements?.processor, '-');
    expect(detail.screenshots, hasLength(1));
  });

  test('Game browser tanpa spesifikasi menghasilkan null', () {
    final detail = GameDetail.fromJson({
      'id': 6,
      'title': 'Krunker',
      'platform': 'Web Browser',
    });

    expect(detail.isBrowserGame, isTrue);
    expect(detail.minimumSystemRequirements, isNull);
    expect(detail.screenshots, isEmpty);
  });

  test('BacklogItem memakai nama kolom database', () {
    final item = BacklogItem.fromJson({
      'id': 'abc',
      'student_id': '2415051039',
      'game_id': 452,
      'title': 'Call of Duty: Warzone',
      'status': 'sedang_main',
      'rating': 4,
      'hours_played': 10,
      'created_at': '2026-11-09T08:00:00Z',
    });

    expect(item.status, BacklogStatus.playing);
    expect(item.createdAt, isNotNull);
    expect(item.toJson()['status'], 'sedang_main');
    expect(item.toJson().containsKey('id'), isFalse);
  });

  test('copyWith hanya mengubah field yang diberikan', () {
    const item = BacklogItem(
      studentId: '2415051039',
      gameId: 1,
      title: 'Warframe',
      thumbnail: '',
      status: BacklogStatus.wantToPlay,
    );
    final updated = item.copyWith(status: BacklogStatus.done, rating: 5);

    expect(updated.status, BacklogStatus.done);
    expect(updated.rating, 5);
    expect(updated.title, 'Warframe');
    expect(item.status, BacklogStatus.wantToPlay);
  });
}
