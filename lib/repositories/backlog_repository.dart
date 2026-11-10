import 'package:gameshelf/config/app_info.dart';
import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/services/backlog_supabase_service.dart';

class BacklogRepository {
  BacklogRepository(this._service);

  final BacklogSupabaseService _service;

  Future<List<BacklogItem>> fetchBacklog() {
    return _service.fetchAll(AppInfo.studentId);
  }

  Future<BacklogItem> add({
    required Game game,
    required BacklogStatus status,
    required int rating,
    required int hoursPlayed,
    required String note,
  }) {
    final item = BacklogItem(
      studentId: AppInfo.studentId,
      gameId: game.id,
      title: game.title,
      thumbnail: game.thumbnail,
      status: status,
      rating: rating,
      hoursPlayed: hoursPlayed,
      note: note,
    );
    return _service.insert(item);
  }

  Future<BacklogItem> update(BacklogItem item) {
    return _service.update(item);
  }
}
