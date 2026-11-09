import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/game_detail.dart';
import 'package:gameshelf/services/api_exception.dart';

class FreeToGameApiService {
  FreeToGameApiService({http.Client? client})
    : _client = client ?? http.Client();

  static const String _host = 'www.freetogame.com';
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  Future<List<Game>> fetchGames({String? category, String? sortBy}) async {
    final params = <String, String>{
      if (category != null) 'category': category,
      if (sortBy != null) 'sort-by': sortBy,
    };
    final uri = Uri.https(_host, '/api/games', params.isEmpty ? null : params);
    final data = await _getJson(uri);

    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(Game.fromJson).toList();
  }

  Future<GameDetail> fetchGameDetail(int id) async {
    final uri = Uri.https(_host, '/api/game', {'id': '$id'});
    final data = await _getJson(uri);

    if (data is! Map<String, dynamic>) {
      throw const ApiException('Format data detail game tidak dikenali');
    }
    return GameDetail.fromJson(data);
  }

  Future<dynamic> _getJson(Uri uri) async {
    final response = await _client.get(uri).timeout(_timeout);

    if (response.statusCode == 404) {
      throw const ApiException('Data tidak ditemukan (404)');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Server mengembalikan status ${response.statusCode}');
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
