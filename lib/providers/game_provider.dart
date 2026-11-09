import 'package:flutter/foundation.dart';

import 'package:gameshelf/config/genres.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/repositories/game_repository.dart';

class GameProvider extends ChangeNotifier {
  GameProvider(this._repository);

  final GameRepository _repository;

  List<Game> _games = [];
  GenreOption _selectedGenre = genreOptions.first;
  String _query = '';
  bool _isLoading = false;
  String? _error;
  int _requestId = 0;

  List<Game> _popularGames = [];
  bool _isLoadingPopular = false;
  String? _popularError;

  GenreOption get selectedGenre => _selectedGenre;
  String get query => _query;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Game> get games {
    final keyword = _query.trim().toLowerCase();
    if (keyword.isEmpty) return List.unmodifiable(_games);
    return _games
        .where((game) => game.title.toLowerCase().contains(keyword))
        .toList();
  }

  List<Game> get popularGames => List.unmodifiable(_popularGames);
  bool get isLoadingPopular => _isLoadingPopular;
  String? get popularError => _popularError;

  Future<void> loadGames() async {
    final requestId = ++_requestId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.fetchGames(
        category: _selectedGenre.category,
      );

      if (requestId != _requestId) return;
      _games = result;
    } catch (e) {
      if (requestId != _requestId) return;
      _error = 'Gagal memuat katalog. ($e)';
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectGenre(GenreOption genre) {
    if (identical(genre, _selectedGenre)) return;
    _selectedGenre = genre;
    loadGames();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> loadPopular() async {
    _isLoadingPopular = true;
    _popularError = null;
    notifyListeners();

    try {
      _popularGames = await _repository.fetchPopularGames();
    } catch (e) {
      _popularError = 'Gagal memuat game populer. ($e)';
    }

    _isLoadingPopular = false;
    notifyListeners();
  }
}
