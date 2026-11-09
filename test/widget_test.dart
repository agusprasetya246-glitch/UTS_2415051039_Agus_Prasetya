import 'package:flutter_test/flutter_test.dart';
import 'package:gameshelf/main.dart';

void main() {
  testWidgets('Halaman awal menampilkan nama aplikasi', (tester) async {
    await tester.pumpWidget(const GameShelfApp());
    // Tunggu data contoh selesai dimuat (jeda buatan 600 ms di repository).
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('GameShelf'), findsOneWidget);
  });
}
