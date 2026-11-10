import 'package:flutter/foundation.dart';

import 'package:gameshelf/models/game_detail.dart';
import 'package:gameshelf/repositories/game_repository.dart';
import 'package:gameshelf/utils/error_message.dart';

class GameDetailProvider extends ChangeNotifier {
  GameDetailProvider(this._repository, this.gameId);

  final GameRepository _repository;
  final int gameId;

  GameDetail? _detail;
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  GameDetail? get detail => _detail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    _notify();

    try {
      _detail = await _repository.fetchGameDetail(gameId);
    } catch (e) {
      _error = friendlyErrorMessage(e);
    }

    _isLoading = false;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
