import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:seaoil/core/services/api.dart';
import 'package:seaoil/core/utils/generic_exception.dart';
import 'package:seaoil/features/home/home.dart';
import 'package:seaoil/features/login/models/login_body.dart';
import 'package:seaoil/features/login/models/login_details.dart';

class LoginController extends GetxController {
  // Rx<LoginDetails> loginDetails = Rx<LoginDetails>(LoginDetails());
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  RxBool isLoading = false.obs;

  Future<void> login({
    required String mobNumber,
    required String pw,
    required String type,
  }) async {
    isLoading.value = true;
    try {
      print(
        jsonDecode(
          loginBodyToJson(
            LoginBody(
              mobileNumber: mobNumber,
              password: pw,
              profileType: type,
            ),
          ),
        ),
      );

      final http.Response response = await Api.post(
        'ms-profile/user/login',
        jsonDecode(
          loginBodyToJson(
            LoginBody(
              mobileNumber: mobNumber,
              password: pw,
              profileType: type,
            ),
          ),
        ),
      );
      LoginDetails loginDetails = loginDetailsFromJson(response.body);

      await _storage.write(
          key: 'accessToken', value: loginDetails.data!.accessToken);

      isLoading.value = false;

      Get.offAll(() => HomePage());
    } on GenericException catch (e) {
      isLoading.value = false;
      showGenericAlertDialog(context: Get.context!, error: e);
      throw e;
    }
  }
}
