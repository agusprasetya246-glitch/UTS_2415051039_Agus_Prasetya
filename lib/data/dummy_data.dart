import 'package:gameshelf/models/backlog_item.dart';

const List<Map<String, dynamic>> _backlogJson = [
  {
    'id': 'b1',
    'student_id': '2415051039',
    'game_id': 452,
    'title': 'Call of Duty: Warzone',
    'thumbnail': 'https://www.freetogame.com/g/452/thumbnail.jpg',
    'status': 'ingin_main',
    'rating': 0,
    'hours_played': 0,
    'note': '',
    'created_at': '2026-11-09T08:00:00Z',
  },
  {
    'id': 'b2',
    'student_id': '2415051039',
    'game_id': 540,
    'title': 'Overwatch',
    'thumbnail': 'https://www.freetogame.com/g/540/thumbnail.jpg',
    'status': 'sedang_main',
    'rating': 4,
    'hours_played': 35,
    'note': 'Lagi push rank bareng teman, target naik satu tier minggu ini.',
    'created_at': '2026-11-02T10:00:00Z',
  },
  {
    'id': 'b3',
    'student_id': '2415051039',
    'game_id': 516,
    'title': 'PUBG: BATTLEGROUNDS',
    'thumbnail': 'https://www.freetogame.com/g/516/thumbnail.jpg',
    'status': 'ingin_main',
    'rating': 0,
    'hours_played': 0,
    'note': '',
    'created_at': '2026-10-28T09:00:00Z',
  },
  {
    'id': 'b4',
    'student_id': '2415051039',
    'game_id': 508,
    'title': 'Enlisted',
    'thumbnail': 'https://www.freetogame.com/g/508/thumbnail.jpg',
    'status': 'selesai',
    'rating': 3,
    'hours_played': 12,
    'note': '',
    'created_at': '2026-10-20T15:00:00Z',
  },
  {
    'id': 'b5',
    'student_id': '2415051039',
    'game_id': 642,
    'title': 'Neverness to Everness',
    'thumbnail': 'https://www.freetogame.com/g/642/thumbnail.jpg',
    'status': 'selesai',
    'rating': 5,
    'hours_played': 60,
    'note': '',
    'created_at': '2026-10-12T19:00:00Z',
  },
];

final List<BacklogItem> dummyBacklog = _backlogJson
    .map(BacklogItem.fromJson)
    .toList();
