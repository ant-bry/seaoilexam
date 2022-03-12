import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    checkForAccount();
    super.onInit();
  }

  Future<void> checkForAccount() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }
}
