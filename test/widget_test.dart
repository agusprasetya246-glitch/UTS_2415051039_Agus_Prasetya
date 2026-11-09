import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gameshelf/models/backlog_status.dart';
import 'package:gameshelf/theme/app_theme.dart';
import 'package:gameshelf/widgets/game_card.dart';
import 'package:gameshelf/widgets/status_badge.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('GameCard menampilkan judul, genre, platform, dan badge', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          width: 220,
          child: GameCard(
            title: 'Overwatch',
            genre: 'Shooter',
            platform: 'PC (Windows)',
            status: BacklogStatus.playing,
          ),
        ),
      ),
    );

    expect(find.text('Overwatch'), findsOneWidget);
    expect(find.text('Shooter · PC (Windows)'), findsOneWidget);
    expect(find.text('Sedang main'), findsOneWidget);
  });

  testWidgets('StatusBadge memakai label dari enum', (tester) async {
    await tester.pumpWidget(
      _wrap(const StatusBadge(status: BacklogStatus.done)),
    );

    expect(find.text('Selesai'), findsOneWidget);
  });
}
