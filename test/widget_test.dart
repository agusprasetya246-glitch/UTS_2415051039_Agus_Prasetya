import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:gameshelf/services/database_exception.dart';
import 'package:gameshelf/utils/error_message.dart';

void main() {
  group('friendlyErrorMessage', () {
    test('tanpa koneksi → pesan koneksi internet', () {
      expect(
        friendlyErrorMessage(const SocketException('Failed host lookup')),
        contains('koneksi internet'),
      );
      expect(
        friendlyErrorMessage(http.ClientException('Failed host lookup: x')),
        contains('koneksi internet'),
      );
    });

    test('timeout → pesan server lambat', () {
      expect(
        friendlyErrorMessage(TimeoutException('lambat')),
        contains('terlalu lama'),
      );
    });

    test('pesan DatabaseException diteruskan apa adanya', () {
      expect(
        friendlyErrorMessage(
          const DatabaseException('Game ini sudah ada di backlog'),
        ),
        'Game ini sudah ada di backlog',
      );
    });

    test('JSON rusak → pesan data tidak terbaca', () {
      expect(
        friendlyErrorMessage(const FormatException('bad json')),
        contains('tidak bisa dibaca'),
      );
    });

    test('error lain → pesan umum', () {
      expect(friendlyErrorMessage(Exception('?')), contains('tidak terduga'));
    });
  });
}
