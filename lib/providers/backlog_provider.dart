import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/repositories/backlog_repository.dart';
import 'package:gameshelf/utils/error_message.dart';

class BacklogProvider extends ChangeNotifier {
  BacklogProvider(this._repository);

  final BacklogRepository _repository;
  final Random _random = Random();

  List<BacklogItem> _items = [];
  bool _isLoading = false;
  String? _error;

  BacklogStatus? _filter;

  bool get isLoading => _isLoading;
  String? get error => _error;
  BacklogStatus? get filter => _filter;

  List<BacklogItem> get items => List.unmodifiable(_items);

  List<BacklogItem> get filteredItems {
    final filter = _filter;
    if (filter == null) return items;
    return _items.where((item) => item.status == filter).toList();
  }

  int get totalHours =>
      _items.fold<int>(0, (sum, item) => sum + item.hoursPlayed);

  int countOf(BacklogStatus status) =>
      _items.where((item) => item.status == status).length;

  BacklogItem? itemForGame(int gameId) {
    for (final item in _items) {
      if (item.gameId == gameId) return item;
    }
    return null;
  }

  BacklogStatus? statusOf(int gameId) => itemForGame(gameId)?.status;

  BacklogItem? randomWantToPlay() {
    final candidates = _items
        .where((item) => item.status == BacklogStatus.wantToPlay)
        .toList();
    if (candidates.isEmpty) return null;
    return candidates[_random.nextInt(candidates.length)];
  }

  void setFilter(BacklogStatus? status) {
    if (_filter == status) return;
    _filter = status;
    notifyListeners();
  }

  /// READ dari Supabase dengan spinner (muat awal dan tombol "Coba lagi").
  Future<void> loadBacklog() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _repository.fetchBacklog();
    } catch (e) {
      _error = friendlyErrorMessage(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      _items = await _repository.fetchBacklog();
      _error = null;
    } catch (e) {
      if (_error == null && _items.isNotEmpty) rethrow;
      _error = friendlyErrorMessage(e);
    }
    notifyListeners();
  }

  /// CREATE: menyimpan game ke backlog.
  Future<void> add({
    required Game game,
    required BacklogStatus status,
    required int rating,
    required int hoursPlayed,
    required String note,
  }) async {
    final created = await _repository.add(
      game: game,
      status: status,
      rating: rating,
      hoursPlayed: hoursPlayed,
      note: note,
    );
    _items = [created, ..._items];
    notifyListeners();
  }

  /// UPDATE: menyimpan perubahan, lalu mengganti item lama di daftar.
  Future<void> update(BacklogItem item) async {
    final updated = await _repository.update(item);
    _items = [
      for (final current in _items)
        if (current.id == updated.id) updated else current,
    ];
    notifyListeners();
  }

  /// DELETE: menghapus dari database dulu, baru dari daftar.
  Future<void> remove(BacklogItem item) async {
    final id = item.id;
    if (id == null) return;

    await _repository.remove(id);
    _items = _items.where((current) => current.id != id).toList();
    notifyListeners();
  }
}
