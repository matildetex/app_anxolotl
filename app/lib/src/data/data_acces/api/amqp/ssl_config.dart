import 'dart:convert';
import 'dart:io';

import 'package:anxolotl_app/globals/assets_path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SSLConfig {
  static const String caCertificatePath =
      "${AssetsPath.CERTIFICATES_ASSETS}ca_certificate.pem";
  static const String appKeyPath =
      "${AssetsPath.CERTIFICATES_ASSETS}app_key.pem";
  static const String appCertificatePath =
      "${AssetsPath.CERTIFICATES_ASSETS}app_certificate.pem";

  static Future<SecurityContext> getSSLConfig() async {
    SecurityContext ctx = SecurityContext(withTrustedRoots: true)
      ..setTrustedCertificatesBytes(await rootBundle
          .loadString(caCertificatePath)
          .then((value) => utf8.encode(value)))
      ..useCertificateChainBytes(await rootBundle
          .loadString(appCertificatePath)
          .then((value) => utf8.encode(value)))
      ..usePrivateKeyBytes(await rootBundle
          .loadString(appKeyPath)
          .then((value) => utf8.encode(value)));

    return ctx;
  }

  static Future<File> _getCertificateFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final buffer = byteData.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = "$tempPath/${path.split('/').last}";
    return File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}
