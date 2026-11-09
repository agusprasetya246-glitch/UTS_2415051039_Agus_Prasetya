import 'package:gameshelf/models/backlog_status.dart';

class BacklogItem {
  const BacklogItem({
    this.id,
    required this.studentId,
    required this.gameId,
    required this.title,
    required this.thumbnail,
    required this.status,
    this.rating = 0,
    this.hoursPlayed = 0,
    this.note = '',
    this.createdAt,
  });

  final String? id;
  final String studentId;
  final int gameId;
  final String title;
  final String thumbnail;
  final BacklogStatus status;

  final int rating;
  final int hoursPlayed;
  final String note;
  final DateTime? createdAt;

  factory BacklogItem.fromJson(Map<String, dynamic> json) {
    return BacklogItem(
      id: json['id'] as String?,
      studentId: json['student_id'] as String? ?? '',
      gameId: (json['game_id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      status: BacklogStatus.fromValue(json['status'] as String?),
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      hoursPlayed: (json['hours_played'] as num?)?.toInt() ?? 0,
      note: json['note'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'game_id': gameId,
      'title': title,
      'thumbnail': thumbnail,
      'status': status.value,
      'rating': rating,
      'hours_played': hoursPlayed,
      'note': note,
    };
  }

  BacklogItem copyWith({
    BacklogStatus? status,
    int? rating,
    int? hoursPlayed,
    String? note,
  }) {
    return BacklogItem(
      id: id,
      studentId: studentId,
      gameId: gameId,
      title: title,
      thumbnail: thumbnail,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      note: note ?? this.note,
      createdAt: createdAt,
    );
  }
}
