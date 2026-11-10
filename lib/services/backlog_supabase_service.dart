import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gameshelf/models/backlog_item.dart';
import 'package:gameshelf/services/database_exception.dart';

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

  Future<BacklogItem> insert(BacklogItem item) async {
    try {
      final row = await _client
          .from(_table)
          .insert(item.toJson())
          .select()
          .single();
      return BacklogItem.fromJson(row);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw const DatabaseException('Game ini sudah ada di backlog');
      }
      throw DatabaseException('Gagal menyimpan ke database (${e.message})');
    }
  }

  Future<BacklogItem> update(BacklogItem item) async {
    final id = item.id;
    if (id == null) {
      throw const DatabaseException('Data belum tersimpan, tidak bisa diubah');
    }

    try {
      final row = await _client
          .from(_table)
          .update({
            'status': item.status.value,
            'rating': item.rating,
            'hours_played': item.hoursPlayed,
            'note': item.note,
          })
          .eq('id', id)
          .select()
          .single();
      return BacklogItem.fromJson(row);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const DatabaseException('Data ini sudah tidak ada di database');
      }
      throw DatabaseException('Gagal memperbarui data (${e.message})');
    }
  }
}
