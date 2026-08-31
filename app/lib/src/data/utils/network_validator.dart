import 'dart:io';

class NetworkValidator {
  Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (E) {
      return false;
    }
  }
}
