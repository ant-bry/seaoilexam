import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:seaoil/config/env.dart';
import 'package:seaoil/core/utils/generic_exception.dart';

class Api {
  static String uri = FlavorConfig.instance!.values.baseUrl;

  static Duration timeoutDuration = FlavorConfig.instance!.apiTimeoutDuration;

  static http.Client client = http.Client();

  static Future<Map<String, String>> headers({required bool authorized}) async {
    Map<String, String> headers = <String, String>{
      'accept': 'application/json',
      'content-type': 'application/json',
    };

    if (authorized) {
      final FlutterSecureStorage _storage = FlutterSecureStorage();

      // final username = await _storage.read(key: Keys.email);
      // final password = await _storage.read(key: Keys.password);

      final String? username = await _storage.read(key: '');
      final String? password = await _storage.read(key: '');

      final String basicSuffix =
          base64.encode(utf8.encode('$username:$password'));

      headers['Authorization'] = 'Basic $basicSuffix';
    }

    return headers;
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? body,
    bool authorized = true,
  }) async {
    try {
      final Map<String, String> headers =
          await Api.headers(authorized: authorized);

      final Response response = await client
          .get(Uri.parse('$uri/$path'), headers: headers)
          .timeout(timeoutDuration);

      _validateResponse(response);

      return response;
    } on ClientException catch (error) {
      throw GenericException.clientException(error);
    } on SocketException catch (error) {
      throw GenericException.socketException(error);
    } on FormatException catch (error) {
      throw GenericException.formatException(error);
    } on TimeoutException catch (error) {
      throw error;
    }
  }

  static Future<Response> put(
    String path, {
    Map<String, dynamic>? body,
    bool authorized = true,
  }) async {
    try {
      final Map<String, String> headers =
          await Api.headers(authorized: authorized);

      final Response response = await client
          .put(
            Uri.parse('$uri/$path'),
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(timeoutDuration);

      _validateResponse(response);

      return response;
    } on ClientException catch (error) {
      throw GenericException.clientException(error);
    } on SocketException catch (error) {
      throw GenericException.socketException(error);
    } on FormatException catch (error) {
      throw GenericException.formatException(error);
    } on TimeoutException catch (error) {
      throw error;
    }
  }

  static Future<Response> delete(
    String path, {
    Map<String, dynamic>? body,
    bool authorized = true,
  }) async {
    try {
      final Map<String, String> headers =
          await Api.headers(authorized: authorized);

      final Response response = await client
          .delete(
            Uri.parse('$uri/$path'),
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(timeoutDuration);

      _validateResponse(response);

      return response;
    } on ClientException catch (error) {
      throw GenericException.clientException(error);
    } on SocketException catch (error) {
      throw GenericException.socketException(error);
    } on FormatException catch (error) {
      throw GenericException.formatException(error);
    } on TimeoutException catch (error) {
      throw error;
    }
  }

  static Future<Response> post(String path, Map<String, dynamic> body,
      {bool authorized = true}) async {
    try {
      final Map<String, String> headers =
          await Api.headers(authorized: authorized);

      final Response response = await client
          .post(
            Uri.parse('$uri/$path'),
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(timeoutDuration);

      _validateResponse(response);

      return response;
    } on ClientException catch (error) {
      throw GenericException.clientException(error);
    } on SocketException catch (error) {
      throw GenericException.socketException(error);
    } on FormatException catch (error) {
      throw GenericException.formatException(error);
    } on TimeoutException catch (error) {
      throw error;
    }
  }

  static void _validateResponse(Response response) {
    if (response.headers['content-type'] == 'application/json') {
      // Succeeds or throws FormatException
      jsonDecode(response.body);
    }

    if (response.statusCode < 200 || response.statusCode > 299) {
      throw GenericException.httpResponse(response);
    }
    return;
  }

  static Client getClient(http.Client mockClient) {
    return client = mockClient;
  }
}
