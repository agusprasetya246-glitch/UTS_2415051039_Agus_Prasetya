import 'package:flutter_test/flutter_test.dart';
import 'package:gameshelf/main.dart';

void main() {
  testWidgets('Halaman awal menampilkan nama aplikasi', (tester) async {
    await tester.pumpWidget(const GameShelfApp());
    expect(find.text('GameShelf'), findsOneWidget);
  });
}
