import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  static FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> write(String? key, String? value) async =>
      storage.write(key: key!, value: value);

  static Future<dynamic> read(String? key) {
    return storage.read(key: key!);
  }

  static Future<void> deleteAll() async => storage.deleteAll();

  static FlutterSecureStorage getStorage(FlutterSecureStorage mockStorage) {
    return storage = mockStorage;
  }
}
