import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gameshelf/models/backlog_item.dart';

class BacklogSupabaseService {
  BacklogSupabaseService(this._client);

  final SupabaseClient _client;
  static const String _table = 'game_backlog';

  Future<List<BacklogItem>> fetchAll(String studentId) async {
    final rows = await _client
        .from(_table)
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);

    return rows.map(BacklogItem.fromJson).toList();
  }
}
