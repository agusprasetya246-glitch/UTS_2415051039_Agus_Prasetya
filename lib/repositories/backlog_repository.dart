import 'package:gameshelf/config/app_info.dart';
import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/services/backlog_supabase_service.dart';

class BacklogRepository {
  BacklogRepository(this._service);

  final BacklogSupabaseService _service;

  Future<List<BacklogItem>> fetchBacklog() {
    return _service.fetchAll(AppInfo.studentId);
  }
}
