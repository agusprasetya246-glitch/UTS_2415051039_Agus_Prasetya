import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/game_detail.dart';
import 'package:gameshelf/services/free_to_game_api_service.dart';

class GameRepository {
  GameRepository(this._service);

  final FreeToGameApiService _service;

  Future<List<Game>> fetchGames({String? category}) {
    return _service.fetchGames(category: category);
  }

  Future<List<Game>> fetchPopularGames() async {
    final games = await _service.fetchGames(sortBy: 'popularity');
    return games.take(10).toList();
  }

  Future<GameDetail> fetchGameDetail(int id) {
    return _service.fetchGameDetail(id);
  }
}
