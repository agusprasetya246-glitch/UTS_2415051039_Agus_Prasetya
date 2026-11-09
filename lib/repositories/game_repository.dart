import 'package:gameshelf/config/genres.dart';
import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/game_detail.dart';

class GameRepository {
  static const _fakeDelay = Duration(milliseconds: 600);

  Future<List<Game>> fetchGames({String? category}) async {
    await Future<void>.delayed(_fakeDelay);
    if (category == null) return dummyGames;

    final label = genreOptions
        .firstWhere((genre) => genre.category == category)
        .label;
    return dummyGames.where((game) => game.genre == label).toList();
  }

  Future<List<Game>> fetchPopularGames() async {
    await Future<void>.delayed(_fakeDelay);
    return dummyGames.take(5).toList();
  }

  Future<GameDetail> fetchGameDetail(int id) async {
    await Future<void>.delayed(_fakeDelay);
    return dummyDetailOf(id);
  }
}
