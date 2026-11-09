const List<Map<String, dynamic>> dummyGames = [
  {
    'id': 1,
    'title': 'Warframe',
    'thumbnail': '',
    'short_description': 'Game aksi co-op orang ketiga bertema fiksi ilmiah.',
    'genre': 'Shooter',
    'platform': 'PC (Windows)',
  },
  {
    'id': 2,
    'title': 'Path of Exile',
    'thumbnail': '',
    'short_description':
        'Action RPG bergaya dark fantasy dengan sistem skill yang luas.',
    'genre': 'ARPG',
    'platform': 'PC (Windows)',
  },
  {
    'id': 3,
    'title': 'Albion Online',
    'thumbnail': '',
    'short_description':
        'MMORPG sandbox dengan ekonomi yang digerakkan pemain.',
    'genre': 'MMORPG',
    'platform': 'PC (Windows)',
  },
  {
    'id': 4,
    'title': 'Dota 2',
    'thumbnail': '',
    'short_description': 'MOBA 5 lawan 5 dengan ratusan hero.',
    'genre': 'MOBA',
    'platform': 'PC (Windows)',
  },
  {
    'id': 5,
    'title': 'Brawlhalla',
    'thumbnail': '',
    'short_description': 'Game fighting platform untuk banyak pemain.',
    'genre': 'Fighting',
    'platform': 'PC (Windows)',
  },
  {
    'id': 6,
    'title': 'Krunker',
    'thumbnail': '',
    'short_description':
        'Shooter orang pertama yang dimainkan langsung di browser.',
    'genre': 'Shooter',
    'platform': 'Web Browser',
  },
  {
    'id': 7,
    'title': 'Destiny 2',
    'thumbnail': '',
    'short_description': 'Shooter aksi online dengan misi co-op dan PvP.',
    'genre': 'Shooter',
    'platform': 'PC (Windows)',
  },
  {
    'id': 8,
    'title': 'Hearthstone',
    'thumbnail': '',
    'short_description': 'Game kartu strategi dengan pertandingan cepat.',
    'genre': 'Card Game',
    'platform': 'PC (Windows)',
  },
];

const Map<String, dynamic> dummyGameDetail = {
  'id': 1,
  'title': 'Warframe',
  'thumbnail': '',
  'status': 'Live',
  'short_description': 'A cooperative free-to-play third person online action game set in an evolving sci-fi world.',
  'description':
      'Warframe is a cooperative free-to-play third person online action game set in an evolving sci-fi world. '
      'Players control members of the Tenno, an ancient race of warriors who have awoken from centuries of '
      'cryo-sleep to find themselves at war with different factions of the Origin System.',
  'genre': 'Shooter',
  'platform': 'PC (Windows)',
  'publisher': 'Digital Extremes',
  'developer': 'Digital Extremes',
  'release_date': '2013-03-25',
  'minimum_system_requirements': {
    'os': 'Windows 7 64-bit',
    'processor': 'Intel Core i7 860 / AMD FX-4100',
    'memory': '4 GB RAM',
    'graphics': 'DirectX 11 compatible',
    'storage': '50 GB',
  },
  'screenshots': [
    {'id': 1, 'image': ''},
    {'id': 2, 'image': ''},
    {'id': 3, 'image': ''},
  ],
};

const List<Map<String, dynamic>> dummyBacklog = [
  {
    'id': 'b1',
    'student_id': '2415051039',
    'game_id': 1,
    'title': 'Warframe',
    'thumbnail': '',
    'status': 'ingin_main',
    'rating': 0,
    'hours_played': 0,
    'note': '',
    'created_at': '2026-11-09T08:00:00Z',
  },
  {
    'id': 'b2',
    'student_id': '2415051039',
    'game_id': 3,
    'title': 'Albion Online',
    'thumbnail': '',
    'status': 'sedang_main',
    'rating': 4,
    'hours_played': 35,
    'note': 'Lagi naikin level gathering, target ikut guild minggu depan.',
    'created_at': '2026-11-02T10:00:00Z',
  },
  {
    'id': 'b3',
    'student_id': '2415051039',
    'game_id': 2,
    'title': 'Path of Exile',
    'thumbnail': '',
    'status': 'ingin_main',
    'rating': 0,
    'hours_played': 0,
    'note': '',
    'created_at': '2026-10-28T09:00:00Z',
  },
  {
    'id': 'b4',
    'student_id': '2415051039',
    'game_id': 5,
    'title': 'Brawlhalla',
    'thumbnail': '',
    'status': 'selesai',
    'rating': 3,
    'hours_played': 12,
    'note': '',
    'created_at': '2026-10-20T15:00:00Z',
  },
  {
    'id': 'b5',
    'student_id': '2415051039',
    'game_id': 7,
    'title': 'Destiny 2',
    'thumbnail': '',
    'status': 'selesai',
    'rating': 5,
    'hours_played': 60,
    'note': '',
    'created_at': '2026-10-12T19:00:00Z',
  },
];

String? dummyStatusOf(int gameId) {
  for (final item in dummyBacklog) {
    if (item['game_id'] == gameId) return item['status'] as String;
  }
  return null;
}

Map<String, dynamic> dummyDetailOf(int gameId) {
  if (gameId == dummyGameDetail['id']) return dummyGameDetail;

  final game = dummyGames.firstWhere((g) => g['id'] == gameId);
  return {
    ...game,
    'status': 'Live',
    'description': game['short_description'],
    'publisher': '-',
    'developer': '-',
    'release_date': '-',
    'minimum_system_requirements': null,
    'screenshots': <Map<String, dynamic>>[],
  };
}
