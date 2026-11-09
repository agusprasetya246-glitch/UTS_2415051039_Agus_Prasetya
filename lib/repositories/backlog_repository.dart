import 'package:gameshelf/data/dummy_data.dart';
import 'package:gameshelf/models/backlog_item.dart';

class BacklogRepository {
  Future<List<BacklogItem>> fetchBacklog() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List.of(dummyBacklog);
  }
}
