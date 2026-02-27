import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinningHttpClient {
  static const _certPath = 'assets/certificates/tmdb.pem';

  static Future<http.Client> create() async {
    final certData = await rootBundle.load(_certPath);
    final context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(certData.buffer.asUint8List());

    final client = HttpClient(context: context)
      ..badCertificateCallback = (_, __, ___) => false;

    return IOClient(client);
  }
}
