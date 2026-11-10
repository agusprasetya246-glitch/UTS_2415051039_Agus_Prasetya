import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gameshelf/services/api_exception.dart';
import 'package:gameshelf/services/database_exception.dart';

String friendlyErrorMessage(Object error) {
  debugPrint('[GameShelf] $error');

  if (error is ApiException) return error.message;
  if (error is DatabaseException) return error.message;

  if (error is TimeoutException) {
    return 'Server terlalu lama merespons. Coba lagi sebentar lagi.';
  }
  if (error is SocketException ||
      error is http.ClientException ||
      _looksLikeNetworkError(error)) {
    return 'Tidak bisa terhubung ke server. '
        'Periksa koneksi internet, lalu coba lagi.';
  }
  if (error is FormatException) {
    return 'Data dari server tidak bisa dibaca. Coba lagi nanti.';
  }
  if (error is PostgrestException) {
    return 'Terjadi masalah pada database. Coba lagi nanti.';
  }
  return 'Terjadi kesalahan yang tidak terduga. Coba lagi.';
}

bool _looksLikeNetworkError(Object error) {
  final text = error.toString();
  return text.contains('Failed host lookup') ||
      text.contains('SocketException') ||
      text.contains('Connection refused') ||
      text.contains('Network is unreachable');
}
